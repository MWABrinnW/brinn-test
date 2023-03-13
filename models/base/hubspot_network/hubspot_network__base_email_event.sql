select
    a.json:ID::text(500)                   as id
  , a.json:CREATED::text(500)              as created
  , a.json:TYPE::text(500)                 as type
  , a.json:RECIPIENT::text(500)            as recipient
  , a.json:PORTAL_ID::text(500)            as portal_id
  , a.json:APP_ID::text(500)               as app_id
  , a.json:FILTERED_EVENT::text(500)       as filtered_event
  , a.json:EMAIL_CAMPAIGN_ID::text(500)    as email_campaign_id
  , a.json:SENT_BY_ID::text(500)           as sent_by_id
  , a.json:SENT_BY_CREATED::text(500)      as sent_by_created
  , a.json:CAUSED_BY_ID::text(500)         as caused_by_id
  , a.json:CAUSED_BY_CREATED::text(500)    as caused_by_created
  , a.json:OBSOLETED_BY_ID::text(500)      as obsoleted_by_id
  , a.json:OBSOLETED_BY_CREATED::text(500) as obsoleted_by_created
  , a.json:_FIVETRAN_SYNCED::text(500)     as _fivetran_synced

  , a.effective_at::timestamp              as effective_at
  , a._created_at::timestamp               as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'email_event'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end   as is_latest
from {{ source('hubspot_network', 'email_event') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'email_event') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at