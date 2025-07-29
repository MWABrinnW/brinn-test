select
    a.json:ID::text(500)                                       as id
  , a.json:SUBSCRIPTION::text(500)                             as subscription
  , a.json:AB::text(500)                                       as ab
  , a.json:AB_HOURS_TO_WAIT::text(500)                         as ab_hours_to_wait
  , a.json:AB_VARIATION::text(500)                             as ab_variation
  , a.json:AB_SAMPLE_SIZE_DEFAULT::text(500)                   as ab_sample_size_default
  , a.json:AB_SAMPLING_DEFAULT::text(500)                      as ab_sampling_default
  , a.json:AB_STATUS::text(500)                                as ab_status
  , a.json:AB_SUCCESS_METRIC::text(500)                        as ab_success_metric
  , a.json:AB_TEST_ID::text(500)                               as ab_test_id
  , a.json:AB_TEST_PERCENTAGE::text(500)                       as ab_test_percentage
  , a.json:ABSOLUTE_URL::text(500)                             as absolute_url
  , a.json:ANALYTICS_PAGE_ID::text(500)                        as analytics_page_id
  , a.json:ANALYTICS_PAGE_TYPE::text(500)                      as analytics_page_type
  , a.json:ARCHIVED::text(500)                                 as archived
  , a.json:AUTHOR::text(500)                                   as author
  , a.json:AUTHOR_AT::text(500)                                as author_at
  , a.json:AUTHOR_EMAIL::text(500)                             as author_email
  , a.json:AUTHOR_NAME::text(500)                              as author_name
  , a.json:AUTHOR_USER_ID::text(500)                           as author_user_id
  , a.json:BLOG_EMAIL_TYPE::text(500)                          as blog_email_type
  , a.json:CAMPAIGN::text(500)                                 as campaign
  , a.json:CAMPAIGN_NAME::text(500)                            as campaign_name
  , a.json:CAN_SPAM_SETTINGS_ID::text(500)                     as can_spam_settings_id
  , a.json:CLONED_FROM::text(500)                              as cloned_from
  , a.json:CREATE_PAGE::text(500)                              as create_page
  , a.json:CREATED::text(500)                                  as created
  , a.json:CURRENTLY_PUBLISHED::text(500)                      as currently_published
  , a.json:DOMAIN::text(500)                                   as domain
  , a.json:EMAIL_BODY::text                                    as email_body
  , a.json:EMAIL_NOTE::text                                    as email_note
  , a.json:EMAIL_TYPE::text(500)                               as email_type
  , a.json:FEEDBACK_EMAIL_CATEGORY::text(500)                  as feedback_email_category
  , a.json:FEEDBACK_SURVEY_ID::text(500)                       as feedback_survey_id
  , a.json:FOLDER_ID::text(500)                                as folder_id
  , a.json:FREEZE_DATE::text(500)                              as freeze_date
  , a.json:FROM_NAME::text(500)                                as from_name
  , a.json:IS_GRAYMAIL_SUPPRESSION_ENABLED::text(500)          as is_graymail_suppression_enabled
  , a.json:IS_LOCAL_TIMEZONE_SEND::text(500)                   as is_local_timezone_send
  , a.json:IS_PUBLISHED::text(500)                             as is_published
  , a.json:IS_RECIPIENT_FATIGUE_SUPPRESSIOn_enabled::text(500) as is_recipient_fatigue_suppressio
  , a.json:LEAD_FLOW_ID::text(500)                             as lead_flow_id
  , a.json:LIVE_DOMAIN::text(500)                              as live_domain
  , a.json:META_DESCRIPTION::text(500)                         as meta_description
  , a.json:NAME::text(500)                                     as name
  , a.json:PAGE_EXPIRY_DATE::text(500)                         as page_expiry_date
  , a.json:PAGE_EXPIRY_REDIRECT_ID::text(500)                  as page_expiry_redirect_id
  , a.json:PAGE_REDIRECTED::text(500)                          as page_redirected
  , a.json:PORTAL_ID::text(500)                                as portal_id
  , a.json:PREVIEW_KEY::text(500)                              as preview_key
  , a.json:PROCESSING_STATUS::text(500)                        as processing_status
  , a.json:PUBLISH_DATE::text(500)                             as publish_date
  , a.json:PUBLISHED_AT::text(500)                             as published_at
  , a.json:PUBLISHED_BY_ID::text(500)                          as published_by_id
  , a.json:PUBLISHED_BY_NAME::text(500)                        as published_by_name
  , a.json:PUBLISH_IMMEDIATELY::text(500)                      as publish_immediately
  , a.json:PUBLISHED_URL::text(500)                            as published_url
  , a.json:REPLY_TO::text(500)                                 as reply_to
  , a.json:RESOLVED_DOMAIN::text(500)                          as resolved_domain
  , a.json:SLUG::text(500)                                     as slug
  , a.json:SUBCATEGORY::text(500)                              as subcategory
  , a.json:SUBJECT::text(2000)                                 as subject
  , a.json:SUBSCRIPTION_BLOG_ID::text(500)                     as subscription_blog_id
  , a.json:SUBSCRIPTION_NAME::text(500)                        as subscription_name
  , a.json:TRANSACTIONAL::text(500)                            as transactional
  , a.json:UNPUBLISHED_AT::text(500)                           as unpublished_at
  , a.json:UPDATED::text(500)                                  as updated
  , a.json:UPDATED_BY_ID::text(500)                            as updated_by_id
  , a.json:URL::text(500)                                      as url
  , a.json:_FIVETRAN_SYNCED::text(500)                         as _fivetran_synced

  , a.effective_at::timestamp                                  as effective_at
  , a._created_at::timestamp                                   as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'marketing_email'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                       as is_latest
from {{ source('hubspot_network', 'marketing_email') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'marketing_email') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at