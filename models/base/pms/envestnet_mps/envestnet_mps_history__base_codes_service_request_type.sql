select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , record_type
    , service_request_id
    , service_request_description
    , description
    , nscc_code
    , mstar_dtcc_code
    , dst_code
    , {{ col_is_head(reference=source('envestnet_mps', 'codes_service_request_type')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'codes_service_request_type') }}
