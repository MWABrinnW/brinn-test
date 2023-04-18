select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , fee_schedule_id
    , fee_component_type
    , is_derived_component
    , fee_minimum
    , fee_maximum
    , is_linear
    , is_household
    , asset_calculation_method
    , {{ col_is_head(reference=source('envestnet_mps', 'account_fee_schedule_fee_component')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'account_fee_schedule_fee_component') }}


