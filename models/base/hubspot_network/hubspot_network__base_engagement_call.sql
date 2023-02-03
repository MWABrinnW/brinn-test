select
    engagement_id
    , to_number
    , from_number
    , status
    , external_id
    , duration_milliseconds
    , external_account_id
    , recording_url
    , body
    , disposition
    , callee_object_type
    , callee_object_id
    , transcription_id
    , unknown_visitor_conversation
    , source
    , title
    , _fivetran_synced
    , direction
from {{ source('hubspot_network', 'engagement_call') }}