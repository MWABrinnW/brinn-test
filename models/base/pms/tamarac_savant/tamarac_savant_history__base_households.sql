select
    'tamarac' as pms
    , 'savant' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , household_name
    , upload_household_id
    , household_number
    , household_address1
    , household_address2
    , household_address3
    , household_address4
    , household_city
    , household_state
    , household_state_of_primary_residence
    , household_zip
    , household_country
    , is_primary_residence
    , primary_email_address
    , managed_value
    , total_value
    , net_worth
    , service_team
    , client_type
    , prev_eod_date
    , {{ col_is_head(reference=source('tamarac_savant', 'households')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('tamarac_savant', 'households') }}