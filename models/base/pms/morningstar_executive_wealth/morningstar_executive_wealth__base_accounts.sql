select
    'morningstar'                                  as system_name
    , 'executive_wealth'                           as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , trim(name)                                   as account_name
    , trim(current_custodian)                      as account_custodian
    , trim(client_account_type)                    as account_type
    , coalesce(account_number , name)              as account_number
    , market_value_usd::decimal(20 , 2)            as account_value
    , try_to_date(market_value_date)               as account_value_date
    , trim(client_name)                            as client_name
    , trim(account_owner)                          as account_owner
    , portfolio_risk_score::decimal(15 , 8)        as portfolio_risk_score
    , try_to_date(open_date)                       as open_date
    , try_to_date(closed_date)                     as closed_date
    , try_to_date(performance_start_date)          as performance_start_date
    , investment_strategy                          as investment_strategy
    , investment_objective                         as investment_objective
    , primary_benchmark                            as primary_benchmark
    , secondary_benchmark                          as secondary_benchmark
    , tertiary_benchmark                           as tertiary_benchmark
    , tracking_method                              as tracking_method
    , try_to_date(last_reconciled_date)            as last_reconciled_date
    , account_authorization                        as account_authorization
    , client_aggregate_calculation                 as client_aggregate_calculation
    , effective_date::date                         as effective_date
    , {{ col_is_head(
        reference=source('morningstar_executive_wealth', 'accounts'),
        reference_date_col='effective_date',
        source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at::timestamp                       as _source_loaded_at
    , _source_file                                 as _source_file
from {{ source('morningstar_executive_wealth', 'accounts') }}
