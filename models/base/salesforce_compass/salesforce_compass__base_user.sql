{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

with cte_user as (
    select
        effective_at::date                                                              as effective_at
        , _created_at
        , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'user') }}
    group by 1 , 2
)

select
    'salesforce'::text(200)                                                        as system_name
    , 'compass'::text(200)                                                         as system_instance
    , concat(system_name , '__' , system_instance)::text(200)                      as system_key
    , 'mwa'::text(200)                                                             as firm_source
    , a.json:ID::varchar(18)                                                       as id
    , a.json:USERNAME::varchar(240)                                                as username
    , a.json:LAST_NAME::varchar(240)                                               as last_name
    , a.json:FIRST_NAME::varchar(120)                                              as first_name
    , a.json:MIDDLE_NAME::varchar(120)                                             as middle_name
    , a.json:SUFFIX::varchar(120)                                                  as suffix
    , a.json:NAME::varchar(363)                                                    as name
    , a.json:COMPANY_NAME::varchar(240)                                            as company_name
    , a.json:DIVISION::varchar(240)                                                as division
    , a.json:DEPARTMENT::varchar(240)                                              as department
    , a.json:TITLE::varchar(240)                                                   as title
    , a.json:STREET::varchar(765)                                                  as street
    , a.json:CITY::varchar(120)                                                    as city
    , a.json:STATE::varchar(240)                                                   as state
    , a.json:POSTAL_CODE::varchar(60)                                              as postal_code
    , a.json:COUNTRY::varchar(240)                                                 as country
    , a.json:LATITUDE::double                                                      as latitude
    , a.json:LONGITUDE::double                                                     as longitude
    , a.json:GEOCODE_ACCURACY::varchar(120)                                        as geocode_accuracy
    , a.json:EMAIL::varchar(384)                                                   as email
    , a.json:EMAIL_PREFERENCES_AUTO_BCC::boolean                                   as email_preferences_auto_bcc
    , a.json:EMAIL_PREFERENCES_AUTO_BCC_STAY_IN_TOUCH::boolean                     as email_preferences_auto_bcc_stay_in_touch
    , a.json:EMAIL_PREFERENCES_STAY_IN_TOUCH_REMINDER::boolean                     as email_preferences_stay_in_touch_reminder
    , a.json:SENDER_EMAIL::varchar(240)                                            as sender_email
    , a.json:SENDER_NAME::varchar(240)                                             as sender_name
    , a.json:SIGNATURE::varchar(3999)                                              as signature
    , a.json:STAY_IN_TOUCH_SUBJECT::varchar(240)                                   as stay_in_touch_subject
    , a.json:STAY_IN_TOUCH_SIGNATURE::varchar(1536)                                as stay_in_touch_signature
    , a.json:STAY_IN_TOUCH_NOTE::varchar(1536)                                     as stay_in_touch_note
    , a.json:PHONE::varchar(120)                                                   as phone
    , a.json:FAX::varchar(120)                                                     as fax
    , a.json:MOBILE_PHONE::varchar(120)                                            as mobile_phone
    , a.json:ALIAS::varchar(24)                                                    as alias
    , a.json:COMMUNITY_NICKNAME::varchar(120)                                      as community_nickname
    , a.json:BADGE_TEXT::varchar(240)                                              as badge_text
    , a.json:IS_ACTIVE::boolean                                                    as is_active
    , a.json:TIME_ZONE_SID_KEY::varchar(120)                                       as time_zone_sid_key
    , a.json:USER_ROLE_ID::varchar(18)                                             as user_role_id
    , a.json:LOCALE_SID_KEY::varchar(120)                                          as locale_sid_key
    , a.json:RECEIVES_INFO_EMAILS::boolean                                         as receives_info_emails
    , a.json:RECEIVES_ADMIN_INFO_EMAILS::boolean                                   as receives_admin_info_emails
    , a.json:EMAIL_ENCODING_KEY::varchar(120)                                      as email_encoding_key
    , a.json:PROFILE_ID::varchar(18)                                               as profile_id
    , a.json:USER_TYPE::varchar(120)                                               as user_type
    , a.json:LANGUAGE_LOCALE_KEY::varchar(120)                                     as language_locale_key
    , a.json:EMPLOYEE_NUMBER::varchar(60)                                          as employee_number
    , a.json:DELEGATED_APPROVER_ID::varchar(18)                                    as delegated_approver_id
    , a.json:MANAGER_ID::varchar(18)                                               as manager_id
    , a.json:LAST_LOGIN_DATE::timestamptz                                          as last_login_date
    , a.json:CREATED_DATE::timestamptz                                             as created_date
    , a.json:CREATED_BY_ID::varchar(18)                                            as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                                       as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                                      as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                                          as system_modstamp
    , a.json:OFFLINE_TRIAL_EXPIRATION_DATE::timestamptz                            as offline_trial_expiration_date
    , a.json:OFFLINE_PDA_TRIAL_EXPIRATION_DATE::timestamptz                        as offline_pda_trial_expiration_date
    , a.json:USER_PERMISSIONS_MARKETING_USER::boolean                              as user_permissions_marketing_user
    , a.json:USER_PERMISSIONS_OFFLINE_USER::boolean                                as user_permissions_offline_user
    , a.json:USER_PERMISSIONS_AVANTGO_USER::boolean                                as user_permissions_avantgo_user
    , a.json:USER_PERMISSIONS_CALL_CENTER_AUTO_LOGIN::boolean                      as user_permissions_call_center_auto_login
    , a.json:USER_PERMISSIONS_SFCONTENT_USER::boolean                              as user_permissions_sfcontent_user
    , a.json:USER_PERMISSIONS_KNOWLEDGE_USER::boolean                              as user_permissions_knowledge_user
    , a.json:USER_PERMISSIONS_INTERACTION_USER::boolean                            as user_permissions_interaction_user
    , a.json:USER_PERMISSIONS_SUPPORT_USER::boolean                                as user_permissions_support_user
    , a.json:FORECAST_ENABLED::boolean                                             as forecast_enabled
    , a.json:USER_PREFERENCES_ACTIVITY_REMINDERS_POPUP::boolean                    as user_preferences_activity_reminders_popup
    , a.json:USER_PREFERENCES_EVENT_REMINDERS_CHECKBOX_DEFAULT::boolean
        as user_preferences_event_reminders_checkbox_default
    , a.json:USER_PREFERENCES_TASK_REMINDERS_CHECKBOX_DEFAULT::boolean
        as user_preferences_task_reminders_checkbox_default
    , a.json:USER_PREFERENCES_REMINDER_SOUND_OFF::boolean                          as user_preferences_reminder_sound_off
    , a.json:USER_PREFERENCES_DISABLE_ALL_FEEDS_EMAIL::boolean                     as user_preferences_disable_all_feeds_email
    , a.json:USER_PREFERENCES_DISABLE_FOLLOWERS_EMAIL::boolean                     as user_preferences_disable_followers_email
    , a.json:USER_PREFERENCES_DISABLE_PROFILE_POST_EMAIL::boolean                  as user_preferences_disable_profile_post_email
    , a.json:USER_PREFERENCES_DISABLE_CHANGE_COMMENT_EMAIL::boolean
        as user_preferences_disable_change_comment_email
    , a.json:USER_PREFERENCES_DISABLE_LATER_COMMENT_EMAIL::boolean                 as user_preferences_disable_later_comment_email
    , a.json:USER_PREFERENCES_DIS_PROF_POST_COMMENT_EMAIL::boolean                 as user_preferences_dis_prof_post_comment_email
    , a.json:USER_PREFERENCES_CONTENT_NO_EMAIL::boolean                            as user_preferences_content_no_email
    , a.json:USER_PREFERENCES_CONTENT_EMAIL_AS_AND_WHEN::boolean                   as user_preferences_content_email_as_and_when
    , a.json:USER_PREFERENCES_APEX_PAGES_DEVELOPER_MODE::boolean                   as user_preferences_apex_pages_developer_mode
    , a.json:USER_PREFERENCES_RECEIVE_NO_NOTIFICATIONS_AS_APPROVER::boolean
        as user_preferences_receive_no_notifications_as_approver
    , a.json:USER_PREFERENCES_RECEIVE_NOTIFICATIONS_AS_DELEGATED_APPROVER::boolean
        as user_preferences_receive_notifications_as_delegated_approver
    , a.json:USER_PREFERENCES_HIDE_CSNGET_CHATTER_MOBILE_TASK::boolean
        as user_preferences_hide_csnget_chatter_mobile_task
    , a.json:USER_PREFERENCES_DISABLE_MENTIONS_POST_EMAIL::boolean                 as user_preferences_disable_mentions_post_email
    , a.json:USER_PREFERENCES_DIS_MENTIONS_COMMENT_EMAIL::boolean                  as user_preferences_dis_mentions_comment_email
    , a.json:USER_PREFERENCES_HIDE_CSNDESKTOP_TASK::boolean                        as user_preferences_hide_csndesktop_task
    , a.json:USER_PREFERENCES_HIDE_CHATTER_ONBOARDING_SPLASH::boolean
        as user_preferences_hide_chatter_onboarding_splash
    , a.json:USER_PREFERENCES_HIDE_SECOND_CHATTER_ONBOARDING_SPLASH::boolean
        as user_preferences_hide_second_chatter_onboarding_splash
    , a.json:USER_PREFERENCES_DIS_COMMENT_AFTER_LIKE_EMAIL::boolean
        as user_preferences_dis_comment_after_like_email
    , a.json:USER_PREFERENCES_DISABLE_LIKE_EMAIL::boolean                          as user_preferences_disable_like_email
    , a.json:USER_PREFERENCES_SORT_FEED_BY_COMMENT::boolean                        as user_preferences_sort_feed_by_comment
    , a.json:USER_PREFERENCES_DISABLE_MESSAGE_EMAIL::boolean                       as user_preferences_disable_message_email
    , a.json:USER_PREFERENCES_DISABLE_BOOKMARK_EMAIL::boolean                      as user_preferences_disable_bookmark_email
    , a.json:USER_PREFERENCES_DISABLE_SHARE_POST_EMAIL::boolean                    as user_preferences_disable_share_post_email
    , a.json:USER_PREFERENCES_ENABLE_AUTO_SUB_FOR_FEEDS::boolean                   as user_preferences_enable_auto_sub_for_feeds
    , a.json:USER_PREFERENCES_DISABLE_FILE_SHARE_NOTIFICATIONS_FOR_API::boolean
        as user_preferences_disable_file_share_notifications_for_api
    , a.json:USER_PREFERENCES_SHOW_TITLE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_title_to_external_users
    , a.json:USER_PREFERENCES_SHOW_MANAGER_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_manager_to_external_users
    , a.json:USER_PREFERENCES_SHOW_EMAIL_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_email_to_external_users
    , a.json:USER_PREFERENCES_SHOW_WORK_PHONE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_work_phone_to_external_users
    , a.json:USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_mobile_phone_to_external_users
    , a.json:USER_PREFERENCES_SHOW_FAX_TO_EXTERNAL_USERS::boolean                  as user_preferences_show_fax_to_external_users
    , a.json:USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_street_address_to_external_users
    , a.json:USER_PREFERENCES_SHOW_CITY_TO_EXTERNAL_USERS::boolean                 as user_preferences_show_city_to_external_users
    , a.json:USER_PREFERENCES_SHOW_STATE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_state_to_external_users
    , a.json:USER_PREFERENCES_SHOW_POSTAL_CODE_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_postal_code_to_external_users
    , a.json:USER_PREFERENCES_SHOW_COUNTRY_TO_EXTERNAL_USERS::boolean
        as user_preferences_show_country_to_external_users
    , a.json:USER_PREFERENCES_SHOW_PROFILE_PIC_TO_GUEST_USERS::boolean
        as user_preferences_show_profile_pic_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_TITLE_TO_GUEST_USERS::boolean                   as user_preferences_show_title_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_CITY_TO_GUEST_USERS::boolean                    as user_preferences_show_city_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_STATE_TO_GUEST_USERS::boolean                   as user_preferences_show_state_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_POSTAL_CODE_TO_GUEST_USERS::boolean
        as user_preferences_show_postal_code_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_COUNTRY_TO_GUEST_USERS::boolean                 as user_preferences_show_country_to_guest_users
    , a.json:USER_PREFERENCES_HIDE_S_1_BROWSER_UI::boolean                         as user_preferences_hide_s_1_browser_ui
    , a.json:USER_PREFERENCES_DISABLE_ENDORSEMENT_EMAIL::boolean                   as user_preferences_disable_endorsement_email
    , a.json:USER_PREFERENCES_PATH_ASSISTANT_COLLAPSED::boolean                    as user_preferences_path_assistant_collapsed
    , a.json:USER_PREFERENCES_CACHE_DIAGNOSTICS::boolean                           as user_preferences_cache_diagnostics
    , a.json:USER_PREFERENCES_SHOW_EMAIL_TO_GUEST_USERS::boolean                   as user_preferences_show_email_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_MANAGER_TO_GUEST_USERS::boolean                 as user_preferences_show_manager_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_WORK_PHONE_TO_GUEST_USERS::boolean
        as user_preferences_show_work_phone_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_GUEST_USERS::boolean
        as user_preferences_show_mobile_phone_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_FAX_TO_GUEST_USERS::boolean                     as user_preferences_show_fax_to_guest_users
    , a.json:USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_GUEST_USERS::boolean
        as user_preferences_show_street_address_to_guest_users
    , a.json:USER_PREFERENCES_LIGHTNING_EXPERIENCE_PREFERRED::boolean
        as user_preferences_lightning_experience_preferred
    , a.json:USER_PREFERENCES_HIDE_END_USER_ONBOARDING_ASSISTANT_MODAL::boolean
        as user_preferences_hide_end_user_onboarding_assistant_modal
    , a.json:USER_PREFERENCES_HIDE_LIGHTNING_MIGRATION_MODAL::boolean
        as user_preferences_hide_lightning_migration_modal
    , a.json:USER_PREFERENCES_HIDE_SFX_WELCOME_MAT::boolean                        as user_preferences_hide_sfx_welcome_mat
    , a.json:USER_PREFERENCES_HIDE_BIGGER_PHOTO_CALLOUT::boolean                   as user_preferences_hide_bigger_photo_callout
    , a.json:USER_PREFERENCES_GLOBAL_NAV_BAR_WTSHOWN::boolean                      as user_preferences_global_nav_bar_wtshown
    , a.json:USER_PREFERENCES_GLOBAL_NAV_GRID_MENU_WTSHOWN::boolean
        as user_preferences_global_nav_grid_menu_wtshown
    , a.json:USER_PREFERENCES_CREATE_LEXAPPS_WTSHOWN::boolean                      as user_preferences_create_lexapps_wtshown
    , a.json:USER_PREFERENCES_FAVORITES_WTSHOWN::boolean                           as user_preferences_favorites_wtshown
    , a.json:USER_PREFERENCES_RECORD_HOME_SECTION_COLLAPSE_WTSHOWN::boolean
        as user_preferences_record_home_section_collapse_wtshown
    , a.json:USER_PREFERENCES_RECORD_HOME_RESERVED_WTSHOWN::boolean
        as user_preferences_record_home_reserved_wtshown
    , a.json:USER_PREFERENCES_FAVORITES_SHOW_TOP_FAVORITES::boolean
        as user_preferences_favorites_show_top_favorites
    , a.json:USER_PREFERENCES_EXCLUDE_MAIL_APP_ATTACHMENTS::boolean
        as user_preferences_exclude_mail_app_attachments
    , a.json:USER_PREFERENCES_SUPPRESS_TASK_SFXREMINDERS::boolean                  as user_preferences_suppress_task_sfxreminders
    , a.json:USER_PREFERENCES_SUPPRESS_EVENT_SFXREMINDERS::boolean                 as user_preferences_suppress_event_sfxreminders
    , a.json:USER_PREFERENCES_PREVIEW_CUSTOM_THEME::boolean                        as user_preferences_preview_custom_theme
    , a.json:USER_PREFERENCES_HAS_CELEBRATION_BADGE::boolean                       as user_preferences_has_celebration_badge
    , a.json:USER_PREFERENCES_USER_DEBUG_MODE_PREF::boolean                        as user_preferences_user_debug_mode_pref
    , a.json:USER_PREFERENCES_SRHOVERRIDE_ACTIVITIES::boolean                      as user_preferences_srhoverride_activities
    , a.json:USER_PREFERENCES_NEW_LIGHTNING_REPORT_RUN_PAGE_ENABLED::boolean
        as user_preferences_new_lightning_report_run_page_enabled
    , a.json:CONTACT_ID::varchar(18)                                               as contact_id
    , a.json:ACCOUNT_ID::varchar(18)                                               as account_id
    , a.json:CALL_CENTER_ID::varchar(18)                                           as call_center_id
    , a.json:EXTENSION::varchar(120)                                               as extension
    , a.json:FEDERATION_IDENTIFIER::varchar(1536)                                  as federation_identifier
    , a.json:ABOUT_ME::varchar(3000)                                               as about_me
    , a.json:FULL_PHOTO_URL::varchar(3072)                                         as full_photo_url
    , a.json:SMALL_PHOTO_URL::varchar(3072)                                        as small_photo_url
    , a.json:IS_EXT_INDICATOR_VISIBLE::boolean                                     as is_ext_indicator_visible
    , a.json:OUT_OF_OFFICE_MESSAGE::varchar(120)                                   as out_of_office_message
    , a.json:MEDIUM_PHOTO_URL::varchar(3072)                                       as medium_photo_url
    , a.json:DIGEST_FREQUENCY::varchar(120)                                        as digest_frequency
    , a.json:DEFAULT_GROUP_NOTIFICATION_FREQUENCY::varchar(120)                    as default_group_notification_frequency
    , a.json:LAST_VIEWED_DATE::timestamptz                                         as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                                     as last_referenced_date
    , a.json:BANNER_PHOTO_URL::varchar(3072)                                       as banner_photo_url
    , a.json:SMALL_BANNER_PHOTO_URL::varchar(3072)                                 as small_banner_photo_url
    , a.json:MEDIUM_BANNER_PHOTO_URL::varchar(3072)                                as medium_banner_photo_url
    , a.json:IS_PROFILE_PHOTO_ACTIVE::boolean                                      as is_profile_photo_active
    , a.json:PARTNER_FIRM_C::varchar(765)                                          as partner_firm_c
    , a.json:BUSINESS_LINE_C::varchar(765)                                         as business_line_c
    , a.json:MARINER_LOCATION_SECONDARY_C::varchar(765)                            as mariner_location_secondary_c
    , a.json:MARINER_LOCATION_C::varchar(765)                                      as mariner_location_c
    , a.json:SYS_MIGRATION_SOURCE_C::varchar(4099)                                 as sys_migration_source_c
    , a.json:SYS_MIGRATION_ID_C::varchar(765)                                      as sys_migration_id_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                                         as _fivetran_synced
    , a.json:_FIVETRAN_DELETED::boolean                                            as _fivetran_deleted
    , a.json:ALLOW_THESE_INTRODUCTIONS_C::varchar(4099)                            as allow_these_introductions_c
    , a.json:USER_PREFERENCES_HIDE_STATEMENTS_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_statements_redirect_confirmation
    , a.json:USER_PREFERENCES_HIDE_INVOICES_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_invoices_redirect_confirmation
    , a.json:USER_PREFERENCES_HIDE_BROWSE_PRODUCT_REDIRECT_CONFIRMATION::boolean
        as user_preferences_hide_browse_product_redirect_confirmation
    , a.json:USER_PREFERENCES_HIDE_ONLINE_SALES_APP_WELCOME_MAT::boolean
        as user_preferences_hide_online_sales_app_welcome_mat
    , a.json:USER_PREFERENCES_REVERSE_OPEN_ACTIVITIES_VIEW::boolean
        as user_preferences_reverse_open_activities_view
    , a.json:USER_PREFERENCES_SHOW_FORECASTING_CHANGE_SIGNALS::boolean
        as user_preferences_show_forecasting_change_signals
    , a.json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL::boolean                      as user_preferences_has_sent_warning_email
    , a.json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_238::boolean                  as user_preferences_has_sent_warning_email_238
    , a.json:USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_240::boolean                  as user_preferences_has_sent_warning_email_240

    , a.effective_at::timestamp                                                    as effective_at
    , a._created_at::timestamp                                                     as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'user'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , case when b.rn = 1 then 1 else 0 end                                         as is_latest
from {{ source('salesforce_compass', 'user') }} as a
left join cte_user as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
