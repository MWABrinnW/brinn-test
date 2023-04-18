select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , estimated_net_worth_type
    , description
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_estimated_net_worth')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'codes_estimated_net_worth') }}


