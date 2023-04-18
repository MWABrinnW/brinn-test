select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , marital_status_id
    , marital_status
    , entity_type
    , nscc_code
    , mstar_dtcc_code
    , dst_code
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_marital_status')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'codes_marital_status') }}


