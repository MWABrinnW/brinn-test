select
    engagement_id
    , from_email
    , from_first_name
    , from_last_name
    , subject
    , html
    , text
    , tracker_key
    , message_id
    , thread_id
    , status
    , sent_via
    , logged_from
    , error_message
    , facsimile_send_id
    , post_send_status
    , media_processing_status
    , attached_video_opened
    , attached_video_watched
    , attached_video_id
    , recipient_drop_reasons
    , validation_skipped
    , email_send_event_id_created
    , email_send_event_id_id
    , pending_inline_image_ids
    , bounce_error_detail
    , _fivetran_synced
    , member_of_forwarded_subthread
    , encoded_email_associations_request
from {{ source('hubspot_network', 'engagement_email') }}