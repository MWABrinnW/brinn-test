select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , customer_id
    , entity_type
    , family_member_id
    , first_name
    , middle_name
    , last_name
    , salutation
    , relationship
    , date_of_birth
    , gender
    , martial_status
    , dependents
    , ssn_tin
    , employment_status
    , occupation
    , income_source
    , employer_name
    , years_employed
    , country_of_citizenship_organization
    , tax_residence_country
    , {{ col_is_head(reference=source('envestnet_mwa', 'familymember_family_member')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'familymember_family_member') }}


