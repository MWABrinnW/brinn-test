select
    a.json:ID::text(500)                 as id
  , a.json:SUBJECT::text(500)            as subject
  , a.json:"FROM"::text(500)             as from_address
  , a.json:REPLY_TO::text(500)           as reply_to_address
  , a.json:CC::text(500)                 as cc_address
  , a.json:BCC::text(500)                as bcc_address
  , a.json:DROP_REASON::text(500)        as drop_reason
  , a.json:DROP_MESSAGE::text(500)       as drop_message
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'email_event_dropped'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'email_event_dropped') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'email_event_dropped') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at