select
    'morningstar'                                  as system_name
    , 'executive_wealth'                           as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , trim(name)                                   as client_name
    , trim(client_account_type)                    as account_type
    , market_value_usd::decimal(20 , 2)            as account_value
    , try_to_date(market_value_date)               as account_value_date
    , primary_benchmark                            as primary_benchmark
    , secondary_benchmark                          as secondary_benchmark
    , tertiary_benchmark                           as tertiary_benchmark
    , number_of_accounts::int                      as number_of_accounts
    , advisor                                      as advisor
    , client_status                                as client_status
    , client_web_portal_status                     as client_web_portal_status
    , last_client_web_portal_login                 as last_client_web_portal_login
    , permission                                   as permission
    , try_to_date(review_date)                     as review_date
    , client_aggregate_calculation                 as client_aggregate_calculation
    , effective_date::date                         as effective_date
    , {{ col_is_head(
        reference=source('morningstar_executive_wealth', 'clients'),
        reference_date_col='effective_date',
        source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at::timestamp                       as _created_at
    , _source_file                                 as _source_file
from {{ source('morningstar_executive_wealth', 'clients') }}
where account_type = 'Clients'
