select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , rep_code
    , updated_date
    , proposal_type
    , title
    , advisor_id
    , advisor_name
    , {{ col_is_head(reference=source('envestnet_mps', 'proposal_proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'proposal_proposal') }}


