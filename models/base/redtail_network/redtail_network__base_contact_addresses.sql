select
    c.contact_id                                  as contact_id
  , add.value:id::int                             as address_id
  , add.value:address_type::int                   as address_type
  , add.value:address_type_description::text(100) as address_type_description
  , add.value:street_address::text(200)           as street_address
  , add.value:secondary_address::text(200)        as secondary_address
  , add.value:city::text(200)                     as city
  , add.value:state::text(200)                    as state
  , add.value:zip::text(100)                      as zip
  , add.value:country::text(200)                  as country
  , add.value:custom_type_title::text(200)        as custom_type_title
  , add.value:description::text(300)              as description
  , add.value:addressable_id::int                 as addressable_id
  , add.value:addressable_type::text(100)         as addressable_type
  , add.value:is_preferred::boolean::int          as is_preferred
  , add.value:is_primary::boolean::int            as is_primary
  , add.value:is_shared::boolean::int             as is_shared
  , add.value:deleted::boolean::int               as is_deleted
  , add.value:created_at::timestamp               as created_at
  , add.value:updated_at::timestamp               as updated_at

  , c.effective_at                                as effective_at
  , c.effective_date                              as effective_date
  , c.is_head                                     as is_head
  , c._source_loaded_at                           as _source_loaded_at
  , c._source_file                                as _source_file
from {{ ref('redtail_network__base_contacts') }}                      c
   , lateral flatten(input => parse_json(c.addresses), outer => true) add
where true
  and array_size(c.addresses) > 0
