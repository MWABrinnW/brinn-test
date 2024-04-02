select
    name
    , description
    , parent
    , level
    , hierarchy_name
    , is_enabled
    , end_date
    , effective_date
    , is_head
    , _created_at
    , _source_file
from {{ ref('edm__stg_team') }}
where level = 1
