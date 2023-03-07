select
    a.json:ENGAGEMENT_ID::text(500)                      as engagement_id
  , a.json:FROM_EMAIL::text(500)                         as from_email
  , a.json:FROM_FIRST_NAME::text(500)                    as from_first_name
  , a.json:FROM_LAST_NAME::text(500)                     as from_last_name
  , a.json:SUBJECT::text                                 as subject
  , a.json:HTML::text                                    as html
  , a.json:TEXT::text                                    as text
  , a.json:TRACKER_KEY::text(500)                        as tracker_key
  , a.json:MESSAGE_ID::text(500)                         as message_id
  , a.json:THREAD_ID::text(500)                          as thread_id
  , a.json:STATUS::text(500)                             as status
  , a.json:SENT_VIA::text(500)                           as sent_via
  , a.json:LOGGED_FROM::text(500)                        as logged_from
  , a.json:ERROR_MESSAGE::text(500)                      as error_message
  , a.json:FACSIMILE_SEND_ID::text(500)                  as facsimile_send_id
  , a.json:POST_SEND_STATUS::text(500)                   as post_send_status
  , a.json:MEDIA_PROCESSING_STATUS::text(500)            as media_processing_status
  , a.json:ATTACHED_VIDEO_OPENED::text(500)              as attached_video_opened
  , a.json:ATTACHED_VIDEO_WATCHED::text(500)             as attached_video_watched
  , a.json:ATTACHED_VIDEO_ID::text(500)                  as attached_video_id
  , a.json:RECIPIENT_DROP_REASONS::text(500)             as recipient_drop_reasons
  , a.json:VALIDATION_SKIPPED::text(500)                 as validation_skipped
  , a.json:EMAIL_SEND_EVENT_ID_CREATED::text(500)        as email_send_event_id_created
  , a.json:EMAIL_SEND_EVENT_ID_ID::text(500)             as email_send_event_id_id
  , a.json:PENDING_INLINE_IMAGE_IDS::text(500)           as pending_inline_image_ids
  , a.json:BOUNCE_ERROR_DETAIL::text(500)                as bounce_error_detail
  , a.json:_FIVETRAN_SYNCED::text(500)                   as _fivetran_synced
  , a.json:MEMBER_OF_FORWARDED_SUBTHREAD::text(500)      as member_of_forwarded_subthread
  , a.json:ENCODED_EMAIL_ASSOCIATIONS_REQUEST::text(500) as encoded_email_associations_request

  , a.effective_at::timestamp                            as effective_at
  , a._created_at::timestamp                             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'engagement_email'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                 as is_latest
from {{ source('hubspot_network', 'engagement_email') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'engagement_email') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at