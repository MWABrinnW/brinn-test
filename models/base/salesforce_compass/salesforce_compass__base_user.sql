{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

select
    'salesforce'::text(200)                                                      as system_name
    , 'compass'::text(200)                                                       as system_instance
    , concat(system_name , '__' , system_instance)::text(200)                    as system_key
    , 'mwa'::text(200)                                                           as firm_source
    , json:ID::varchar(18)                                                       as id
    , json:USERNAME::varchar(240)                                                as username
    , json:LAST_NAME::varchar(240)                                               as last_name
    , json:FIRST_NAME::varchar(120)                                              as first_name
    , json:MIDDLE_NAME::varchar(120)                                             as middle_name
    , json:SUFFIX::varchar(120)                                                  as suffix
    , json:NAME::varchar(363)                                                    as name
    , json:COMPANY_NAME::varchar(240)                                            as company_name
    , json:DIVISION::varchar(240)                                                as division
    , json:DEPARTMENT::varchar(240)                                              as department
    , json:TITLE::varchar(240)                                                   as title
    , json:STREET::varchar(765)                                                  as street
    , json:CITY::varchar(120)                                                    as city
    , json:STATE::varchar(240)                                                   as state
    , json:POSTAL_CODE::varchar(60)                                              as postal_code
    , json:COUNTRY::varchar(240)                                                 as country
    , json:LATITUDE::double                                                      as latitude
    , json:LONGITUDE::double                                                     as longitude
    , json:GEOCODE_ACCURACY::varchar(120)                                        as geocode_accuracy
    , json:EMAIL::varchar(384)                                                   as email
    , json:EMAIL_PREFERENCES_AUTO_BCC::boolean                                   as email_preferences_auto_bcc
    , json:EMAIL_PREFERENCES_AUTO_BCC_STAY_IN_TOUCH::boolean                     as email_preferences_auto_bcc_stay_in_touch
    , json:EMAIL_PREFERENCES_STAY_IN_TOUCH_REMINDER::boolean                     as email_preferences_stay_in_touch_reminder
    , json:SENDER_EMAIL::varchar(240)                                            as sender_email
    , json:SENDER_NAME::varchar(240)                                             as sender_name
    , json:SIGNATURE::varchar(3999)                                              as signature
    , json:STAY_IN_TOUCH_SUBJECT::varchar(240)                                   as stay_in_touch_subject
    , json:STAY_IN_TOUCH_SIGNATURE::varchar(1536)                                as stay_in_touch_signature
    , json:STAY_IN_TOUCH_NOTE::varchar(1536)                                     as stay_in_touch_note
    , json:PHONE::varchar(120)                                                   as phone
    , json:FAX::varchar(120)                                                     as fax
    , json:MOBILE_PHONE::varchar(120)                                            as mobile_phone
    , json:ALIAS::varchar(24)                                                    as alias
    , json:COMMUNITY_NICKNAME::varchar(120)                                      as community_nickname
    , json:BADGE_TEXT::varchar(240)                                              as badge_text
    , json:IS_ACTIVE::boolean                                                    as is_active
    , json:TIME_ZONE_SID_KEY::varchar(120)                                       as time_zone_sid_key
    , json:USER_ROLE_ID::varchar(18)                                             as user_role_id
    , json:LOCALE_SID_KEY::varchar(120)                                          as locale_sid_key
    , json:RECEIVES_INFO_EMAILS::boolean                                         as receives_info_emails
    , json:RECEIVES_ADMIN_INFO_EMAILS::boolean                                   as receives_admin_info_emails
    , json:EMAIL_ENCODING_KEY::varchar(120)                                      as email_encoding_key
    , json:PROFILE_ID::varchar(18)                                               as profile_id
    , json:USER_TYPE::varchar(120)                                               as user_type
    , json:LANGUAGE_LOCALE_KEY::varchar(120)                                     as language_locale_key
    , json:EMPLOYEE_NUMBER::varchar(60)                                          as employee_number
    , json:DELEGATED_APPROVER_ID::varchar(18)                                    as delegated_approver_id
    , json:MANAGER_ID::varchar(18)                                               as manager_id
    , json:LAST_LOGIN_DATE::timestamptz                                          as last_login_date
    , json:CREATED_DATE::timestamptz                                             as created_date
    , json:CREATED_BY_ID::varchar(18)                                            as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                                       as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                                      as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                                          as system_modstamp
    , json:OFFLINE_TRIAL_EXPIRATION_DATE::timestamptz                            as offline_trial_expiration_date
    , json:OFFLINE_PDA_TRIAL_EXPIRATION_DATE::timestamptz                        as offline_pda_trial_expiration_date
    , json:USER_PERMISSIONS_MARKETING_USER::boolean                              as user_permissions_marketing_user
    , json:USER_PERMISSIONS_OFFLINE_USER::boolean                                as user_permissions_offline_user
    , json:USER_PERMISSIONS_AVANTGO_USER::boolean                                as user_permissions_avantgo_user
    , json:USER_PERMISSIONS_CALL_CENTER_AUTO_LOGIN::boolean                      as user_permissions_call_center_auto_login
    , json:USER_PERMISSIONS_SFCONTENT_USER::boolean                              as user_permissions_sfcontent_user
    , json:USER_PERMISSIONS_KNOWLEDGE_USER::boolean                              as user_permissions_knowledge_user
    , json:USER_PERMISSIONS_INTERACTION_USER::boolean                            as user_permissions_interaction_user
    , json:USER_PERMISSIONS_SUPPORT_USER::boolean                                as user_permissions_support_user
    , json:FORECAST_ENABLED::boolean                                             as forecast_enabled
    , json:USER_PREFERENCES_ACTIVITY_REMINDERS_POPUP::boolean                    as user_preferences_activity_reminders_popup
    , json:USER_PREFERENCES_EVENT_REMINDERS_CHECKBOX_DEFAULT::boolean
        as user_preferences_event_reminders_checkbox_default
    , json:USER_PREFERENCES_TASK_REMINDERS_CHECKBOX_DEFAULT::boolean
        as user_preferences_task_reminders_checkbox_default
    , json:USER_PREFERENCES_REMINDER_SOUND_OFF::boolean                          as user_preferences_reminder_sound_off
    , json:USER_PREFERENCES_DISABLE_ALL_FEEDS_EMAIL::boolean                     as user_preferences_disable_all_feeds_email
    , json:USER_PREFERENCES_DISABLE_FOLLOWERS_EMAIL::boolean                     as user_preferences_disable_followers_email
    , json:USER_PREFERENCES_DISABLE_PROFILE_POST_EMAIL::boolean                  as user_preferences_disable_profile_post_email
    , json:USER_PREFERENCES_DISABLE_CHANGE_COMMENT_EMAIL::boolean
        as user_preferences_disable_change_comment_email
    , json:USER_PREFERENCES_DISABLE_LATER_COMMENT_EMAIL::boolean                 as user_preferences_disable_later_comment_email
    , json:USER_PREFERENCES_DIS_PROF_POST_COMMENT_EMAIL::boolean                 as user_preferences_dis_prof_post_comment_email
    , json:USER_PREFERENCES_CONTENT_NO_EMAIL::boolean                            as user_preferences_content_no_email
    , json:USER_PREFERENCES_CONTENT_EMAIL_AS_AND_WHEN::boolean                   as user_preferences_content_email_as_and_when
    , json:USER_PREFERENCES_APEX_PAGES_DEVELOPER_MODE::boolean                   as user_preferences_apex_pages_developer_mode
    , json:USER_PREFERENCES_RECEIVE_NO_NOTIFICATIONS_AS_APPROVER::boolean
        as user_preferences_receive_no_notifications_as_approver
    , json:USER_PREFERENCES_RECEIVE_NOTIFICATIONS_AS_DELEGATED_APPROVER::boolean
        as user_preferences_receive_notifications_as_delegated_approver
    , json:USER_PREFERENCES_HIDE_CSNGET_CHATTER_MOBILE_TASK::boolean
        as user_preferences_hide_csnget_chatter_mobile_task
    , json:USER_PREFERENCES_DISABLE_MENTIONS_POST_EMAIL::boolean                 as user_preferences_disable_mentions_post_email
    , json:USER_PREFERENCES_DIS_MENTIONS_COMMENT_EMAIL::boolean                  as user_preferences_dis_mentions_comment_email
    , json:USER_PREFERENCES_HIDE_CSNDESKTOP_TASK::boolean                        as user_preferences_hide_csndesktop_task
    , json:USER_PREFERENCES_HIDE_CHATTER_ONBOARDING_SPLASH::boolean
        as user_preferences_hide_chatter_onboarding_splash
    , json:USER_PREFERENCES_HIDE_SECOND_CHATTER_ONBOARDING_SPLASH::boolean
        as user_preferences_hide_second_chatter_onboarding_splash
    , json:USER_PREFERENCES_DIS_COMMENT_AFTER_LIKE_EMAIL::boolean
        as user_preferences_dis_comment_after_like_email
    , json:USER_PREFERENCES_DISABLE_LIKE_EMAIL::boolean                          as user_preferences_disable_like_email
    , json:USER_PREFERENCES_SORT_FEED_BY_COMMENT::boolean                        as user_preferences_sort_feed_by_comment
    , json:USER_PREFERENCES_DISABLE_MESSAGE_EMAIL::boolean                       as user_preferences_disable_message_email
    , json:USER_PREFERENCES_DISABLE_BOOKMARK_EMAIL::boolean                      as user_preferences_disable_bookmark_email
    , json:USER_PREFERENCES_DISABLE_SHARE_POST_EMAIL::boolean                    as user_preferences_disable_share_post_email
    , json:USER_PREFERENCES_ENABLE_AUTO_SUB_FOR_FEEDS::boolean                   as user_preferences_enable_auto_sub_for_feeds
    , json:USER_PREFERENCES_DISABLE_FILE_SHARE_NOTIFICATIONS_FOR_API::boolean
        as user_preferences_disable_file_share_notifications_for_api
    , json:USER_PREFERENCES_SHOW_TITLE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_title_to_external_users
    , json:USER_PREFERENCES_SHOW_MANAGER_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_manager_to_external_users
    , json:USER_PREFERENCES_SHOW_EMAIL_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_email_to_external_users
    , json:USER_PREFERENCES_SHOW_WORK_PHONE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_work_phone_to_external_users
    , json:USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_mobile_phone_to_external_users
    , json:USER_PREFERENCES_SHOW_FAX_TO_EXTERNAL_USERS::boolean                  as user_preferences_show_fax_to_external_users
    , json:USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_street_address_to_external_users
    , json:USER_PREFERENCES_SHOW_CITY_TO_EXTERNAL_USERS::boolean                 as user_preferences_show_city_to_external_users
    , json:USER_PREFERENCES_SHOW_STATE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_state_to_external_users
    , json:USER_PREFERENCES_SHOW_POSTAL_CODE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_postal_code_to_external_users
    , json:USER_PREFERENCES_SHOW_COUNTRY_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_country_to_external_users
    , json:USER_PREFERENCES_SHOW_PROFILE_PIC_TO_GUEST_USERS::boolean
        as user_preferences_show_profile_pic_to_guest_users
    , json:USER_PREFERENCES_SHOW_TITLE_TO_GUEST_USERS::boolean                   as user_preferences_show_title_to_guest_users
    , json:USER_PREFERENCES_SHOW_CITY_TO_GUEST_USERS::boolean                    as user_preferences_show_city_to_guest_users
    , json:USER_PREFERENCES_SHOW_STATE_TO_GUEST_USERS::boolean                   as user_preferences_show_state_to_guest_users
    , json:USER_PREFERENCES_SHOW_POSTAL_CODE_TO_GUEST_USERS::boolean
        as user_preferences_show_postal_code_to_guest_users
    , json:USER_PREFERENCES_SHOW_COUNTRY_TO_GUEST_USERS::boolean                 as user_preferences_show_country_to_guest_users
    , json:USER_PREFERENCES_HIDE_S_1_BROWSER_UI::boolean                         as user_preferences_hide_s_1_browser_ui
    , json:USER_PREFERENCES_DISABLE_ENDORSEMENT_EMAIL::boolean                   as user_preferences_disable_endorsement_email
    , json:USER_PREFERENCES_PATH_ASSISTANT_COLLAPSED::boolean                    as user_preferences_path_assistant_collapsed
    , json:USER_PREFERENCES_CACHE_DIAGNOSTICS::boolean                           as user_preferences_cache_diagnostics
    , json:USER_PREFERENCES_SHOW_EMAIL_TO_GUEST_USERS::boolean                   as user_preferences_show_email_to_guest_users
    , json:USER_PREFERENCES_SHOW_MANAGER_TO_GUEST_USERS::boolean                 as user_preferences_show_manager_to_guest_users
    , json:USER_PREFERENCES_SHOW_WORK_PHONE_TO_GUEST_USERS::boolean
        as user_preferences_show_work_phone_to_guest_users
    , json:USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_GUEST_USERS::boolean
        as user_preferences_show_mobile_phone_to_guest_users
    , json:USER_PREFERENCES_SHOW_FAX_TO_GUEST_USERS::boolean                     as user_preferences_show_fax_to_guest_users
    , json:USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_GUEST_USERS::boolean
        as user_preferences_show_street_address_to_guest_users
    , json:USER_PREFERENCES_LIGHTNING_EXPERIENCE_PREFERRED::boolean
        as user_preferences_lightning_experience_preferred
    , json:USER_PREFERENCES_HIDE_END_USER_ONBOARDING_ASSISTANT_MODAL::boolean
        as user_preferences_hide_end_user_onboarding_assistant_modal
    , json:USER_PREFERENCES_HIDE_LIGHTNING_MIGRATION_MODAL::boolean
        as user_preferences_hide_lightning_migration_modal
    , json:USER_PREFERENCES_HIDE_SFX_WELCOME_MAT::boolean                        as user_preferences_hide_sfx_welcome_mat
    , json:USER_PREFERENCES_HIDE_BIGGER_PHOTO_CALLOUT::boolean                   as user_preferences_hide_bigger_photo_callout
    , json:USER_PREFERENCES_GLOBAL_NAV_BAR_WTSHOWN::boolean                      as user_preferences_global_nav_bar_wtshown
    , json:USER_PREFERENCES_GLOBAL_NAV_GRID_MENU_WTSHOWN::boolean
        as user_preferences_global_nav_grid_menu_wtshown
    , json:USER_PREFERENCES_CREATE_LEXAPPS_WTSHOWN::boolean                      as user_preferences_create_lexapps_wtshown
    , json:USER_PREFERENCES_FAVORITES_WTSHOWN::boolean                           as user_preferences_favorites_wtshown
    , json:USER_PREFERENCES_RECORD_HOME_SECTION_COLLAPSE_WTSHOWN::boolean
        as user_preferences_record_home_section_collapse_wtshown
    , json:USER_PREFERENCES_RECORD_HOME_RESERVED_WTSHOWN::boolean
        as user_preferences_record_home_reserved_wtshown
    , json:USER_PREFERENCES_FAVORITES_SHOW_TOP_FAVORITES::boolean
        as user_preferences_favorites_show_top_favorites
    , json:USER_PREFERENCES_EXCLUDE_MAIL_APP_ATTACHMENTS::boolean
        as user_preferences_exclude_mail_app_attachments
    , json:USER_PREFERENCES_SUPPRESS_TASK_SFXREMINDERS::boolean                  as user_preferences_suppress_task_sfxreminders
    , json:USER_PREFERENCES_SUPPRESS_EVENT_SFXREMINDERS::boolean                 as user_preferences_suppress_event_sfxreminders
    , json:USER_PREFERENCES_PREVIEW_CUSTOM_THEME::boolean                        as user_preferences_preview_custom_theme
    , json:USER_PREFERENCES_HAS_CELEBRATION_BADGE::boolean                       as user_preferences_has_celebration_badge
    , json:USER_PREFERENCES_USER_DEBUG_MODE_PREF::boolean                        as user_preferences_user_debug_mode_pref
    , json:USER_PREFERENCES_SRHOVERRIDE_ACTIVITIES::boolean                      as user_preferences_srhoverride_activities
    , json:USER_PREFERENCES_NEW_LIGHTNING_REPORT_RUN_PAGE_ENABLED::boolean
        as user_preferences_new_lightning_report_run_page_enabled
    , json:CONTACT_ID::varchar(18)                                               as contact_id
    , json:ACCOUNT_ID::varchar(18)                                               as account_id
    , json:CALL_CENTER_ID::varchar(18)                                           as call_center_id
    , json:EXTENSION::varchar(120)                                               as extension
    , json:FEDERATION_IDENTIFIER::varchar(1536)                                  as federation_identifier
    , json:ABOUT_ME::varchar(3000)                                               as about_me
    , json:FULL_PHOTO_URL::varchar(3072)                                         as full_photo_url
    , json:SMALL_PHOTO_URL::varchar(3072)                                        as small_photo_url
    , json:IS_EXT_INDICATOR_VISIBLE::boolean                                     as is_ext_indicator_visible
    , json:OUT_OF_OFFICE_MESSAGE::varchar(120)                                   as out_of_office_message
    , json:MEDIUM_PHOTO_URL::varchar(3072)                                       as medium_photo_url
    , json:DIGEST_FREQUENCY::varchar(120)                                        as digest_frequency
    , json:DEFAULT_GROUP_NOTIFICATION_FREQUENCY::varchar(120)                    as default_group_notification_frequency
    , json:LAST_VIEWED_DATE::timestamptz                                         as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                                     as last_referenced_date
    , json:BANNER_PHOTO_URL::varchar(3072)                                       as banner_photo_url
    , json:SMALL_BANNER_PHOTO_URL::varchar(3072)                                 as small_banner_photo_url
    , json:MEDIUM_BANNER_PHOTO_URL::varchar(3072)                                as medium_banner_photo_url
    , json:IS_PROFILE_PHOTO_ACTIVE::boolean                                      as is_profile_photo_active
    , json:PARTNER_FIRM_C::varchar(765)                                          as partner_firm_c
    , json:BUSINESS_LINE_C::varchar(765)                                         as business_line_c
    , json:MARINER_LOCATION_SECONDARY_C::varchar(765)                            as mariner_location_secondary_c
    , json:MARINER_LOCATION_C::varchar(765)                                      as mariner_location_c
    , json:SYS_MIGRATION_SOURCE_C::varchar(4099)                                 as sys_migration_source_c
    , json:SYS_MIGRATION_ID_C::varchar(765)                                      as sys_migration_id_c
    , json:_FIVETRAN_SYNCED::timestamptz                                         as _fivetran_synced
    , json:_FIVETRAN_DELETED::boolean                                            as _fivetran_deleted
    , json:ALLOW_THESE_INTRODUCTIONS_C::varchar(4099)                            as allow_these_introductions_c
    , json:USER_PREFERENCES_HIDE_STATEMENTS_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_statements_redirect_confirmation
    , json:USER_PREFERENCES_HIDE_INVOICES_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_invoices_redirect_confirmation
    , json:USER_PREFERENCES_HIDE_BROWSE_PRODUCT_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_browse_product_redirect_confirmation
    , json:USER_PREFERENCES_HIDE_ONLINE_SALES_APP_WELCOME_MAT::boolean
        as user_preferences_hide_online_sales_app_welcome_mat
    , json:USER_PREFERENCES_REVERSE_OPEN_ACTIVITIES_VIEW::boolean
        as user_preferences_reverse_open_activities_view
    , json:USER_PREFERENCES_SHOW_FORECASTING_CHANGE_SIGNALS::boolean
        as user_preferences_show_forecasting_change_signals
    , json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL::boolean                      as user_preferences_has_sent_warning_email
    , json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_238::boolean                  as user_preferences_has_sent_warning_email_238
    , json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_240::boolean                  as user_preferences_has_sent_warning_email_240

    , effective_at::timestamp                                                    as effective_at
    , _created_at::timestamp                                                     as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'user')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                                          as is_latest
from {{ source('salesforce_compass', 'user') }}
