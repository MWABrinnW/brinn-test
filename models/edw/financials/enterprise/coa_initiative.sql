select
    'oracle_edm'::text(200)   as system_name
    , name::text(200)         as _6_initiative_id
    , description::text(200)  as initiative_name
    , is_enabled::int         as is_enabled
    , end_date::date          as end_date
    , effective_date::date    as effective_date
    , is_head::int            as is_head
    , _created_at::timestamp  as _created_at
    , _source_file::text(200) as _source_file
from {{ ref('edm__stg_initiative') }}
where true
    and try_to_boolean(attr_01)::int = 1
order by effective_date desc
