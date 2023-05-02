select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , fee_filter_type_id
    , billing_mode_id
    , description
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_asset_category')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'codes_asset_category') }}


