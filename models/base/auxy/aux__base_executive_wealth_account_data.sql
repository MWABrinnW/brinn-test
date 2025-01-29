select
    financial_account_number::varchar(100)            as financial_account_number
    , financial_account_number_clean::varchar(100)    as financial_account_number_clean
    , internal_financial_account_number::varchar(100) as internal_financial_account_number
    , internal_household_number::varchar(100)         as internal_household_number
    , registrant_name::varchar(100)                   as registrant_name
    , financial_account_name::varchar(100)            as financial_account_name
    , household_name::varchar(100)                    as household_name
    , location_code::varchar(100)                     as location_code
    , location_name::varchar(100)                     as location_name
    , type_of_account::varchar(100)                   as type_of_account
    , custodian::varchar(100)                         as custodian
    , source_system_custodian::varchar(100)           as source_system_custodian
    , verified_custodian::varchar(100)                as verified_custodian
    , model_investment_strategy::varchar(100)         as model_investment_strategy
    , client_manager::varchar(100)                    as client_manager
    , source_system_client_manager::varchar(100)      as source_system_client_manager
    , primary_client_manager::varchar(100)            as primary_client_manager
    , fee_schedule::varchar(100)                      as fee_schedule
    , erisa::varchar(100)                             as erisa
    , account_active::int                             as account_active
    , aum_classification_status::varchar(100)         as aum_classification_status
    , discretion_status::varchar(100)                 as discretion_status
    , proxy_voting_status::varchar(100)               as proxy_voting_status
    , cost_basis_disposal_method::varchar(100)        as cost_basis_disposal_method
    , prime_broker_enabled::varchar(100)              as prime_broker_enabled
    , account_open_date::date                         as account_open_date
    , closed_date::date                               as closed_date
    , as_of_date::date                                as as_of_date
    , aum_status::varchar(100)                        as aum_status
    , update_date::date                               as update_date
    , notes::varchar(100)                             as notes
    , effective_at::timestamp_ntz(9)                  as effective_at
    , _created_at::timestamp_ntz(9)                   as _source_loaded_at
    , _box_file_id::varchar(200)                      as _box_file_id
from {{ source('aux', 'executive_wealth_account_data') }}
