select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , risk_scale_min_point
    , risk_scale_max_point
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_risk_scale')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'codes_risk_scale') }}


