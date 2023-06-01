select
    c.contact_id                                     as contact_id
  , p.value:id::int                                  as email_id
  , p.value:email_type::int                          as email_type
  , p.value:email_type_description::text(200)        as email_type_description
  , p.value:address::text(100)                       as email_address
  , p.value:emailable_id::int                        as emailable_id
  , p.value:emailable_type::text(100)                as emailable_type
  , nullif(p.value:custom_type_title::text(200), '') as custom_type_title
  , nullif(p.value:description::text(200), '')       as description
  , p.value:deleted::boolean::int                    as is_deleted
  , p.value:is_preferred::boolean::int               as is_preferred
  , p.value:is_primary::boolean::int                 as is_primary
  , p.value:created_at::timestamp                    as created_at
  , p.value:updated_at::timestamp                    as updated_at

  , c.effective_at                                   as effective_at
  , c.effective_date                                 as effective_date
  , c.is_head                                        as is_head
  , c._source_loaded_at                              as _source_loaded_at
  , c._source_file                                   as _source_file
from {{ ref('redtail_network__base_contacts') }}                   c
   , lateral flatten(input => parse_json(c.emails), outer => true) p
where true
  and array_size(c.emails) > 0
