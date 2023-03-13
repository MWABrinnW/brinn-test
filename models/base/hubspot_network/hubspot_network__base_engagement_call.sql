select
    a.json:ENGAGEMENT_ID::text(500)                as engagement_id
  , a.json:TO_NUMBER::text(500)                    as to_number
  , a.json:FROM_NUMBER::text(500)                  as from_number
  , a.json:STATUS::text(500)                       as status
  , a.json:EXTERNAL_ID::text(500)                  as external_id
  , a.json:DURATION_MILLISECONDS::text(500)        as duration_milliseconds
  , a.json:EXTERNAL_ACCOUNT_ID::text(500)          as external_account_id
  , a.json:RECORDING_URL::text(500)                as recording_url
  , a.json:BODY::text(500)                         as body
  , a.json:DISPOSITION::text(500)                  as disposition
  , a.json:CALLEE_OBJECT_TYPE::text(500)           as callee_object_type
  , a.json:CALLEE_OBJECT_ID::text(500)             as callee_object_id
  , a.json:TRANSCRIPTION_ID::text(500)             as transcription_id
  , a.json:UNKNOWN_VISITOR_CONVERSATION::text(500) as unknown_visitor_conversation
  , a.json:SOURCE::text(500)                       as source
  , a.json:TITLE::text(500)                        as title
  , a.json:_FIVETRAN_SYNCED::text(500)             as _fivetran_synced
  , a.json:DIRECTION::text(500)                    as direction

  , a.effective_at::timestamp                      as effective_at
  , a._created_at::timestamp                       as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'engagement_call'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end           as is_latest
from {{ source('hubspot_network', 'engagement_call') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'engagement_call') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at