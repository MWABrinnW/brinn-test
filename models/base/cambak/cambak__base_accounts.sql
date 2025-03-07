select
    'cambak'::text(200)                                                    as system_name
    , 'andco'::text(200)                                                   as system_instance
    , concat(system_name , '__' , system_instance)                         as system_key
    , 'andco'                                                              as firm_source
    , json:financial_account_number::text(200)                             as account_number_formatted
    , regexp_replace(replace(
        ltrim(upper((json:financial_account_number::text(200))) , '0')
        , '-' , ''
    ) , '\\s{2,}'
    , ' ')                                                                 as account_number
    , json:internal_financial_account_number::text(200)                    as internal_financial_account_number
    , json:internal_household_number::int                                  as internal_household_number
    , json:registrant_name::text(200)                                      as registrant_name
    , json:financial_account_name::text(200)                               as financial_account_name
    , json:household_name::text(200)                                       as household_name
    , json:location_code::text(200)                                        as location_code
    , json:location_name::text(200)                                        as location_name
    , json:type_of_account::text(200)                                      as type_of_account
    , json:custodian::text(200)                                            as custodian
    , json:source_system_custodian::text(200)                              as source_system_custodian
    , json:verified_custodian::text(200)                                   as verified_custodian
    , json:model_investment_strategy::text(200)                            as model_investment_strategy
    , json:client_manager::text(200)                                       as client_manager
    , json:source_system_client_manager::text(200)                         as source_system_client_manager
    , json:primary_client_manager::text(200)                               as primary_client_manager
    , json:erisa::text(200)                                                as erisa
    , json:account_active::int                                             as account_active
    , json:aum_classification_status::text(200)                            as aum_classification_status
    , json:discretion_status::text(200)                                    as discretion_status
    , json:proxy_voting_status::text(200)                                  as proxy_voting_status
    , json:cost_basis_disposal_method::text(200)                           as cost_basis_disposal_method
    , json:prime_broker_enabled::text(200)                                 as prime_broker_enabled
    , json:current_value::number(18 , 2)                                   as current_value
    , to_date((json:account_open_date::text) , 'MM/DD/YYYY HH12:MI:SS AM') as account_open_date
    , to_date((json:closed_date::text) , 'MM/DD/YYYY HH12:MI:SS AM')       as closed_date
    , to_date((json:as_of_date::text) , 'MM/DD/YYYY HH12:MI:SS AM')        as as_of_date
    , to_date((json:month_end_date::text) , 'MM/DD/YYYY HH12:MI:SS AM')    as month_end_date
    , effective_date::date                                                 as effective_date
    , {{ col_is_head(reference=source('cambak', 'accounts')) }}
    , _created_at::datetime                                                as _created_at
    , _id::int                                                             as int
from {{ source('cambak', 'accounts') }}
where true
    and json:financial_account_number::text(200) not ilike '000.00%'
    and json:financial_account_number::text(200) != 'David King'
    and json:financial_account_number::text(200) is not null
