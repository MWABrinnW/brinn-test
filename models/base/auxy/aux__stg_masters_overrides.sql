select
    json:scope::text(100)                      as scope
    , json:scope_key::text(100)                as scope_key
    , json:start_date::date                    as start_date
    , json:end_date::date                      as end_date
    , json:comments::text(2000)                as comments
    , json:is_excluded::int                    as _is_excluded
    , json:excluded_reasons::text(2000)        as _excluded_reasons
    , json:account_number_formatted::text(200) as _account_number_formatted
    , json:account_number::text(200)           as _account_number
    , json:account_name::text(200)             as _account_name
    , json:opened_date::date                   as _opened_date
    , json:closed_date::date                   as _closed_date
    , json:is_active::int                      as _is_active
    , json:account_value::decimal(16 , 2)      as _account_value
    , json:custodian::text(1000)               as _custodian
    , json:location_code::text(200)            as _location_code
    , json:advisor::text(200)                  as _advisor
    , json:advisor_id::text(200)               as _advisor_id
    , json:advisor_id_source::text(200)        as _advisor_id_source
    , json:advisor_email::text(200)            as _advisor_email
    , json:aum_classification::text(200)       as _aum_classification
    , json:investment_strategy::text(200)      as _investment_strategy
    , json:is_erisa::int                       as _is_erisa
    , json:is_discretionary::int               as _is_discretionary
    , json:is_voting_proxied::int              as _is_voting_proxied
    , json:is_prime_broker::int                as _is_prime_broker
    , json:is_broker_dealer_account::int       as _is_broker_dealer_account
    , _created_at::timestamp                   as _source_loaded_at
    , _box_file_id::text(200)                  as _box_file_id
from {{ source('aux', 'masters_overrides') }}
