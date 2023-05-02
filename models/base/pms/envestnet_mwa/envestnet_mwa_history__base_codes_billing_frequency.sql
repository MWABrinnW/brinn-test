select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , billing_frequency
    , description
    , {{ col_is_head(reference=source('envestnet_mwa', 'codes_billing_frequency')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'codes_billing_frequency') }}


