{{ config(
    tags = ["report"]
    ) }}

with cte_internal_allocations_raw as (
    select
        trade_date            as trade_date
        , lower(custodian)    as custodian
        , max(account_number) as account_number
        , portfolio_id        as trading_id
        , symbol              as symbol
        , cusip               as cusip
        , lower(order_side)   as order_side
        -- Debbie asking for broker name to be included. It's possible this
        -- could throw things off if there are multiple trades for an acct/cusip/day
        -- across more than one broker.
        , broker_name         as broker_name
        , case
            when lower(order_side) = 'buy'
                then sum(quantity)
            when lower(order_side) = 'sell'
                then sum(quantity) * -1
            else
                sum(quantity)
        end                   as quantity
    from {{ ref('moxy__fct_allocations') }}
    where 1 = 1
        and trade_date >= dateadd('DAY' , -7 , current_date())
        -- Exclude today's trades. This isn't usually necessary but is needed
        -- if running the report later in the day.
        and trade_date <> current_date()
        -- Exclude pending. These are what invops adds at times and will
        -- mess up this report. Debbie requested.
        and coalesce(broker_name , '') not ilike 'pending'
    group by all
)

, cte_internal_prices as (
    select
        trade_date
        , account_number
        , symbol
        , cusip
        , source_security_type
        , max(price) as price
    from {{ ref('moxy__fct_allocations') }}
    where 1 = 1
        and trade_date >= dateadd('DAY' , -7 , current_date())
        -- Exclude today's trades. This isn't usually necessary but is needed
        -- if running the report later in the day.
        and trade_date <> current_date()
    group by all
)

, cte_oms_accounts as (
    select account_number
    from {{ ref ('moxy__stg_accounts') }}
    where 1 = 1
        and _created_at >= current_date() - 7
        and close_date is null
    group by all
)

, cte_mis_accounts as (
    select
        account_number
        , model
        , trading_id
        -- In case there are ever dupes we'll use these fields to ensure we don't
        -- fan things out.
        , row_number() over (
            partition by account_number
            order by trading_id desc
        ) as rn_account_number
        , row_number() over (
            partition by trading_id
            order by account_number desc
        ) as rn_trading_id
    from {{ ref('mis__accounts') }}
    where 1 = 1
        and is_active = 1
        and (
            is_moxy = 1
            or account_number in (select cte_os.account_number from cte_oms_accounts as cte_os)
        )
)

, cte_all_accounts as (
    select account_number
    from cte_mis_accounts

    union distinct

    select distinct account_number from cte_internal_allocations_raw
)

, cte_internal_allocations as (
    -- For the internal allocations we have to join to estate item to arrive at the
    -- account_number. Sometimes the timing doesn't work out or the SF record is dirty.
    -- Here we make sure to try and bring in the account_number if it's missing from
    -- the internal allocation records.
    select
        a.trade_date                                                       as trade_date
        , a.custodian                                                      as custodian
        , coalesce(a.account_number , b.account_number , c.account_number) as account_number
        , a.symbol                                                         as symbol
        , a.cusip                                                          as cusip
        , a.order_side                                                     as order_side
        , a.quantity                                                       as quantity
        , a.broker_name                                                    as broker_name
    from cte_internal_allocations_raw as a
    left join cte_mis_accounts as b
        on a.trading_id = b.trading_id
        and b.rn_trading_id = 1
    left join cte_mis_accounts as c
        on a.account_number = c.account_number
        and b.rn_account_number = 1
)

, cte_internal_cusips as (
    select cusip from cte_internal_allocations
    group by all
)

, cte_external_trades as (
    select
        t.date                as date
        , t.custodian         as custodian
        , t.account_number    as account_number
        , t.symbol            as symbol
        , t.cusip             as cusip
        , t.asset_class       as asset_class
        , t.product_id        as product_id
        , t.product_name      as product_name
        , t.product_type      as product_type
        , t.product_category  as product_category
        , t.is_custodial_cash as is_custodial_cash
        , t.asset_id          as asset_id
        -- This previously took the max() but that was combining orders/sells
        -- in a way that messed with the matching.
        , case
            when t.buy_sell is not null
                then lower(t.buy_sell)
            -- Trading expenses don't come through with attributes that directly
            -- tie it to the related trade, nor does it explicity indicate if the
            -- related trade was a buy or sell. Here we use the transaction notes
            -- to derive the order side.
            when t.notes ilike '%SC_BCC_TRADE%'
                then 'buy'
            when t.notes ilike '%SC_SELL_TRADE'
                then 'sell'
            -- If not able to derive from the notes we'll use the directionality.
            -- Not sure how reliable this is.
            when t.quantity > 0
                then 'buy'
            when t.quantity < 0
                then 'sell'
        end::text             as order_side
        , sum(t.quantity)     as quantity
    from {{ ref ('mis__stg_orion_transactions') }} as t
    inner join cte_all_accounts as a
        on t.account_number = a.account_number
    left join cte_internal_cusips as ic
        on t.cusip = ic.cusip
    where 1 = 1
        and t.rn = 1
        and t.fkalclient = 568

        and (lower(t.buy_sell) in ('buy' , 'sell') or t.type_name = 'Trading Expense')
        and t.date >= dateadd('DAY' , -7 , current_date())
        and (
            -- Generally we want to exclude custodial cash.
            -- But, some MMF, like FZDXX (and other fid MMF), are trading like an equity, despite
            -- functioning like custodial cash.
            coalesce(t.is_custodial_cash , 0) = 0
            -- In case it's custodial cash but exists as a security on the internal
            -- side. Then we bypass the filter above.
            or ic.cusip is not null
        )
        -- Exclude rejected trades
        and lower(t.trade_status) not in ('rejected' , 'reversed' , 'pending')
        -- Exclude dividend reinvestment per Debbie W 12/6/24
        and coalesce(t.notes , '') not ilike '%REINVEST DIVIDEND%'
    group by all
    -- Exclude trades that might have washed when aggregated.
    having abs(sum(t.quantity)) > 0
)

select
    -- These fields are used by invops to perform an upload into Moxy for
    --   "Internal Unmatched" transactions.
    coalesce(i.trade_date , e.date)                 as "Date"
    , acc.trading_id::text                          as "Port"
    , case
        when i.order_side = 'buy'
            then 'by'
        when i.order_side = 'sell'
            then 'sl'
        when i.order_side = 'cover'
            then 'cs'
        else i.order_side
    end::text                                       as "Transaction"
    , i.symbol::text                                as "Symbol"--noqa: AL08
    , ip.source_security_type::text                 as "SecType"
    , 'Pending'::text                               as "Broker"
    -- The import invops does for the pendings needs positive values, regardless.
    , abs(i.quantity::decimal(20 , 2))              as "Place"
    , abs(i.quantity::decimal(20 , 2))              as "Quantity"
    , ip.price::decimal(20 , 5)                     as "AvgPrice"
    , abs(i.quantity::decimal(20 , 2))              as "Fill"

    -- These fields are the normal trade match fields and may be duplicated above.
    , coalesce(i.trade_date , e.date)               as trade_date
    , coalesce(i.custodian , e.custodian)           as custodian
    , coalesce(i.account_number , e.account_number) as account_number
    , coalesce(i.symbol , e.symbol)                 as symbol--noqa: disable=AL08--noqa: AL08
    , coalesce(i.cusip , e.cusip)                   as cusip
    , coalesce(i.order_side , e.order_side)         as order_side
    , case
        when e.asset_class ilike 'options'
            then i.quantity * 100
        else i.quantity
    end::decimal(17 , 2)                            as internal_units
    , e.quantity::decimal(17 , 2)                   as external_units
    , internal_units - external_units               as units_diff
    , case
        when internal_units is null
            then 'Unmatched External'
        when external_units is null
            then 'Unmatched Internal'
        when units_diff is not null
            and (units_diff <> 0)
            and (
                abs(div0(units_diff , internal_units)) < 0.01 and internal_units <> 0
            ) is not null
            and units_diff <> 0
            and (
                abs(div0(units_diff , internal_units)) < 0.01 and internal_units <> 0
            ) then 'Trade Matched'
        when units_diff is not null and units_diff <> 0 then 'Internal/External Discrepancy'
        when units_diff = 0 then 'Trade Matched'
    end                                             as match_type
    , case
        when match_type ilike 'trade matched'
            then 1
        else 0
    end::int                                        as is_match

    , acc.trading_id                                as trading_id
    , acc.model                                     as model
    , i.broker_name                                 as moxy_broker
    , e.product_name                                as product_name
    , e.asset_class                                 as asset_class
    , e.product_type                                as product_type
    , e.product_category                            as product_category
    , e.product_id                                  as product_id
    , e.asset_id                                    as asset_id
from cte_internal_allocations as i
full outer join cte_external_trades as e
    on i.trade_date = e.date
    --and lower(i.custodian) = lower(e.custodian)
    and i.account_number = e.account_number
    and upper(i.symbol) = upper(e.symbol)
    and lower(i.order_side) = lower(e.order_side)
left join cte_all_accounts as a
    on coalesce(i.account_number , e.account_number) = a.account_number
left join cte_mis_accounts as acc
    on coalesce(i.account_number , e.account_number) = acc.account_number
left join cte_internal_prices as ip
    on i.account_number = ip.account_number
    and i.trade_date = ip.trade_date
    and i.symbol = ip.symbol
    and i.cusip = ip.cusip
