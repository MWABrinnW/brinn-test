select
    a.json:ID ::text(500)                                                          as id
  , a.json:_FIVETRAN_DELETED::int                                                  as _fivetran_deleted
  , try_to_timestamp(a.json:_FIVETRAN_SYNCED ::text)                               as _fivetran_synced
  , a.json:PROPERTY_HS_ALL_CONTACT_VIDS ::text(500)                                as property_hs_all_contact_vids
  , a.json:PROPERTY_FIRST_DEAL_CREATED_DATE ::text(500)                            as property_first_deal_created_date
  , a.json:PROPERTY_HS_CALCULATED_MOBILE_NUMBER ::text(500)                        as property_hs_calculated_mobile_number
  , a.json:PROPERTY_HS_DATE_ENTERED_CUSTOMER ::text(500)                           as property_hs_date_entered_customer
  , a.json:PROPERTY_HS_COUNT_IS_WORKED ::text(500)                                 as property_hs_count_is_worked
  , a.json:PROPERTY_DAYS_TO_CLOSE ::text(500)                                      as property_days_to_close
  , a.json:PROPERTY_HS_COUNT_IS_UNWORKED ::text(500)                               as property_hs_count_is_unworked
  , a.json:PROPERTY_GDC ::text(500)                                                as property_gdc
  , a.json:PROPERTY_ASSETS_UNDER_MANAGMENT ::text(500)                             as property_assets_under_managment
  , a.json:PROPERTY_HS_CALCULATED_PHONE_NUMBER_COUNTRY_CODE ::text(500)            as property_hs_calculated_phone_number_country_code
  , a.json:PROPERTY_HS_CALCULATED_PHONE_NUMBER ::text(500)                         as property_hs_calculated_phone_number
  , a.json:PROPERTY_HS_CALCULATED_MERGED_VIDS ::text(500)                          as property_hs_calculated_merged_vids
  , a.json:PROPERTY_HS_AVATAR_FILEMANAGER_KEY ::text(500)                          as property_hs_avatar_filemanager_key
  , a.json:PROPERTY_HS_CALCULATED_FORM_SUBMISSIONS ::text(500)                     as property_hs_calculated_form_submissions
  , a.json:PROPERTY_FIRST_CONVERSION_DATE ::text(500)                              as property_first_conversion_date
  , a.json:PROPERTY_FIRST_CONVERSION_EVENT_NAME ::text(500)                        as property_first_conversion_event_name
  , a.json:PROPERTY_CALL_DISPOSITION ::text(500)                                   as property_call_disposition
  , a.json:PROPERTY_HOME_CITY ::text(500)                                          as property_home_city
  , a.json:PROPERTY_HOME_ZIPCODE ::text(500)                                       as property_home_zipcode
  , a.json:PROPERTY_DATE_OF_BIRTH ::date                                           as property_date_of_birth
  , a.json:PROPERTY_HOME_STATE ::text(500)                                         as property_home_state
  , a.json:PROPERTY_HOME_ADDRESS_1 ::text(500)                                     as property_home_address_1
  , a.json:PROPERTY_HS_ADDITIONAL_EMAILS ::text(500)                               as property_hs_additional_emails
  , a.json:PROPERTY_GENDER ::text(500)                                             as property_gender
  , a.json:PROPERTY_HS_CREATED_BY_USER_ID ::text(500)                              as property_hs_created_by_user_id
  , a.json:PROPERTY_HOME_ADDRESS_2 ::text(500)                                     as property_home_address_2
  , a.json:PROPERTY_HS_CONTENT_MEMBERSHIP_STATUS ::text(500)                       as property_hs_content_membership_status
  , a.json:PROPERTY_HS_DATE_ENTERED_OPPORTUNITY ::text(500)                        as property_hs_date_entered_opportunity
  , a.json:PROPERTY_HS_IS_UNWORKED ::text(500)                                     as property_hs_is_unworked
  , a.json:PROPERTY_HS_DATE_ENTERED_LEAD ::text(500)                               as property_hs_date_entered_lead
  , a.json:PROPERTY_HS_DATE_EXITED_LEAD ::text(500)                                as property_hs_date_exited_lead
  , a.json:PROPERTY_HS_IS_CONTACT ::text(500)                                      as property_hs_is_contact
  , a.json:PROPERTY_HS_EMAIL_DOMAIN ::text(500)                                    as property_hs_email_domain
  , a.json:PROPERTY_HS_LAST_SALES_ACTIVITY_TIMESTAMP::timestamp                    as property_hs_last_sales_activity_timestamp
  , a.json:PROPERTY_HS_LAST_SALES_ACTIVITY_DATE ::date                             as property_hs_last_sales_activity_date
  , a.json:PROPERTY_HS_DATE_EXITED_OPPORTUNITY ::text(500)                         as property_hs_date_exited_opportunity
  , a.json:PROPERTY_HS_FIRST_ENGAGEMENT_OBJECT_ID ::text(500)                      as property_hs_first_engagement_object_id
  , a.json:PROPERTY_HS_DATE_ENTERED_SUBSCRIBER ::text(500)                         as property_hs_date_entered_subscriber
  , a.json:PROPERTY_HS_DATE_EXITED_SUBSCRIBER ::text(500)                          as property_hs_date_exited_subscriber
  , a.json:PROPERTY_HS_EMAIL_SENDS_SINCE_LAST_ENGAGEMENT ::int                     as property_hs_email_sends_since_last_engagement
  , a.json:PROPERTY_HS_LAST_SALES_ACTIVITY_TYPE ::text(500)                        as property_hs_last_sales_activity_type
  , a.json:PROPERTY_HS_IP_TIMEZONE ::text(500)                                     as property_hs_ip_timezone
  , a.json:PROPERTY_HS_EMAIL_HARD_BOUNCE_REASON_ENUM ::text(500)                   as property_hs_email_hard_bounce_reason_enum
  , a.json:PROPERTY_HS_LATEST_SEQUENCE_ENROLLED_DATE ::text(500)                   as property_hs_latest_sequence_enrolled_date
  , a.json:PROPERTY_HS_LATEST_SEQUENCE_ENROLLED ::text(500)                        as property_hs_latest_sequence_enrolled
  , a.json:PROPERTY_HS_PIPELINE ::text(500)                                        as property_hs_pipeline
  , a.json:PROPERTY_HS_MARKETABLE_UNTIL_RENEWAL ::text(500)                        as property_hs_marketable_until_renewal
  , a.json:PROPERTY_HS_LATEST_SOURCE_TIMESTAMP ::text(500)                         as property_hs_latest_source_timestamp
  , a.json:PROPERTY_HS_OBJECT_ID ::text(500)                                       as property_hs_object_id
  , a.json:PROPERTY_HS_TIME_IN_OPPORTUNITY ::text(500)                             as property_hs_time_in_opportunity
  , a.json:PROPERTY_HS_MARKETABLE_STATUS ::text(500)                               as property_hs_marketable_status
  , a.json:PROPERTY_HS_TIME_IN_LEAD ::text(500)                                    as property_hs_time_in_lead
  , a.json:PROPERTY_HS_TIME_BETWEEN_CONTACT_CREATION_AND_DEAL_CLOSE ::text(500)    as property_hs_time_between_contact_creation_and_deal_close
  , a.json:PROPERTY_HS_TIME_TO_MOVE_FROM_LEAD_TO_CUSTOMER ::text(500)              as property_hs_time_to_move_from_lead_to_customer
  , a.json:PROPERTY_HS_SEARCHABLE_CALCULATED_MOBILE_NUMBER ::text(500)             as property_hs_searchable_calculated_mobile_number
  , a.json:PROPERTY_HS_TIME_TO_MOVE_FROM_OPPORTUNITY_TO_CUSTOMER ::text(500)       as property_hs_time_to_move_from_opportunity_to_customer
  , a.json:PROPERTY_HS_SALES_EMAIL_LAST_OPENED ::text(500)                         as property_hs_sales_email_last_opened
  , a.json:PROPERTY_HS_TIME_IN_CUSTOMER ::text(500)                                as property_hs_time_in_customer
  , a.json:PROPERTY_HS_LEAD_STATUS ::text(500)                                     as property_hs_lead_status
  , a.json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_OBJECT_TYPE ::text(500)                 as property_hs_sa_first_engagement_object_type
  , a.json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_DATE ::text(500)                        as property_hs_sa_first_engagement_date
  , a.json:PROPERTY_HS_TIME_BETWEEN_CONTACT_CREATION_AND_DEAL_CREATION ::text(500) as property_hs_time_between_contact_creation_and_deal_creation
  , a.json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_DESCR ::text(500)                       as property_hs_sa_first_engagement_descr
  , a.json:PROPERTY_HS_TIME_TO_FIRST_ENGAGEMENT ::text(500)                        as property_hs_time_to_first_engagement
  , a.json:PROPERTY_HS_SEARCHABLE_CALCULATED_PHONE_NUMBER ::text(500)              as property_hs_searchable_calculated_phone_number
  , a.json:PROPERTY_HS_SALES_EMAIL_LAST_CLICKED ::text(500)                        as property_hs_sales_email_last_clicked
  , a.json:PROPERTY_HS_TIME_IN_SUBSCRIBER ::text(500)                              as property_hs_time_in_subscriber
  , a.json:PROPERTY_HS_TIMEZONE ::text(500)                                        as property_hs_timezone
  , a.json:PROPERTY_HS_LEGAL_BASIS ::text(500)                                     as property_hs_legal_basis
  , a.json:PROPERTY_HS_TIME_TO_MOVE_FROM_SUBSCRIBER_TO_CUSTOMER ::text(500)        as property_hs_time_to_move_from_subscriber_to_customer
  , a.json:PROPERTY_HS_SEQUENCES_ACTIVELY_ENROLLED_COUNT ::text(500)               as property_hs_sequences_actively_enrolled_count
  , a.json:PROPERTY_HS_PINNED_ENGAGEMENT_ID ::text(500)                            as property_hs_pinned_engagement_id
  , a.json:PROPERTY_HS_SEQUENCES_IS_ENROLLED ::text(500)                           as property_hs_sequences_is_enrolled
  , a.json:PROPERTY_HS_SEQUENCES_ENROLLED_COUNT ::text(500)                        as property_hs_sequences_enrolled_count
  , a.json:PROPERTY_RECENT_DEAL_CLOSE_DATE ::text(500)                             as property_recent_deal_close_date
  , a.json:PROPERTY_HS_EMAIL_OPTOUT_7368234 ::text(500)                            as property_hs_email_optout_7368234
  , a.json:PROPERTY_NUM_CONVERSION_EVENTS ::text(500)                              as property_num_conversion_events
  , a.json:PROPERTY_FIRSTNAME ::text(500)                                          as property_firstname
  , a.json:PROPERTY_NUM_UNIQUE_CONVERSION_EVENTS ::text(500)                       as property_num_unique_conversion_events
  , a.json:PROPERTY_NUM_ASSOCIATED_DEALS ::text(500)                               as property_num_associated_deals
  , a.json:PROPERTY_LASTMODIFIEDDATE ::timestamp                                   as property_lastmodifieddate
  , a.json:PROPERTY_RECENT_DEAL_AMOUNT ::text(500)                                 as property_recent_deal_amount
  , a.json:PROPERTY_TOTAL_REVENUE ::decimal(18, 2)                                 as property_total_revenue
  , a.json:PROPERTY_TWITTERHANDLE ::text(500)                                      as property_twitterhandle
  , a.json:PROPERTY_REFERAL_PARTNER ::text(500)                                    as property_referal_partner
  , a.json:PROPERTY_HS_USER_IDS_OF_ALL_OWNERS ::text(500)                          as property_hs_user_ids_of_all_owners
  , a.json:PROPERTY_HUBSPOT_OWNER_ASSIGNEDDATE ::text(500)                         as property_hubspot_owner_assigneddate
  , a.json:PROPERTY_RECRUITER_CUSTODIAN_SALES_TEAM ::text(500)                     as property_recruiter_custodian_sales_team
  , a.json:PROPERTY_HS_EMAIL_OPTOUT_7484018 ::text(500)                            as property_hs_email_optout_7484018
  , a.json:PROPERTY_SOCIAL_MEDIA ::text(500)                                       as property_social_media
  , a.json:PROPERTY_SPOUSE_NAME ::text(500)                                        as property_spouse_name
  , a.json:PROPERTY_HS_UPDATED_BY_USER_ID ::text(500)                              as property_hs_updated_by_user_id
  , a.json:PROPERTY_HS_EMAIL_DELIVERED ::text(500)                                 as property_hs_email_delivered
  , a.json:PROPERTY_IP_STATE_CODE ::text(500)                                      as property_ip_state_code
  , a.json:PROPERTY_IP_CITY ::text(500)                                            as property_ip_city
  , a.json:PROPERTY_RECENT_CONVERSION_EVENT_NAME ::text(500)                       as property_recent_conversion_event_name
  , a.json:PROPERTY_IP_COUNTRY ::text(500)                                         as property_ip_country
  , a.json:PROPERTY_IP_STATE ::text(500)                                           as property_ip_state
  , a.json:PROPERTY_RECENT_CONVERSION_DATE ::text(500)                             as property_recent_conversion_date
  , a.json:PROPERTY_IP_COUNTRY_CODE ::text(500)                                    as property_ip_country_code
  , a.json:PROPERTY_STREET_ADDRESS_2 ::text(500)                                   as property_street_address_2
  , a.json:PROPERTY_WORK_EMAIL ::text(500)                                         as property_work_email
  , a.json:PROPERTY_HS_USER_IDS_OF_ALL_NOTIFICATION_UNFOLLOWERS ::text(500)        as property_hs_user_ids_of_all_notification_unfollowers
  , a.json:PROPERTY_HS_USER_IDS_OF_ALL_NOTIFICATION_FOLLOWERS ::text(500)          as property_hs_user_ids_of_all_notification_followers
  , a.json:PROPERTY_OUTBOUND_ADVISOR_RETIREMENT ::text(500)                        as property_outbound_advisor_retirement
  , a.json:PROPERTY_REPCRD ::text(500)                                             as property_repcrd
  , a.json:PROPERTY_RIAFIRMCRD ::text(500)                                         as property_riafirmcrd
  , a.json:PROPERTY_RIAFIRMNAME ::text(500)                                        as property_riafirmname
  , a.json:PROPERTY_CITY ::text(500)                                               as property_city
  , a.json:PROPERTY_LASTNAME ::text(500)                                           as property_lastname
  , a.json:PROPERTY_HS_ANALYTICS_NUM_PAGE_VIEWS ::text(500)                        as property_hs_analytics_num_page_views
  , a.json:PROPERTY_HUBSPOT_TEAM_ID ::text(500)                                    as property_hubspot_team_id
  , a.json:PROPERTY_HS_ANALYTICS_NUM_EVENT_COMPLETIONS ::text(500)                 as property_hs_analytics_num_event_completions
  , a.json:PROPERTY_HS_EMAIL_OPTOUT ::text(500)                                    as property_hs_email_optout
  , a.json:PROPERTY_HS_ANALYTICS_FIRST_TIMESTAMP ::text(500)                       as property_hs_analytics_first_timestamp
  , a.json:PROPERTY_TWITTERPROFILEPHOTO ::text(500)                                as property_twitterprofilephoto
  , a.json:PROPERTY_HS_ANALYTICS_NUM_VISITS ::text(500)                            as property_hs_analytics_num_visits
  , a.json:PROPERTY_EMAIL ::text(500)                                              as property_email
  , a.json:PROPERTY_HS_SOCIAL_FACEBOOK_CLICKS ::text(500)                          as property_hs_social_facebook_clicks
  , a.json:PROPERTY_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP ::text(500)                 as property_hs_analytics_first_visit_timestamp
  , a.json:PROPERTY_HS_ANALYTICS_LAST_TIMESTAMP ::text(500)                        as property_hs_analytics_last_timestamp
  , a.json:PROPERTY_HS_SOCIAL_GOOGLE_PLUS_CLICKS ::text(500)                       as property_hs_social_google_plus_clicks
  , a.json:PROPERTY_HS_ALL_OWNER_IDS ::text(500)                                   as property_hs_all_owner_ids
  , a.json:PROPERTY_HS_SOCIAL_TWITTER_CLICKS ::text(500)                           as property_hs_social_twitter_clicks
  , a.json:PROPERTY_HS_SOCIAL_LINKEDIN_CLICKS ::text(500)                          as property_hs_social_linkedin_clicks
  , a.json:PROPERTY_NUM_NOTES ::text(500)                                          as property_num_notes
  , a.json:PROPERTY_ENGAGEMENTS_LAST_MEETING_BOOKED::text(500)                     as property_engagements_last_meeting_booked
  , a.json:PROPERTY_NOTES_LAST_UPDATED ::text(500)                                 as property_notes_last_updated
  , a.json:PROPERTY_MOBILEPHONE ::text(500)                                        as property_mobilephone
  , a.json:PROPERTY_NOTES_NEXT_ACTIVITY_DATE ::text(500)                           as property_notes_next_activity_date
  , a.json:PROPERTY_NOTES_LAST_CONTACTED ::text(500)                               as property_notes_last_contacted
  , a.json:PROPERTY_ADDRESS ::text(500)                                            as property_address
  , a.json:PROPERTY_HS_SALES_EMAIL_LAST_REPLIED ::text(500)                        as property_hs_sales_email_last_replied
  , a.json:PROPERTY_NUM_CONTACTED_NOTES ::text(500)                                as property_num_contacted_notes
  , a.json:PROPERTY_HUBSPOT_OWNER_ID ::text(500)                                   as property_hubspot_owner_id
  , a.json:PROPERTY_PHONE ::text(500)                                              as property_phone
  , a.json:PROPERTY_FAX ::text(500)                                                as property_fax
  , a.json:PROPERTY_HS_EMAIL_LAST_EMAIL_NAME ::text(500)                           as property_hs_email_last_email_name
  , a.json:PROPERTY_HS_EMAIL_LAST_SEND_DATE ::text(500)                            as property_hs_email_last_send_date
  , a.json:PROPERTY_HS_LATEST_MEETING_ACTIVITY ::text(500)                         as property_hs_latest_meeting_activity
  , a.json:PROPERTY_HS_ANALYTICS_LAST_URL ::text(500)                              as property_hs_analytics_last_url
  , a.json:PROPERTY_HS_EMAIL_OPEN ::text(500)                                      as property_hs_email_open
  , a.json:PROPERTY_HS_EMAIL_LAST_OPEN_DATE ::text(500)                            as property_hs_email_last_open_date
  , a.json:PROPERTY_HS_EMAIL_BOUNCE ::text(500)                                    as property_hs_email_bounce
  , a.json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_2 ::text(500)                         as property_hs_analytics_source_data_2
  , a.json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_1 ::text(500)                         as property_hs_analytics_source_data_1
  , a.json:PROPERTY_HS_LATEST_SOURCE ::text(500)                                   as property_hs_latest_source
  , a.json:PROPERTY_HS_ANALYTICS_REVENUE ::text(500)                               as property_hs_analytics_revenue
  , a.json:PROPERTY_HS_ANALYTICS_AVERAGE_PAGE_VIEWS ::text(500)                    as property_hs_analytics_average_page_views
  , a.json:PROPERTY_HS_ALL_ACCESSIBLE_TEAM_IDS ::text(500)                         as property_hs_all_accessible_team_ids
  , a.json:PROPERTY_ASSOCIATEDCOMPANYID ::text(500)                                as property_associatedcompanyid
  , a.json:PROPERTY_WEBSITE ::text(500)                                            as property_website
  , a.json:PROPERTY_HS_SOCIAL_NUM_BROADCAST_CLICKS ::text(500)                     as property_hs_social_num_broadcast_clicks
  , a.json:PROPERTY_STATE ::text(500)                                              as property_state
  , a.json:PROPERTY_LIFECYCLESTAGE ::text(500)                                     as property_lifecyclestage
  , a.json:PROPERTY_HS_ANALYTICS_LAST_VISIT_TIMESTAMP ::text(500)                  as property_hs_analytics_last_visit_timestamp
  , a.json:PROPERTY_HS_LIFECYCLESTAGE_LEAD_DATE ::text(500)                        as property_hs_lifecyclestage_lead_date
  , a.json:PROPERTY_HS_ANALYTICS_SOURCE ::text(500)                                as property_hs_analytics_source
  , a.json:PROPERTY_CREATEDATE ::text(500)                                         as property_createdate
  , a.json:PROPERTY_HS_ALL_TEAM_IDS ::text(500)                                    as property_hs_all_team_ids
  , a.json:PROPERTY_HS_LIFECYCLESTAGE_OPPORTUNITY_DATE ::text(500)                 as property_hs_lifecyclestage_opportunity_date
  , a.json:PROPERTY_HS_LATEST_SOURCE_DATA_1 ::text(500)                            as property_hs_latest_source_data_1
  , a.json:PROPERTY_HS_LATEST_SOURCE_DATA_2 ::text(500)                            as property_hs_latest_source_data_2
  , a.json:PROPERTY_COMPANY ::text(500)                                            as property_company
  , a.json:PROPERTY_JOBTITLE ::text(500)                                           as property_jobtitle
  , a.json:PROPERTY_HS_LIFECYCLESTAGE_CUSTOMER_DATE ::text(500)                    as property_hs_lifecyclestage_customer_date
  , a.json:PROPERTY_CLOSEDATE ::text(500)                                          as property_closedate
  , a.json:PROPERTY_COUNTRY ::text(500)                                            as property_country
  , a.json:PROPERTY_ANNUALREVENUE ::text(500)                                      as property_annualrevenue
  , a.json:PROPERTY_HS_LIFECYCLESTAGE_SUBSCRIBER_DATE ::text(500)                  as property_hs_lifecyclestage_subscriber_date
  , a.json:PROPERTY_ZIP ::text(500)                                                as property_zip
  , a.json:PROPERTY_HS_EMAIL_FIRST_SEND_DATE ::text(500)                           as property_hs_email_first_send_date
  , a.json:PROPERTY_HS_EMAIL_FIRST_OPEN_DATE ::text(500)                           as property_hs_email_first_open_date
  , a.effective_at::timestamp                                                      as effective_at
  , a._created_at::timestamp                                                       as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'contact'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'contact') }} a
left join (
    select effective_at::date as effective_at
   , _created_at
   , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('hubspot_network', 'contact') }}
    group by 1, 2
    ) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at