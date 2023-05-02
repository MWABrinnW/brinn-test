select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , account_id
    , account_number
    , fee_schedule_id
    , billing_mode_id
    , fee_notes
    , has_customer_service_fee
    , billing_frequency
    , {{ col_is_head(reference=source('envestnet_mwa', 'account_fee_schedule_fee_schedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'account_fee_schedule_fee_schedule') }}


