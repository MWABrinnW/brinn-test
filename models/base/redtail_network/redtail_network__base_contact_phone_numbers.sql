select
    c.contact_id                                     as contact_id
  , p.value:id::int                                  as phone_id
  , p.value:phone_type::int                          as phone_type
  , p.value:phone_type_description::text(200)        as phone_type_description
  , p.value:number::text(100)                        as phone_number
  , nullif(p.value:extension::text(100), '')         as extension
  , p.value:country_code::int                        as country_code
  , p.value:callable_id::int                         as callable_id
  , p.value:callable_type::text(100)                 as callable_type
  , nullif(p.value:custom_type_title::text(200), '') as custom_type_title
  , nullif(p.value:description::text(200), '')       as description
  , p.value:deleted::boolean::int                    as is_deleted
  , p.value:is_preferred::boolean::int               as is_preferred
  , p.value:is_primary::boolean::int                 as is_primary
  , p.value:is_shared::boolean::int                  as is_shared
  , nullif(p.value:speed_dial::text(100), '')        as speed_dial
  , p.value:created_at::timestamp                    as created_at
  , p.value:updated_at::timestamp                    as updated_at

  , c.effective_at                                   as effective_at
  , c.effective_date                                 as effective_date
  , c.is_head                                        as is_head
  , c._source_loaded_at                              as _source_loaded_at
  , c._source_file                                   as _source_file
from {{ ref('redtail_network__base_contacts') }}                   c
   , lateral flatten(input => parse_json(c.phones), outer => true) p
where c.is_head = 1
  and array_size(c.phones) > 0
