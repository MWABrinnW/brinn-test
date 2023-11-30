with internal as (
                     select
                         execution_date
                       , custodian
                       , account_number
                       , symbol
                       , sum(units_shares) as internal_units
                     from {{ ref('fourforty__int_orders_allocations') }}
                     where execution_date >= dateadd('DAY', -7, current_date()) -- rolling 7 day window
                     group by execution_date, account_number, symbol, custodian
                 )
   , external as (
                     select
                         transaction_date
                       , custodian
                       , account_number
                       , symbol
                       , sum(units_shares) as external_units
                     from {{ ref('fixflyer_options__custodian_trades') }}
                     where product_type_source_code not in ('MMN', 'MMS', 'SEMYM') -- exclude money market transactions
                       and transaction_date >= dateadd('DAY', -7, current_date())
                     group by transaction_date, account_number, symbol, custodian
                 )
select
    coalesce(internal.execution_date, external.transaction_date) as trade_date
  , coalesce(internal.custodian, external.custodian)             as custodian
  , coalesce(internal.account_number, external.account_number)   as account_number
  , coalesce(internal.symbol, external.symbol)                   as symbol
  , internal.internal_units::decimal(17,2)                       as units_internal
  , external.external_units::decimal(17,2)                       as units_external
  , abs(internal_units - external_units)::decimal(17,3)          as diff
  , case
        when units_internal is null then 'Unmatched External'
        when units_external is null then 'Unmatched Internal'
        when diff is not null and diff != 0 and diff / abs(internal_units) < 0.01
            then 'Trade Matched' -- 1% buffer on unit match
        when diff is not null and diff != 0 then 'Internal/External Discrepancy'
        when diff = 0 then 'Trade Matched'
        end                                                      as match_type
from internal
full outer join external
                on internal.execution_date = external.transaction_date
                    and internal.custodian = external.custodian
                    and internal.account_number = external.account_number
                    and internal.symbol = external.symbol
order by diff desc