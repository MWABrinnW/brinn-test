{{ config(
    tags = ["report"]
    ) }}

with cte_internal_allocations as (
    select
        trade_date
        , lower(custodian)  as custodian
        , account_number    as account_number
        , symbol            as symbol
        , cusip             as cusip
        , lower(order_side) as order_side
        , case
            when lower(order_side) = 'buy'
                then sum(quantity)
            when lower(order_side) = 'sell'
                then sum(quantity) * -1
            else
                sum(quantity)
        end                 as quantity
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

    select distinct account_number from cte_internal_allocations
)

, cte_external_trades as (
    select
        t.date                   as date
        , t.custodian            as custodian
        , t.account_number       as account_number
        , t.symbol               as symbol
        , t.cusip                as cusip
        , t.asset_class          as asset_class
        , t.product_id           as product_id
        , t.product_name         as product_name
        , t.product_type         as product_type
        , t.product_category     as product_category
        , t.is_custodial_cash    as is_custodial_cash
        , t.asset_id             as asset_id
        , max(lower(t.buy_sell)) as order_side
        , sum(t.quantity)        as quantity
    from {{ ref ('mis__stg_orion_transactions') }} as t
    inner join cte_all_accounts as a
        on t.account_number = a.account_number
    where 1 = 1
        and t.rn = 1
        and t.fkalclient = 568

        and (lower(t.buy_sell) in ('buy' , 'sell') or t.type_name = 'Trading Expense')
        and t.date >= dateadd('DAY' , -7 , current_date())
        and coalesce(t.is_custodial_cash , 0) = 0
        -- Exclude rejected trades
        and lower(t.trade_status) not in ('rejected' , 'reversed' , 'pending')
        -- Exclude dividend reinvestment per Debbie W 12/6/24
        and coalesce(t.notes , '') not ilike '%REINVEST DIVIDEND%'
    group by all
)

select
    -- These fields are used by invops to perform an upload into moxy for certain transactions.
    coalesce(i.trade_date , e.date)                 as "Date"
    , null::text                                    as "Port"
    , null::text                                    as "Transaction"
    --, coalesce(i.symbol , e.symbol)                 as "Symbol"
    , null::text                                    as "SecType"
    , null::text                                    as "Broker"
    , null::text                                    as "Place"
    , e.quantity::decimal(20 , 2)                   as "Quantity"
    , null::decimal(20 , 5)                         as "AvgPrice"
    , null::text                                    as "Fill"

    -- These fields are the normal trade match fields and may be duplicated above.
    , coalesce(i.trade_date , e.date)               as trade_date
    , coalesce(i.custodian , e.custodian)           as custodian
    , coalesce(i.account_number , e.account_number) as account_number
    , coalesce(i.symbol , e.symbol)                 as symbol
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
            and units_diff <> 0
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
