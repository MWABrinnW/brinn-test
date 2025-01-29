select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , record_type
    , firm_id
    , firm_name
    , firm_short_name
    , enterprise_id
    , broker_symbol
    , crd_number
    , bank_account_type
    , bank_name
    , bank_account_number
    , bank_account_name
    , aba_routing_no
    , {{ col_is_head(reference=source('envestnet_mps', 'hierarchy_firm')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'hierarchy_firm') }}
