select
    a.json:ENGAGEMENT_ID::text(500)                  as engagement_id
  , a.json:BODY::text(500)                           as body
  , a.json:START_TIME::text(500)                     as start_time
  , a.json:END_TIME::text(500)                       as end_time
  , a.json:TITLE::text(500)                          as title
  , a.json:EXTERNAL_URL::text(500)                   as external_url
  , a.json:SOURCE::text(500)                         as source
  , a.json:CREATED_FROM_LINK_ID::text(500)           as created_from_link_id
  , a.json:SOURCE_ID::text(500)                      as source_id
  , a.json:WEB_CONFERENCE_MEETING_ID::text(500)      as web_conference_meeting_id
  , a.json:MEETING_OUTCOME::text(500)                as meeting_outcome
  , a.json:PRE_MEETING_PROSPECT_REMINDERS::text(500) as pre_meeting_prospect_reminders
  , a.json:ATTENDEE_OWNER_IDS::text(500)             as attendee_owner_ids
  , a.json:_FIVETRAN_SYNCED::text(500)               as _fivetran_synced

  , a.effective_at::timestamp                        as effective_at
  , a._created_at::timestamp                         as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'engagement_meeting'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end             as is_latest
from {{ source('hubspot_network', 'engagement_meeting') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'engagement_meeting') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at