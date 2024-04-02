select
    name
    , description
    , parent
    , level
    , hierarchy_name
    , is_enabled
    , end_date
    , account_type
    , effective_date
    , is_head
    , _created_at
    , _source_file
from {{ ref('edm__stg_natural_account') }}
where level = 3
