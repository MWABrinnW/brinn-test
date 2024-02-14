select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
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
    , aum_fee_schedule_id
    , aum_method
    , aum_rule
    , fee_paid_by
    , {{ col_is_head(reference=source('envestnet_mwa', 'account_fee_schedule_fee_component')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'account_fee_schedule_fee_component') }}


