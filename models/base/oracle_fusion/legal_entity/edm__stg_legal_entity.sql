select
    name::text(200)             as name
    , description::text(200)    as description
    , parent::text(200)         as parent
    , level::int                as level
    , hierarchy_name::text(200) as hierarchy_name
    , enabled::int              as is_enabled
    , end_date::date            as end_date
    , effective_date::date      as effective_date
    , {{ col_is_head(reference=source('oracle', 'edm_legal_entity')) }}
    , _created_at::timestamp    as _created_at
    , _source_file::text(200)   as _source_file
from {{ source('oracle', 'edm_legal_entity') }}
