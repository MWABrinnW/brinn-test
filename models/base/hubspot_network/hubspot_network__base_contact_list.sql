select
    a.json:ID::text(500)                                       as id
  , a.json:NAME::text(500)                                     as name
  , a.json:DELETEABLE::text(500)                               as deleteable
  , a.json:DYNAMIC::text(500)                                  as dynamic
  , a.json:PORTAL_ID::text(500)                                as portal_id
  , a.json:UPDATED_AT::text(500)                               as updated_at
  , a.json:CREATED_AT::text(500)                               as created_at
  , a.json:METADATA_LAST_PROCESSING_STATE_CHANGE_AT::text(500) as metadata_last_processing_state_change_at
  , a.json:METADATA_PROCESSING::text(500)                      as metadata_processing
  , a.json:METADATA_LAST_SIZE_CHANGE_AT::text(500)             as metadata_last_size_change_at
  , a.json:METADATA_ERROR::text(500)                           as metadata_error
  , a.json:METADATA_SIZE::text(500)                            as metadata_size
  , a.json:OFFSET::text(500)                                   as offset_
  , a.json:_FIVETRAN_DELETED::text(500)                        as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED::text(500)                         as _fivetran_synced

  , a.effective_at::timestamp                                  as effective_at
  , a._created_at::timestamp                                   as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'contact_list'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                       as is_latest
from {{ source('hubspot_network', 'contact_list') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'contact_list') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at