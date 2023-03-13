select
    a.json:ID::text(500)                 as id
  , a.json:PORTAL_ID::text(500)          as portal_id
  , a.json:ACTIVE::text(500)             as active
  , a.json:OWNER_ID::text(500)           as owner_id
  , a.json:TYPE::text(500)               as type
  , a.json:ACTIVITY_TYPE::text(500)      as activity_type
  , a.json:CREATED_AT::text(500)         as created_at
  , a.json:LAST_UPDATED::text(500)       as last_updated
  , a.json:TIMESTAMP::text(500)          as timestamp
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'engagement'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'engagement') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'engagement') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at