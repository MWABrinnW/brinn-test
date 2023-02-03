select
    engagement_id
    , body
    , start_time
    , end_time
    , title
    , external_url
    , source
    , created_from_link_id
    , source_id
    , web_conference_meeting_id
    , meeting_outcome
    , pre_meeting_prospect_reminders
    , attendee_owner_ids
    , _fivetran_synced
from {{ source('hubspot_network', 'engagement_meeting') }}