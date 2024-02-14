select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , risk_scale_min_point
    , risk_scale_max_point
    , description
    , {{ col_is_head(reference=source('envestnet_mwa', 'codes_risk_scale')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'codes_risk_scale') }}


