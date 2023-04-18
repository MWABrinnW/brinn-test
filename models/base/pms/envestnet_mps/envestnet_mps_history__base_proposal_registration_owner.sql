select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , proposal_id
    , customer_registration_id
    , owner_type
    , entity_type
    , prefix
    , first_name
    , middle_name
    , last_name
    , ssn_tax_id
    , ssn_tax_id_flag
    , date_of_birth
    , address_line1
    , address_line2
    , city
    , state
    , zip_code
    , country
    , email
    , phone_day
    , phone_evening
    , identification_number
    , {{ col_is_head(reference=source('envestnet_mps', 'proposal_registration_owner')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'proposal_registration_owner') }}


