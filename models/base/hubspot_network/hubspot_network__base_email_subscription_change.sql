select
    a.json:_FIVETRAN_ID::text(500)          as _fivetran_id
  , a.json:RECIPIENT::text(500)             as recipient
  , a.json:CHANGE::text(500)                as change
  , a.json:CHANGE_TYPE::text(500)           as change_type
  , a.json:PORTAL_ID::text(500)             as portal_id
  , a.json:SOURCE::text(500)                as source
  , a.json:CAUSED_BY_EVENT_ID::text(500)    as caused_by_event_id
  , a.json:TIMESTAMP::text(500)             as timestamp
  , a.json:EMAIL_SUBSCRIPTION_ID::text(500) as email_subscription_id
  , a.json:_FIVETRAN_SYNCED::text(500)      as _fivetran_synced

  , a.effective_at::timestamp               as effective_at
  , a._created_at::timestamp                as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'email_subscription_change'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end    as is_latest
from {{ source('hubspot_network', 'email_subscription_change') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'email_subscription_change') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at