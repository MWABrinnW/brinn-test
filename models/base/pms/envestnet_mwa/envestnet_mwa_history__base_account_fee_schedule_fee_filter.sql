select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , fee_schedule_id
    , fee_component_type
    , filter_type
    , filer_value
    , is_exclusion_discount_custom_fee
    , exclusion_end_date
    , advisor_cannot_edit
    , description
    , registration_type
    , exclusion_factor
    , exclusion_factory_type
    , cumulative_discount_cap
    , adjust_discount_to
    , fee_filter_id
    , {{ col_is_head(reference=source('envestnet_mwa', 'account_fee_schedule_fee_filter')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'account_fee_schedule_fee_filter') }}


