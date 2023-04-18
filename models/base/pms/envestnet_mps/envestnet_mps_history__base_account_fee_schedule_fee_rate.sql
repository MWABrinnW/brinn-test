select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , fee_schedule_id
    , fee_component_type
    , filter_type
    , start_range
    , rate_percent
    , rate_dollar
    , {{ col_is_head(reference=source('envestnet_mps', 'account_fee_schedule_fee_rate')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'account_fee_schedule_fee_rate') }}


