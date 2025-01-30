with internal_trades as (
    -- [PERFORM]
    select
        trade_date          as trade_date
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
        , max(unit_price)   as price
        , 'perform'         as trading_system
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and trade_date >= current_date - 7
        and custodian ilike any ('%schwab%' , '%fidelity%')
        -- Exclude today's trades. This isn't usually necessary but is needed
        -- if running the report later in the day.
        and trade_date <> current_date()
    group by trade_date , custodian , account_number , cusip , order_side

    union all

    -- [MOXY]
    select
        trade_date          as trade_date
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
        , max(price)        as price
        , 'moxy'            as trading_system
    from {{ ref('moxy__fct_allocations') }}
    where 1 = 1
        and trade_date >= current_date - 7
        and custodian ilike any ('%schwab%' , '%fidelity%')
        -- Exclude today's trades. This isn't usually necessary but is needed
        -- if running the report later in the day.
        and trade_date <> current_date()
    group by all
)

, accounts_tradeable as (
    select distinct
        account_number
        , trading_system
    from internal_trades

    union distinct

    select distinct
        account_number
        , 'perform' as trading_system
    from {{ ref('perform__stg_accounts') }}
    where 1 = 1
        and is_head = 1
        and lower(port_mgmt_style) in ('aipmanaged' , 'portfolioreviews')
        and coalesce(port_status , '') not ilike 'closed'

    union distinct

    select distinct
        account_number
        , 'moxy' as trading_system
    from {{ ref('moxy__stg_accounts') }}
    where 1 = 1
        and is_head = 1
)

, accounts_tradeable_grouped as (
    select
        account_number
        , array_agg(distinct trading_system) as trading_systems
    from accounts_tradeable
    group by all
)

, accounts as (
    select
        a.account_number
        , b.account_number_formatted
        , b.pms_account_id
        , b.custodian
        , array_distinct(array_cat(
            coalesce(b.trading_systems , []) , coalesce(a.trading_systems , [])
        )) as trading_systems
        , b.is_active
        , b.is_included
        , b.is_perform
        , b.is_moxy
    from accounts_tradeable_grouped as a
    left join {{ ref('mis__accounts') }} as b
        on a.account_number = b.account_number
    group by all
)

, external_trades as (
    select
        t.transaction_date              as transaction_date
        , t.custodian                   as custodian
        , t.account_number              as account_number
        , t.symbol                      as symbol
        , sum(t.units_shares)           as quantity
        , max(t.price::decimal(20 , 2)) as price
    from {{ ref('custodian_transactions') }} as t
    inner join accounts as a
        on t.account_number = a.account_number
    where 1 = 1
        and t.custodian in ('schwab' , 'fidelity')
        and t.firm_source = 'mwa'
        and t.transaction_date >= dateadd('DAY' , -7 , current_date())
        and t.is_trade = 1
        -- exclude money market transactions
        and t.product_type_source_code not in ('MMN' , 'MMS' , 'SEMYM')
    group by all
)

, orion_products as (
    select
        product_id
        , symbol
        , cusip
        , ticker
        , product_name
        , product_type
        , asset_class
        , product_category
    from {{ ref('orion__products') }}
    where fkalclient = 568
)

select
    coalesce(i.trade_date , e.transaction_date)     as trade_date
    , coalesce(i.custodian , e.custodian)           as custodian
    , coalesce(i.account_number , e.account_number) as account_number
    , coalesce(i.symbol , e.symbol)                 as symbol
    , acc.trading_systems                           as trading_systems
    , i.quantity::decimal(17 , 2)                   as units_internal
    , e.quantity::decimal(17 , 2)                   as units_external
    , i.price::decimal(15 , 3)                      as price_internal
    , e.price::decimal(15 , 3)                      as price_external
    , abs(
        i.quantity - e.quantity
    )::decimal(17 , 3)                              as diff
    , case
        when units_internal is null then 'Unmatched external'
        when units_external is null then 'Unmatched internal'
        when diff is not null and diff <> 0
            and (
                div0(diff , abs(i.quantity)) < 0.01
                and i.quantity <> 0
            ) is not null
            and diff <> 0
            and (
                div0(diff , abs(i.quantity)) < 0.01
                and i.quantity <> 0
            )
            -- 1% buffer on unit match
            then 'Trade matched'
        when diff is not null and diff <> 0 then 'Internal/external Discrepancy'
        when diff = 0 then 'Trade matched'
    end                                             as match_type
    , iff(match_type = 'Trade matched' , 1 , 0)     as is_match
    , p.product_name                                as product_name
    , p.asset_class                                 as asset_class
    , p.product_type                                as product_type
    , p.product_category                            as product_category
    , p.product_id                                  as product_id
    --, acc.account_title                             as account_name
    --, acc.restrictions_source_code                  as restrictions_source_code
from internal_trades as i
full outer join external_trades as e
    on i.trade_date = e.transaction_date
    and i.custodian = e.custodian
    and i.account_number = e.account_number
    and i.symbol = e.symbol
left join accounts as acc
    on coalesce(
        i.account_number
        , e.account_number
    ) = acc.account_number
left join orion_products as p
    on coalesce(i.symbol , e.symbol) = p.symbol
group by all
order by case when match_type ilike '%discrep%' then 1
    when match_type ilike '%internal%' then 2
    when match_type ilike '%external%' then 3
    else 4
end
