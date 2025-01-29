select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , record_type
    , account_id
    , account_number
    , fee_schedule_id
    , billing_mode_id
    , {{ col_is_head(reference=source('envestnet_mps', 'account_fee_schedule_fee_schedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'account_fee_schedule_fee_schedule') }}
