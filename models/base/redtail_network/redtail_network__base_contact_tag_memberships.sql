select
    c.contact_id                               as contact_id
  , p.value:id::int                            as tag_id
  , nullif(p.value:name::text(200), '')        as tag_name
  , nullif(p.value:description::text(200), '') as tag_description
  , p.value:deleted::boolean::int              as is_deleted
  , p.value:created_at::timestamp              as created_at
  , p.value:updated_at::timestamp              as updated_at

  , c.effective_at                             as effective_at
  , c.effective_date                           as effective_date
  , c.is_head                                  as is_head
  , c._source_loaded_at                        as _source_loaded_at
  , c._source_file                             as _source_file
from {{ ref('redtail_network__base_contacts') }}                            c
   , lateral flatten(input => parse_json(c.tag_memberships), outer => true) p
where true
  and array_size(c.tag_memberships) > 0
