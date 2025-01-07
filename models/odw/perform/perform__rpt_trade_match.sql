{{ config(
    tags = ["report"]
    ) }}

with cte_internal_allocations as (
    select
        trade_date
        , lower(custodian)  as custodian
        , account_number    as account_number
        , cusip             as symbol
        , cusip             as cusip
        , lower(order_side) as order_side
        , case
            when lower(order_side) = 'buy'
                then sum(units)
            when lower(order_side) = 'sell'
                then sum(units) * -1
            else
                sum(units)
        end                 as quantity
        , null::text        as notes
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and trade_date >= dateadd('DAY' , -7 , current_date())
        -- Exclude today's trades. This isn't usually necessary but is needed
        -- if running the report later in the day.
        and trade_date <> current_date()
    group by trade_date , custodian , account_number , cusip , order_side
)

, cte_oms_accounts as (
    select account_number
    from {{ ref ('perform__stg_accounts') }}
    where 1 = 1
        and _created_at >= current_date() - 7
        and coalesce(port_status , '') not ilike 'closed'
    group by all
)

, cte_all_accounts as (
    select account_number
    from {{ ref('mis__bld_accounts') }}
    where 1 = 1
        and is_active = 1
        and (
            is_perform = 1
            or account_number in (select t.account_number from cte_oms_accounts as t)
        )

    union distinct

    select distinct account_number from cte_internal_allocations
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
        , max(case
            when coalesce(t.trade_status , '') not ilike 'pending'
                then lower(t.buy_sell)
        end)                  as order_side
        , sum(case
            when coalesce(t.trade_status , '') not ilike 'pending'
                then t.quantity
        end)                  as quantity
        , max(case
            when coalesce(t.trade_status , '') not ilike 'pending'
                then t.notes
        end)                  as notes
        , max(case
            when t.trade_status ilike 'pending'
                then 1
            else 0
        end)                  as has_pendings
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
        and lower(t.trade_status) not in ('rejected' , 'reversed')
        -- Exclude maturity/redemption transactions per Omar 12/17/24.
        -- 'RO_RDM' & 'REDEMP/CONVERSION' is what we found with the examples
        -- but it's possible other maturity-like events could present a
        -- different notation and need added.
        and coalesce(t.notes , '') not ilike '%RO_RDM%'
        and coalesce(t.notes , '') not ilike '%REDEMP/CONVERSION%'
        and coalesce(t.notes , '') not ilike '%REDEMPTION PAYOUT%'
    group by all
)

, cte_pendings as (
    select
        account_number
        , cusip
        , max(has_pendings) as has_pendings
    from cte_external_trades
    group by all
)

select
    coalesce(i.trade_date , e.date)                 as trade_date
    , coalesce(i.custodian , e.custodian)           as custodian
    , coalesce(i.account_number , e.account_number) as account_number
    , coalesce(i.symbol , e.symbol)                 as symbol
    , coalesce(i.cusip , e.cusip)                   as cusip
    , coalesce(i.order_side , e.order_side)         as order_side
    , i.quantity::decimal(17 , 2)                   as internal_units
    , e.quantity::decimal(17 , 2)                   as external_units
    , i.quantity - e.quantity::decimal(17 , 2)      as units_diff
    , case
        when internal_units is null
            then 'Unmatched External'
        when external_units is null
            then 'Unmatched Internal'
        when units_diff is not null
            and units_diff <> 0
            and (
                abs(div0(units_diff , i.quantity)) < 0.01 and i.quantity <> 0
            ) is not null
            and units_diff <> 0
            and (
                abs(div0(units_diff , i.quantity)) < 0.01 and i.quantity <> 0
            ) then 'Trade Matched'
        when units_diff is not null and units_diff <> 0 then 'Internal/External Discrepancy'
        when units_diff = 0 then 'Trade Matched'
    end                                             as match_type
    , case
        when match_type ilike 'trade matched'
            then 1
        else 0
    end::int                                        as is_match

    , e.product_name                                as product_name
    , e.asset_class                                 as asset_class
    , e.product_type                                as product_type
    , e.product_category                            as product_category
    , e.product_id                                  as product_id
    , e.asset_id                                    as asset_id
    , coalesce(p.has_pendings , e.has_pendings , 0) as has_pendings
    , coalesce(i.notes , e.notes)                   as notes
from cte_internal_allocations as i
full outer join cte_external_trades as e
    on i.trade_date = e.date
    and lower(i.custodian) = lower(e.custodian)
    and i.account_number = e.account_number
    and upper(i.cusip) = upper(e.cusip)
    and lower(i.order_side) = lower(e.order_side)
left join cte_all_accounts as a
    on coalesce(i.account_number , e.account_number) = a.account_number
left join cte_pendings as p
    on coalesce(i.account_number , e.account_number) = p.account_number
    and coalesce(i.cusip , e.cusip) = p.cusip
where 1 = 1
    -- Omar requested to exclude 12/18/24
    and not (
        match_type = 'Unmatched External' and coalesce(e.product_type , '') not in ('Miscellaneous' , 'Option' , 'Stock/ETF')
    )
