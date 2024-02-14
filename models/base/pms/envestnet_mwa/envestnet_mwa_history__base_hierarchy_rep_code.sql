select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , rep_code_id
    , rep_code
    , branch_code
    , is_split_rep_code
    , enterprise_id
    , branch_id
    , advisor_id
    , participating_rep_code
    , percentage
    , rep_code_description
    , is_primary
    , is_default
    , ensembled_id
    , {{ col_is_head(reference=source('envestnet_mwa', 'hierarchy_rep_code')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'hierarchy_rep_code') }}


