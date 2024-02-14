select
    'internal'::text(200)    as src
    , execution_date::date   as trade_date
    , custodian
    , account_number
    , buy_sell
    , symbol
    , price::decimal(20 , 2) as price
    , sum(units_shares)      as quantity
from {{ ref('fourforty__int_orders_allocations') }}
where 1 = 1
    and execution_date::date >= current_date - 7
group by all

union all

select
    'external'::text(200)    as src
    , transaction_date::date as trade_date
    , custodian
    , account_number
    , buy_sell
    , symbol
    , price::decimal(20 , 2) as price
    , sum(units_shares)      as quantity
from {{ ref('flyer__custodian_trades') }}
where 1 = 1
    and transaction_date::date >= current_date - 7
    -- exclude money market transactions
    and product_type_source_code not in ('MMN' , 'MMS' , 'SEMYM')
    and (is_in_sod = 1 or is_in_allocations = 1)
group by all
