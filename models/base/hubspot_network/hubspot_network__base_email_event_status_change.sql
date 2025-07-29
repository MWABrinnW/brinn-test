select
    a.json:ID::text(500)                         as id
  , a.json:SOURCE::text(500)                     as source
  , a.json:REQUESTED_BY::text(500)               as requested_by
  , a.json:PORTAL_SUBSCRIPTION_STATUS::text(500) as portal_subscription_status
  , a.json:SUBSCRIPTIONS::text(500)              as subscriptions
  , a.json:BOUNCED::text(500)                    as bounced
  , a.json:_FIVETRAN_SYNCED::text(500)           as _fivetran_synced

  , a.effective_at::timestamp                    as effective_at
  , a._created_at::timestamp                     as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'email_event_status_change'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end         as is_latest
from {{ source('hubspot_network', 'email_event_status_change') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'email_event_status_change') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at