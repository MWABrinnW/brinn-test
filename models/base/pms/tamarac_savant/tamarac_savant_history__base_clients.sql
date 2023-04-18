select
    'tamarac' as pms
    , 'savant' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , email
    , activation_email_sent
    , allow_portal_access
    , client_status
    , client_view
    , custom_signature
    , use_default_customer_signature
    , date_of_birth
    , default_account
    , default_account_name
    , default_account_number
    , default_upload_account_id
    , first_name
    , household_name
    , last_login_date
    , last_name
    , middle_name_initial
    , preferred_delivery_method
    , service_team_name
    , service_team_compliance
    , service_team_operations
    , service_team_primary_advisor
    , service_team_secondary_advisor
    , upload_household_id
    , prev_eod_date
    , {{ col_is_head(reference=source('tamarac_savant', 'clients')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('tamarac_savant', 'clients') }}