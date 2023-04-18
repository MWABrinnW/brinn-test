select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , advisor_id
    , first_name
    , middle_name
    , last_name
    , rep_code
    , user_name
    , enterprise_id
    , firm_id
    , branch_id
    , entitlement
    , manager_rep_code
    , ssn_number
    , date_of_birth
    , crd_number
    , dba_name
    , start_date
    , termination_date
    , termination_reason
    , home_state
    , sso_user_name
    , alternate_sso_user_name
    , {{ col_is_head(reference=source('envestnet_mps', 'hierarchy_advisor')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'hierarchy_advisor') }}


