select
    a.json:ID::text(500)                 as id
  , a.json:APP_ID::text(500)             as app_id
  , a.json:APP_NAME::text(500)           as app_name
  , a.json:CONTENT_ID::text(500)         as content_id
  , a.json:NAME::text(500)               as name
  , a.json:NUM_INCLUDED::text(500)       as num_included
  , a.json:NUM_QUEUED::text(500)         as num_queued
  , a.json:SUB_TYPE::text(500)           as sub_type
  , a.json:SUBJECT::text(500)            as subject
  , a.json:TYPE::text(500)               as type
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'email_campaign'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'email_campaign') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'email_campaign') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at