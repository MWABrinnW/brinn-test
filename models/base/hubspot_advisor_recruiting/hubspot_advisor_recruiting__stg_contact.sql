select
    json:ID::text                                                                                   as id
    , json:_FIVETRAN_DELETED::int                                                                   as _fivetran_deleted
    , try_to_timestamp(json:_FIVETRAN_SYNCED::text)                                                 as _fivetran_synced
    , coalesce(
        try_to_date(json:PROPERTY_DATE_OF_BIRTH::text , 'MM-DD-YYYY')
        , try_to_date(json:PROPERTY_DATE_OF_BIRTH::text , 'MM/DD/YYYY')
    )                                                                                               as property_date_of_birth

    , try_to_boolean(json:IS_DELETED::text)::int                                          as is_deleted
    , json:PROPERTY_ADDRESS::text                                                         as property_address
    , json:PROPERTY_ADDRESS_2::text                                                       as property_address_2
    , json:PROPERTY_ANNUALREVENUE::text                                                   as property_annual_revenue
    , json:PROPERTY_ARE_YOU_A::text                                                       as property_are_you_a
    , json:PROPERTY_ASSETS_UNDER_MANAGEMENT_AUM_::text                                    as property_assets_under_management_aum
    , json:PROPERTY_AUM::text                                                             as property_aum
    , json:PROPERTY_BUSINESS_UNIT::text                                                   as property_business_unit
    , json:PROPERTY_CLOSEDATE::text                                                       as property_close_date
    , json:PROPERTY_COMPANY_SIZE::text                                                    as property_company_size
    , json:PROPERTY_CRD_NO_C::text                                                        as property_crd_noc
    , json:PROPERTY_CREATEDATE::text                                                      as property_create_date
    , try_to_boolean(json:PROPERTY_CURRENTLYINWORKFLOW::text)::int                        as property_currently_in_workflow
    , json:PROPERTY_CITY::text                                                            as property_city
    , json:PROPERTY_COMPANY::text                                                         as property_company
    , json:PROPERTY_COUNTRY::text                                                         as property_country
    , json:PROPERTY_CURRENT_LICENSE_S_::text                                              as property_current_licenses
    , json:PROPERTY_DAYS_TO_CLOSE::int                                                    as property_days_to_close
    , json:PROPERTY_DEGREE::text                                                          as property_degree
    , json:PROPERTY_EMAIL::text                                                           as property_email
    , json:PROPERTY_ENGAGEMENTS_LAST_MEETING_BOOKED::text
        as property_engagements_last_meeting_booked
    , json:PROPERTY_ENGAGEMENTS_LAST_MEETING_BOOKED_CAMPAIGN::text
        as property_engagements_last_meeting_booked_campaign
    , json:PROPERTY_ENGAGEMENTS_LAST_MEETING_BOOKED_MEDIUM::text
        as property_engagements_last_meeting_booked_medium
    , json:PROPERTY_ENGAGEMENTS_LAST_MEETING_BOOKED_SOURCE::text
        as property_engagements_last_meeting_booked_source
    , json:PROPERTY_FAX::text                                                             as property_fax
    , json:PROPERTY_FIELD_OF_STUDY::text                                                  as property_field_of_study
    , json:PROPERTY_FIRM_TYPE::text                                                       as property_firm_type
    , json:PROPERTY_FIRSTNAME::text                                                       as property_first_name
    , json:PROPERTY_FIRST_CONVERSION_DATE::text                                           as property_first_conversion_date
    , json:PROPERTY_FIRST_CONVERSION_EVENT_NAME::text                                     as property_first_conversion_event_name
    , json:PROPERTY_FULLNAME::text                                                        as property_full_name
    , json:PROPERTY_GENDER::text                                                          as property_gender
    , json:PROPERTY_GLP_ASSET_DOWNLOADED::text                                            as property_glp_asset_downloaded
    , json:PROPERTY_GRADUATION_DATE::text                                                 as property_graduation_date
    , json:PROPERTY_HS_ADDITIONAL_EMAILS::text                                            as property_hs_additional_emails
    , json:PROPERTY_HS_ALL_ACCESSIBLE_TEAM_IDS::text                                      as property_hs_all_accessible_team_ids
    , json:PROPERTY_HS_ALL_ASSIGNED_BUSINESS_UNIT_IDS::int
        as property_hs_all_assigned_business_unit_ids
    , json:PROPERTY_HS_ALL_CONTACT_VIDS::text                                             as property_hs_all_contact_vids
    , json:PROPERTY_HS_ALL_OWNER_IDS::int                                                 as property_hs_all_owner_ids
    , json:PROPERTY_HS_ALL_TEAM_IDS::int                                                  as property_hs_all_team_ids
    , json:PROPERTY_HS_ANALYTICS_AVERAGE_PAGE_VIEWS::int
        as property_hs_analytics_average_pageviews
    , json:PROPERTY_HS_ANALYTICS_FIRST_REFERRER::text                                     as property_hs_analytics_first_referrer
    , json:PROPERTY_HS_ANALYTICS_FIRST_TIMESTAMP::text
        as property_hs_analytics_first_time_stamp
    , json:PROPERTY_HS_ANALYTICS_FIRST_TOUCH_CONVERTING_CAMPAIGN::text
        as property_hs_analytics_first_touch_converting_campaign
    , json:PROPERTY_HS_ANALYTICS_FIRST_URL::text                                          as property_hs_analytics_first_url
    , json:PROPERTY_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP::text
        as property_hs_analytics_first_visit_timestamp
    , json:PROPERTY_HS_ANALYTICS_LAST_REFERRER::text                                      as property_hs_analytics_last_referrer
    , json:PROPERTY_HS_ANALYTICS_LAST_TIMESTAMP::text                                     as property_hs_analytics_last_time_stamp
    , json:PROPERTY_HS_ANALYTICS_LAST_TOUCH_CONVERTING_CAMPAIGN::text
        as property_hs_analytics_last_touch_converting_campaign
    , json:PROPERTY_HS_ANALYTICS_LAST_URL::text                                           as property_hs_analytics_last_url
    , json:PROPERTY_HS_ANALYTICS_LAST_VISIT_TIMESTAMP::text
        as property_hs_analytics_last_visit_timestamp
    , json:PROPERTY_HS_ANALYTICS_NUM_EVENT_COMPLETIONS::int
        as property_hs_analytics_num_event_completions
    , json:PROPERTY_HS_ANALYTICS_NUM_PAGE_VIEWS::int                                      as property_hs_analytics_num_pageviews
    , json:PROPERTY_HS_ANALYTICS_NUM_VISITS::int                                          as property_hs_analytics_num_visits
    , json:PROPERTY_HS_ANALYTICS_REVENUE::int                                             as property_hs_analytics_revenue
    , json:PROPERTY_HS_ANALYTICS_SOURCE::text                                             as property_hs_analytics_source
    , json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_1::text                                      as property_hs_analytics_source_data_1
    , json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_2::text                                      as property_hs_analytics_source_data_2
    , json:PROPERTY_HS_ASSOCIATED_TARGET_ACCOUNTS::int
        as property_hs_associated_target_accounts
    , json:PROPERTY_HS_CALCULATED_FORM_SUBMISSIONS::text
        as property_hs_calculated_form_submissions
    , json:PROPERTY_HS_CALCULATED_MERGED_VIDS::text                                       as property_hs_calculated_merged_vids
    , json:PROPERTY_HS_CALCULATED_MOBILE_NUMBER::int                                      as property_hs_calculated_mobile_number
    , json:PROPERTY_HS_CALCULATED_PHONE_NUMBER::int                                       as property_hs_calculated_phone_number
    , json:PROPERTY_HS_CALCULATED_PHONE_NUMBER_COUNTRY_CODE::text
        as property_hs_calculated_phone_number_country_code
    , json:PROPERTY_HS_CONTENT_MEMBERSHIP_EMAIL::text                                     as property_hs_content_membership_email
    , json:PROPERTY_HS_CONTENT_MEMBERSHIP_NOTES::text                                     as property_hs_content_membership_notes
    , json:PROPERTY_HS_COUNTRY_REGION_CODE::text                                          as property_hs_country_region_code
    , json:PROPERTY_HS_COUNT_IS_UNWORKED::int                                             as property_hs_count_is_unworked
    , json:PROPERTY_HS_COUNT_IS_WORKED::int                                               as property_hs_count_is_worked
    , json:PROPERTY_HS_CREATED_BY_USER_ID::int                                            as property_hs_created_by_userid
    , try_to_boolean(json:PROPERTY_HS_CURRENTLY_ENROLLED_IN_PROSPECTING_AGENT::text)::int
        as property_hs_currently_enrolled_in_prospecting_agent
    , json:PROPERTY_HS_DATE_ENTERED_100081836::text                                       as property_hs_date_entered_100081836
    , json:PROPERTY_HS_DATE_ENTERED_72175726::text                                        as property_hs_date_entered_72175726
    , json:PROPERTY_HS_DATE_ENTERED_991095214::text                                       as property_hs_date_entered_991095214
    , json:PROPERTY_HS_DATE_ENTERED_991119752::text                                       as property_hs_date_entered_991119752
    , json:PROPERTY_HS_DATE_ENTERED_999965360::text                                       as property_hs_date_entered_999965360
    , json:PROPERTY_HS_DATE_ENTERED_CUSTOMER::text                                        as property_hs_date_entered_customer
    , json:PROPERTY_HS_DATE_ENTERED_LEAD::text                                            as property_hs_date_entered_lead
    , json:PROPERTY_HS_DATE_ENTERED_MARKETINGQUALIFIEDLEAD::text
        as property_hs_date_entered_marketing_qualified_lead
    , json:PROPERTY_HS_DATE_ENTERED_OPPORTUNITY::text                                     as property_hs_date_entered_opportunity
    , json:PROPERTY_HS_DATE_ENTERED_OTHER::text                                           as property_hs_date_entered_other
    , json:PROPERTY_HS_DATE_ENTERED_SALESQUALIFIEDLEAD::text
        as property_hs_date_entered_sales_qualified_lead
    , json:PROPERTY_HS_DATE_ENTERED_SUBSCRIBER::text                                      as property_hs_date_entered_subscriber
    , json:PROPERTY_HS_DATE_EXITED_72175726::text                                         as property_hsdateexited72175726
    , json:PROPERTY_HS_DATE_EXITED_991095214::text                                        as property_hsdateexited991095214
    , json:PROPERTY_HS_DATE_EXITED_CUSTOMER::text                                         as property_hs_date_exited_customer
    , json:PROPERTY_HS_DATE_EXITED_LEAD::text                                             as property_hs_date_exited_lead
    , json:PROPERTY_HS_DATE_EXITED_MARKETINGQUALIFIEDLEAD::text
        as property_hs_date_exited_marketing_qualified_lead
    , json:PROPERTY_HS_DATE_EXITED_OPPORTUNITY::text                                      as property_hs_date_exited_opportunity
    , json:PROPERTY_HS_DATE_EXITED_OTHER::text                                            as property_hs_date_exited_other
    , json:PROPERTY_HS_DATE_EXITED_SALESQUALIFIEDLEAD::text
        as property_hs_date_exited_sales_qualified_lead
    , json:PROPERTY_HS_DATE_EXITED_SUBSCRIBER::text                                       as property_hs_date_exited_subscriber
    , try_to_boolean(json:PROPERTY_HS_EMAIL_BAD_ADDRESS::text)::int                       as property_hs_email_bad_address
    , json:PROPERTY_HS_EMAIL_BOUNCE::int                                                  as property_hs_email_bounce
    , json:PROPERTY_HS_EMAIL_CLICK::int                                                   as property_hs_email_click
    , json:PROPERTY_HS_EMAIL_DELIVERED::int                                               as property_hs_email_delivered
    , json:PROPERTY_HS_EMAIL_DOMAIN::text                                                 as property_hs_email_domain
    , json:PROPERTY_HS_EMAIL_FIRST_CLICK_DATE::text                                       as property_hs_email_first_click_date
    , json:PROPERTY_HS_EMAIL_FIRST_OPEN_DATE::text                                        as property_hs_email_first_open_date
    , json:PROPERTY_HS_EMAIL_FIRST_REPLY_DATE::text                                       as property_hs_email_first_reply_date
    , json:PROPERTY_HS_EMAIL_FIRST_SEND_DATE::text                                        as property_hs_email_first_send_date
    , json:PROPERTY_HS_EMAIL_HARD_BOUNCE_REASON_ENUM::text
        as property_hs_email_hard_bounce_reason_enum
    , json:PROPERTY_HS_EMAIL_LAST_CLICK_DATE::text                                        as property_hs_email_last_click_date
    , json:PROPERTY_HS_EMAIL_LAST_EMAIL_NAME::text                                        as property_hs_email_last_email_name
    , json:PROPERTY_HS_EMAIL_LAST_OPEN_DATE::text                                         as property_hs_email_last_open_date
    , json:PROPERTY_HS_EMAIL_LAST_REPLY_DATE::text                                        as property_hs_email_last_reply_date
    , json:PROPERTY_HS_EMAIL_LAST_SEND_DATE::text                                         as property_hs_email_last_send_date
    , json:PROPERTY_HS_EMAIL_OPEN::int                                                    as property_hs_email_open
    , json:PROPERTY_HS_EMAIL_OPTIMAL_SEND_DAY_OF_WEEK::text
        as property_hs_email_optimal_send_dayofweek
    , json:PROPERTY_HS_EMAIL_OPTIMAL_SEND_TIME_OF_DAY::text
        as property_hs_email_optimal_send_timeofday
    , try_to_boolean(json:PROPERTY_HS_EMAIL_OPTOUT::text)::int                            as property_hs_email_opt_out
    , try_to_boolean(json:PROPERTY_HS_EMAIL_OPTOUT_248809892::text)::int                  as property_hsemailoptout248809892
    , try_to_boolean(json:PROPERTY_HS_EMAIL_OPTOUT_80281074::text)::int                   as property_hsemailoptout80281074
    , try_to_boolean(json:PROPERTY_HS_EMAIL_OPTOUT_96308300::text)::int                   as property_hsemailoptout96308300
    , try_to_boolean(json:PROPERTY_HS_EMAIL_QUARANTINED::text)::int                       as property_hs_email_quarantined
    , json:PROPERTY_HS_EMAIL_QUARANTINED_REASON::text                                     as property_hs_email_quarantined_reason
    , json:PROPERTY_HS_EMAIL_REPLIED::int                                                 as property_hs_email_replied
    , json:PROPERTY_HS_EMAIL_SENDS_SINCE_LAST_ENGAGEMENT::int
        as property_hs_email_sends_since_last_engagement
    , try_to_boolean(json:PROPERTY_HS_ENRICHED_EMAIL_BOUNCE_DETECTED::text)::int
        as property_hs_enriched_email_bounce_detected
    , try_to_boolean(json:PROPERTY_HS_FACEBOOK_AD_CLICKED::text)::int                     as property_hs_facebook_ad_clicked
    , json:PROPERTY_HS_FACEBOOK_CLICK_ID::text                                            as property_hs_facebook_click_id
    , json:PROPERTY_HS_FIRST_ENGAGEMENT_OBJECT_ID::int                                    as property_hs_first_engagement_objectid
    , json:PROPERTY_HS_FIRST_OUTREACH_DATE::text                                          as property_hs_first_outreach_date
    , json:PROPERTY_HS_FULL_NAME_OR_EMAIL::text                                           as property_hs_full_name_or_email
    , json:PROPERTY_HS_GOOGLE_CLICK_ID::text                                              as property_hs_google_click_id
    , json:PROPERTY_HS_IP_TIMEZONE::text                                                  as property_h_sip_timezone
    , try_to_boolean(json:PROPERTY_HS_IS_CONTACT::text)::int                              as property_hs_is_contact
    , try_to_boolean(json:PROPERTY_HS_IS_ENRICHED::text)::int                             as property_hs_is_enriched
    , try_to_boolean(json:PROPERTY_HS_IS_UNWORKED::text)::int                             as property_hs_is_unworked
    , json:PROPERTY_HS_LAST_METERED_ENRICHMENT_TIMESTAMP::text
        as property_hs_last_metered_enrichment_timestamp
    , json:PROPERTY_HS_LAST_SALES_ACTIVITY_DATE::text                                     as property_hs_last_sales_activity_date
    , json:PROPERTY_HS_LAST_SALES_ACTIVITY_TIMESTAMP::text
        as property_hs_last_sales_activity_timestamp
    , json:PROPERTY_HS_LAST_SALES_ACTIVITY_TYPE::text                                     as property_hs_last_sales_activity_type
    , json:PROPERTY_HS_LATEST_MEETING_ACTIVITY::text                                      as property_hs_latest_meeting_activity
    , json:PROPERTY_HS_LATEST_SOURCE::text                                                as property_hs_latest_source
    , json:PROPERTY_HS_LATEST_SOURCE_DATA_1::text                                         as property_hs_latest_source_data_1
    , json:PROPERTY_HS_LATEST_SOURCE_DATA_2::text                                         as property_hs_latest_source_data_2
    , json:PROPERTY_HS_LATEST_SOURCE_TIMESTAMP::text                                      as property_hs_latest_source_timestamp
    , json:PROPERTY_HS_LEAD_STATUS::text                                                  as property_hs_lead_status
    , json:PROPERTY_HS_LIFECYCLESTAGE_CUSTOMER_DATE::text
        as property_hs_lifecycle_stage_customer_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_LEAD_DATE::text                                     as property_hs_lifecycle_stage_lead_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_MARKETINGQUALIFIEDLEAD_DATE::text
        as property_hs_lifecycle_stage_marketing_qualified_lead_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_OPPORTUNITY_DATE::text
        as property_hs_lifecycle_stage_opportunity_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_OTHER_DATE::text
        as property_hs_lifecycle_stage_other_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_SALESQUALIFIEDLEAD_DATE::text
        as property_hs_lifecycle_stage_sales_qualified_lead_date
    , json:PROPERTY_HS_LIFECYCLESTAGE_SUBSCRIBER_DATE::text
        as property_hs_lifecycle_stage_subscriber_date
    , try_to_boolean(json:PROPERTY_HS_LINKEDIN_AD_CLICKED::text)::int                     as property_hs_linkedin_ad_clicked
    , json:PROPERTY_HS_LINKEDIN_URL::text                                                 as property_hs_linked_in_url
    , json:PROPERTY_HS_LIVE_ENRICHMENT_DEADLINE::text                                     as property_hs_live_enrichment_deadline
    , json:PROPERTY_HS_MARKETABLE_REASON_ID::text                                         as property_hs_marketable_reason_id
    , json:PROPERTY_HS_MARKETABLE_REASON_TYPE::text                                       as property_hs_marketable_reason_type
    , try_to_boolean(json:PROPERTY_HS_MARKETABLE_STATUS::text)::int                       as property_hs_marketable_status
    , try_to_boolean(json:PROPERTY_HS_MARKETABLE_UNTIL_RENEWAL::text)::int                as property_hs_marketable_until_renewal
    , json:PROPERTY_HS_MEMBERSHIP_HAS_ACCESSED_PRIVATE_CONTENT::int
        as property_hs_membership_has_accessed_private_content
    , json:PROPERTY_HS_MERGED_OBJECT_IDS::text                                            as property_hs_merged_object_ids
    , json:PROPERTY_HS_MESSAGING_ENGAGEMENT_SCORE::float
        as property_hs_messaging_engagement_score
    , json:PROPERTY_HS_NOTES_NEXT_ACTIVITY_TYPE::text                                     as property_hs_notes_next_activity_type
    , json:PROPERTY_HS_OBJECT_ID::int                                                     as property_hs_objectid
    , json:PROPERTY_HS_OBJECT_SOURCE::text                                                as property_hs_object_source
    , json:PROPERTY_HS_OBJECT_SOURCE_DETAIL_1::text                                       as property_hs_object_source_detail_1
    , json:PROPERTY_HS_OBJECT_SOURCE_ID::text                                             as property_hs_object_sourceid
    , json:PROPERTY_HS_OBJECT_SOURCE_LABEL::text                                          as property_hs_object_source_label
    , json:PROPERTY_HS_OBJECT_SOURCE_USER_ID::int                                         as property_hs_object_source_userid
    , json:PROPERTY_HS_PIPELINE::text                                                     as property_hs_pipeline
    , json:PROPERTY_HS_PREDICTIVECONTACTSCORE_V_2::float
        as property_hs_predictive_contact_score_v2
    , json:PROPERTY_HS_PREDICTIVESCORINGTIER::text                                        as property_hs_predictive_scoring_tier
    , json:PROPERTY_HS_PROSPECTING_AGENT_ACTIVELY_ENROLLED_COUNT::int
        as property_hs_prospecting_agent_actively_enrolled_count
    , json:PROPERTY_HS_QUARANTINED_EMAILS::text                                           as property_hs_quarantined_emails
    , json:PROPERTY_HS_REGISTERED_MEMBER::int                                             as property_hs_registered_member
    , json:PROPERTY_HS_ROLE::text                                                         as property_hs_role
    , json:PROPERTY_HS_SALES_EMAIL_LAST_CLICKED::text                                     as property_hs_sales_email_last_clicked
    , json:PROPERTY_HS_SALES_EMAIL_LAST_OPENED::text                                      as property_hs_sales_email_last_opened
    , json:PROPERTY_HS_SALES_EMAIL_LAST_REPLIED::text                                     as property_hs_sales_email_last_replied
    , json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_DATE::text                                     as property_hss_a_first_engagement_date
    , json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_DESCR::text                                    as property_hss_a_first_engagement_descr
    , json:PROPERTY_HS_SA_FIRST_ENGAGEMENT_OBJECT_TYPE::text
        as property_hss_a_first_engagement_object_type
    , json:PROPERTY_HS_SEARCHABLE_CALCULATED_MOBILE_NUMBER::int
        as property_hs_searchable_calculated_mobile_number
    , json:PROPERTY_HS_SEARCHABLE_CALCULATED_PHONE_NUMBER::text
        as property_hs_searchable_calculated_phone_number
    , json:PROPERTY_HS_SENIORITY::text                                                    as property_hs_seniority
    , json:PROPERTY_HS_SEQUENCES_ACTIVELY_ENROLLED_COUNT::int
        as property_hs_sequences_actively_enrolled_count
    , json:PROPERTY_HS_SOCIAL_FACEBOOK_CLICKS::int                                        as property_hs_social_facebook_clicks
    , json:PROPERTY_HS_SOCIAL_GOOGLE_PLUS_CLICKS::int                                     as property_hs_social_google_plus_clicks
    , json:PROPERTY_HS_SOCIAL_LAST_ENGAGEMENT::text                                       as property_hs_social_last_engagement
    , json:PROPERTY_HS_SOCIAL_LINKEDIN_CLICKS::int                                        as property_hs_social_linked_in_clicks
    , json:PROPERTY_HS_SOCIAL_NUM_BROADCAST_CLICKS::int
        as property_hs_social_num_broadcast_clicks
    , json:PROPERTY_HS_SOCIAL_TWITTER_CLICKS::int                                         as property_hs_social_twitter_clicks
    , json:PROPERTY_HS_STATE_CODE::text                                                   as property_hs_state_code
    , json:PROPERTY_HS_SUB_ROLE::text                                                     as property_hs_sub_role
    , json:PROPERTY_HS_TIMEZONE::text                                                     as property_hs_timezone
    , json:PROPERTY_HS_TIME_BETWEEN_CONTACT_CREATION_AND_DEAL_CLOSE::int
        as property_hs_time_between_contact_creation_and_deal_close
    , json:PROPERTY_HS_TIME_IN_100081836::int                                             as property_hs_time_in_100081836
    , json:PROPERTY_HS_TIME_IN_72175726::int                                              as property_hs_time_in_72175726
    , json:PROPERTY_HS_TIME_IN_991095214::int                                             as property_hs_time_in_991095214
    , json:PROPERTY_HS_TIME_IN_991119752::int                                             as property_hs_time_in_991119752
    , json:PROPERTY_HS_TIME_IN_999965360::int                                             as property_hs_time_in_999965360
    , json:PROPERTY_HS_TIME_IN_CUSTOMER::int                                              as property_hs_time_in_customer
    , json:PROPERTY_HS_TIME_IN_LEAD::int                                                  as property_hs_time_in_lead
    , json:PROPERTY_HS_TIME_IN_MARKETINGQUALIFIEDLEAD::int
        as property_hs_time_in_marketing_qualified_lead
    , json:PROPERTY_HS_TIME_IN_OPPORTUNITY::int                                           as property_hs_time_in_opportunity
    , json:PROPERTY_HS_TIME_IN_OTHER::int                                                 as property_hs_time_in_other
    , json:PROPERTY_HS_TIME_IN_SALESQUALIFIEDLEAD::int
        as property_hs_time_in_sales_qualified_lead
    , json:PROPERTY_HS_TIME_IN_SUBSCRIBER::int                                            as property_hs_time_in_subscriber
    , json:PROPERTY_HS_TIME_TO_FIRST_ENGAGEMENT::int                                      as property_hs_time_to_first_engagement
    , json:PROPERTY_HS_TIME_TO_MOVE_FROM_LEAD_TO_CUSTOMER::int
        as property_hs_time_to_move_from_lead_to_customer
    , json:PROPERTY_HS_TIME_TO_MOVE_FROM_MARKETINGQUALIFIEDLEAD_TO_CUSTOMER::int
        as property_hs_time_to_move_from_marketing_qualified_lead_to_customer
    , json:PROPERTY_HS_TIME_TO_MOVE_FROM_SALESQUALIFIEDLEAD_TO_CUSTOMER::int
        as property_hs_time_to_move_from_sales_qualified_lead_to_customer
    , json:PROPERTY_HS_UNIQUE_CREATION_KEY::text                                          as property_hs_unique_creation_key
    , json:PROPERTY_HS_UPDATED_BY_USER_ID::int                                            as property_hs_updated_by_userid
    , json:PROPERTY_HS_USER_IDS_OF_ALL_OWNERS::int                                        as property_hs_userids_of_all_owners
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_100081836::int
        as property_hsv2_cumulative_time_in_100081836
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_72175726::int
        as property_hsv2_cumulative_time_in_72175726
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_991095214::int
        as property_hsv2_cumulative_time_in_991095214
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_999965360::int
        as property_hsv2_cumulative_time_in_999965360
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_CUSTOMER::int
        as property_hsv2_cumulative_time_in_customer
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_LEAD::int                                   as property_hsv2_cumulative_time_in_lead
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_MARKETINGQUALIFIEDLEAD::int
        as property_hsv2_cumulative_time_in_marketing_qualified_lead
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_OPPORTUNITY::int
        as property_hsv2_cumulative_time_in_opportunity
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_OTHER::int
        as property_hsv2_cumulative_time_in_other
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_SALESQUALIFIEDLEAD::int
        as property_hsv2_cumulative_time_in_sales_qualified_lead
    , json:PROPERTY_HS_V_2_CUMULATIVE_TIME_IN_SUBSCRIBER::int
        as property_hsv2_cumulative_time_in_subscriber
    , json:PROPERTY_HS_V_2_DATE_ENTERED_100081836::text                                   as property_hsv2dateentered100081836
    , json:PROPERTY_HS_V_2_DATE_ENTERED_72175726::text                                    as property_hsv2dateentered72175726
    , json:PROPERTY_HS_V_2_DATE_ENTERED_991095214::text                                   as property_hsv2dateentered991095214
    , json:PROPERTY_HS_V_2_DATE_ENTERED_991119752::text                                   as property_hsv2dateentered991119752
    , json:PROPERTY_HS_V_2_DATE_ENTERED_999965360::text                                   as property_hsv2dateentered999965360
    , json:PROPERTY_HS_V_2_DATE_ENTERED_CUSTOMER::text                                    as property_hsv2_date_entered_customer
    , json:PROPERTY_HS_V_2_DATE_ENTERED_LEAD::text                                        as property_hsv2_date_entered_lead
    , json:PROPERTY_HS_V_2_DATE_ENTERED_MARKETINGQUALIFIEDLEAD::text
        as property_hsv2_date_entered_marketing_qualified_lead
    , json:PROPERTY_HS_V_2_DATE_ENTERED_OPPORTUNITY::text
        as property_hsv2_date_entered_opportunity
    , json:PROPERTY_HS_V_2_DATE_ENTERED_OTHER::text                                       as property_hsv2_date_entered_other
    , json:PROPERTY_HS_V_2_DATE_ENTERED_SALESQUALIFIEDLEAD::text
        as property_hsv2_date_entered_sales_qualified_lead
    , json:PROPERTY_HS_V_2_DATE_ENTERED_SUBSCRIBER::text                                  as property_hsv2_date_entered_subscriber
    , json:PROPERTY_HS_V_2_DATE_EXITED_100081836::text                                    as property_hsv2dateexited100081836
    , json:PROPERTY_HS_V_2_DATE_EXITED_72175726::text                                     as property_hsv2dateexited72175726
    , json:PROPERTY_HS_V_2_DATE_EXITED_991095214::text                                    as property_hsv2dateexited991095214
    , json:PROPERTY_HS_V_2_DATE_EXITED_999965360::text                                    as property_hsv2dateexited999965360
    , json:PROPERTY_HS_V_2_DATE_EXITED_CUSTOMER::text                                     as property_hsv2_date_exited_customer
    , json:PROPERTY_HS_V_2_DATE_EXITED_LEAD::text                                         as property_hsv2_date_exited_lead
    , json:PROPERTY_HS_V_2_DATE_EXITED_MARKETINGQUALIFIEDLEAD::text
        as property_hsv2_date_exited_marketing_qualified_lead
    , json:PROPERTY_HS_V_2_DATE_EXITED_OPPORTUNITY::text                                  as property_hsv2_date_exited_opportunity
    , json:PROPERTY_HS_V_2_DATE_EXITED_OTHER::text                                        as property_hsv2_date_exited_other
    , json:PROPERTY_HS_V_2_DATE_EXITED_SALESQUALIFIEDLEAD::text
        as property_hsv2_date_exited_sales_qualified_lead
    , json:PROPERTY_HS_V_2_DATE_EXITED_SUBSCRIBER::text                                   as property_hsv2_date_exited_subscriber
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_100081836::int                                  as property_h_sv2latesttimein100081836
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_72175726::int                                   as property_hsv2latesttimein72175726
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_991095214::int                                  as property_h_sv2latesttimein991095214
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_999965360::int                                  as property_h_sv2latesttimein999965360
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_CUSTOMER::int                                   as property_hsv2_latest_time_in_customer
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_LEAD::int                                       as property_hsv2_latest_time_in_lead
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_MARKETINGQUALIFIEDLEAD::int
        as property_hsv2_latest_time_in_marketing_qualified_lead
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_OPPORTUNITY::int
        as property_hsv2_latest_time_in_opportunity
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_OTHER::int                                      as property_hsv2_latest_time_in_other
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_SALESQUALIFIEDLEAD::int
        as property_hsv2_latest_time_in_sales_qualified_lead
    , json:PROPERTY_HS_V_2_LATEST_TIME_IN_SUBSCRIBER::int
        as property_hsv2_latest_time_in_subscriber
    , try_to_boolean(json:PROPERTY_HS_WAS_IMPORTED::text)::int                          as property_hs_was_imported
    , json:PROPERTY_HUBSPOTSCORE::int                                                   as property_hub_spot_score
    , json:PROPERTY_HUBSPOT_OWNER_ASSIGNEDDATE::text                                    as property_hub_spot_owner_assigned_date
    , json:PROPERTY_HUBSPOT_OWNER_ID::int                                               as property_hub_spot_owner_id
    , json:PROPERTY_HUBSPOT_TEAM_ID::int                                                as property_hub_spot_team_id
    , json:PROPERTY_INDUSTRY::text                                                      as property_industry
    , json:PROPERTY_IP_CITY::text                                                       as property_ip_city
    , json:PROPERTY_IP_COUNTRY::text                                                    as property_ip_country
    , json:PROPERTY_IP_COUNTRY_CODE::text                                               as property_ip_country_code
    , json:PROPERTY_IP_STATE::text                                                      as property_ip_state
    , json:PROPERTY_IP_STATE_CODE::text                                                 as property_ip_state_code
    , json:PROPERTY_I_M_INTERESTED_IN_::text                                            as property_im_interested_in
    , json:PROPERTY_JOBTITLE::text                                                      as property_job_title
    , json:PROPERTY_JOB_FUNCTION::text                                                  as property_job_function
    , json:PROPERTY_JOINMARINER_PREFERENCE::text                                        as property_join_mariner_preference
    , json:PROPERTY_LASTMODIFIEDDATE::text                                              as property_last_modified_date
    , json:PROPERTY_LASTNAME::text                                                      as property_last_name
    , json:PROPERTY_LEADSOURCE::text                                                    as property_lead_source
    , json:PROPERTY_LEAD_SOURCE::text                                                   as property_lead_source
    , json:PROPERTY_LIFECYCLESTAGE::text                                                as property_lifecycle_stage
    , json:PROPERTY_MAILCHIMP_ENGAGEMENT_RATING::int
        as property_mail_chimp_engagement_rating
    , json:PROPERTY_MEETING_SCHEDULED::text                                             as property_meeting_scheduled
    , json:PROPERTY_MESSAGE::text                                                       as property_message
    , json:PROPERTY_MOBILEPHONE::text                                                   as property_mobile_phone
    , json:PROPERTY_MONETARY_VALUE_OF_ASSETS_MANAGED_IN_MILLIONS::text                  as property_monetary_value_of_assets_managed_in_millions
    , json:PROPERTY_NOTES_LAST_CONTACTED::text                                          as property_notes_last_contacted
    , json:PROPERTY_NOTES_LAST_UPDATED::text                                            as property_notes_last_updated
    , json:PROPERTY_NOTES_NEXT_ACTIVITY_DATE::text                                      as property_notes_next_activity_date
    , json:PROPERTY_NUMEMPLOYEES::text                                                  as property_num_employees
    , json:PROPERTY_NUM_CONTACTED_NOTES::int                                            as property_num_contacted_notes
    , json:PROPERTY_NUM_CONVERSION_EVENTS::int                                          as property_num_conversion_events
    , json:PROPERTY_NUM_NOTES::int                                                      as property_num_notes
    , json:PROPERTY_NUM_UNIQUE_CONVERSION_EVENTS::int                                   as property_num_unique_conversion_events
    , json:PROPERTY_PHONE::text                                                         as property_phone
    , json:PROPERTY_PROFESSIONAL_CERTIFICATIONS::text                                   as property_professional_certifications
    , json:PROPERTY_RATING::text                                                        as property_rating
    , json:PROPERTY_RECENT_CONVERSION_DATE::text                                        as property_recent_conversion_date
    , json:PROPERTY_RECENT_CONVERSION_EVENT_NAME::text                                  as property_recent_conversion_event_name
    , json:PROPERTY_SALESFORCEACCOUNTID::text                                           as property_sales_force_account_id
    , json:PROPERTY_SALESFORCECONTACTID::text                                           as property_sales_force_contact_id
    , try_to_boolean(json:PROPERTY_SALESFORCEDELETED::text)::int                        as property_sales_force_deleted
    , json:PROPERTY_SALESFORCELASTSYNCTIME::text                                        as property_sales_force_last_sync_time
    , json:PROPERTY_SALESFORCEOWNERID::text                                             as property_sales_force_owner_id
    , json:PROPERTY_SALUTATION::text                                                    as property_salutation
    , json:PROPERTY_SERVICES_PROVIDED::text                                             as property_services_provided
    , json:PROPERTY_STATE::text                                                         as property_state
    , json:PROPERTY_STATEFORM::text                                                     as property_state_form
    , json:PROPERTY_TAGS::text                                                          as property_tags
    , json:PROPERTY_TWITTERHANDLE::text                                                 as property_twitter_handle
    , json:PROPERTY_TWITTERPROFILEPHOTO::text                                           as property_twitter_profile_photo
    , json:PROPERTY_WEBSITE::text                                                       as property_website
    , json:PROPERTY_WHAT_SPECIFICALLY_ATTRACTED_YOU_TO_MARINER_::text                   as property_what_specifically_attracted_you_to_mariner
    , json:PROPERTY_WHAT_S_YOUR_PATH::text                                              as property_whats_your_path
    , json:PROPERTY_WHAT_S_YOUR_PATH_::text                                             as property_whats_your_path
    , json:PROPERTY_WHICH_OF_THE_FOLLOWING_BEST_DESCRIBES_YOUR_CURRENT_REGISTRATION_STATUS_::text
        as property_which_of_the_following_best_describes_your_current_registration_status
    , json:PROPERTY_WORK_EMAIL::text                                                    as property_work_email
    , json:PROPERTY_YEARS_OF_EXPERIENCE::text                                           as property_years_of_experience
    , json:PROPERTY_ZIP::text                                                           as property_zip
    , json:PROPERTY_ZOOM_WEBINAR_ATTENDANCE_AVERAGE_DURATION::int                       as property_zoom_webinar_attendance_average_duration
    , json:PROPERTY_ZOOM_WEBINAR_ATTENDANCE_COUNT::int                                  as property_zoom_webinar_attendance_count
    , json:PROPERTY_ZOOM_WEBINAR_JOINLINK::text                                         as property_zoom_webinar_join_link
    , json:PROPERTY_ZOOM_WEBINAR_REGISTRATION_COUNT::int                                as property_zoom_webinar_registration_count
    , try_to_boolean(json:PROPERTY_HS_WAS_IMPORTED::text)::int                          as property_hs_was_imported
    , effective_at::timestamp                                                           as effective_at
    , _created_at::timestamp                                                            as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'contact')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at) over (
                partition by effective_at::date
        ) then 1
    else 0 end                                                                          as is_latest
from {{ source('hubspot_advisor_recruiting', 'contact') }}
where effective_at is not null
