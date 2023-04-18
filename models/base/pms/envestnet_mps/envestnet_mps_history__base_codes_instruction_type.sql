select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , instruction_type_id
    , instruction_type_description
    , entity_type
    , nscc_code
    , mstar_dtcc_code
    , dst_code
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_instruction_type')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'codes_instruction_type') }}


