select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , branch_id
    , branch_name
    , branch_short_name
    , enterprise_id
    , firm_id
    , branch_code
    , manager_rep_code
    , {{ col_is_head(reference=source('envestnet_mwa', 'hierarchy_branch')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'hierarchy_branch') }}


