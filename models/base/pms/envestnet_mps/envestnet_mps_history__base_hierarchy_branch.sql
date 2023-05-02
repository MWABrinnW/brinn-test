select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , branch_id
    , branch_name
    , branch_short_name
    , enterprise_id
    , firm_id
    , branch_code
    , manager_rep_code
    , {{ col_is_head(reference=source('envestnet_mps', 'hierarchy_branch')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'hierarchy_branch') }}


