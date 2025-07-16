{% set src = source('salesforce_adviceperiod', 'user') %}
select
    json:"ABOUT_ME"::text                                                                                        as about_me
    , json:"ALIAS"::text                                                                                         as alias
    , json:"BADGE_TEXT"::text                                                                                    as badge_text
    , json:"BANNER_PHOTO_URL"::text
        as banner_photo_url
    , json:"CITY"::text                                                                                          as city
    , json:"COMMUNITY_NICKNAME"::text
        as community_nickname
    , json:"COMPANY_NAME"::text                                                                                  as company_name
    , json:"COUNTRY"::text                                                                                       as country
    , json:"COUNTRY_CODE"::text                                                                                  as country_code
    , json:"CREATED_BY_ID"::text                                                                                 as created_by_id
    , json:"CREATED_DATE"::text                                                                                  as created_date
    , try_to_boolean(json:"DA_SCOOP_COMPOSER_IS_UNRESOLVED_ITEMS_AGENT_C"::text)::int
        as da_scoop_composer_is_unresolved_items_agent_c
    , json:"DA_SCOOP_COMPOSER_PROFILE_ID_C"::text
        as da_scoop_composer_profile_id_c
    , json:"DEFAULT_GROUP_NOTIFICATION_FREQUENCY"::text
        as default_group_notification_frequency
    , json:"DELEGATED_APPROVER_ID"::text
        as delegated_approver_id
    , json:"DEPARTMENT"::text                                                                                    as department
    , json:"DIGEST_FREQUENCY"::text
        as digest_frequency
    , json:"DIVISION"::text                                                                                      as division
    , try_to_boolean(json:"DUPCHECK_DC_3_DISABLE_DUPLICATE_CHECK_C"::text)::int
        as dupcheckdc3_disable_duplicate_check_c
    , json:"EMAIL"::text                                                                                         as email
    , json:"EMAIL_ENCODING_KEY"::text
        as email_encoding_key
    , try_to_boolean(json:"EMAIL_PREFERENCES_AUTO_BCC"::text)::int
        as email_preferences_auto_bcc
    , try_to_boolean(json:"EMAIL_PREFERENCES_AUTO_BCC_STAY_IN_TOUCH"::text)::int
        as email_preferences_auto_bcc_stay_in_touch
    , try_to_boolean(json:"EMAIL_PREFERENCES_STAY_IN_TOUCH_REMINDER"::text)::int
        as email_preferences_stay_in_touch_reminder
    , json:"END_DAY"::int                                                                                        as end_day
    , json:"FIDELITY_ABP_C"::text                                                                                as fidelity_abp_c
    , json:"FIDELITY_ABP_PRIMARY_C"::text
        as fidelity_abp_primary_c
    , json:"FIDELITY_ADVISOR_G_C"::text
        as fidelity_advisor_gc
    , json:"FIDELITY_BD_C"::text                                                                                 as fidelity_bd_c
    , json:"FIDELITY_MPS_BD_C"::text
        as fidelity_mp_sbdc
    , json:"FIDELITY_ORION_C"::text
        as fidelity_orion_c
    , json:"FIDELITY_TBP_C"::text                                                                                as fidelity_tbp_c
    , json:"FIDELITY_TBP_PRIMARY_C"::text
        as fidelity_tbp_primary_c
    , json:"FIRST_NAME"::text                                                                                    as first_name
    , try_to_boolean(json:"FORECAST_ENABLED"::text)::int
        as forecast_enabled
    , json:"FSTR_DOCUMENT_MERGE_URL_C"::text
        as f_str_document_merge_url_c
    , try_to_boolean(json:"FSTR_IGNORE_PCE_DEFINITION_INITIATORS_C"::text)::int
        as f_str_ignore_pce_definition_initiators_c
    , try_to_boolean(json:"FSTR_NOTIFY_ON_ASSIGNMENT_C"::text)::int
        as f_str_notify_on_assignment_c
    , json:"FULL_PHOTO_URL"::text                                                                                as full_photo_url
    , try_to_boolean(json:"HAS_USER_VERIFIED_EMAIL"::text)::int
        as has_user_verified_email
    , try_to_boolean(json:"HAS_USER_VERIFIED_PHONE"::text)::int
        as has_user_verified_phone
    , try_to_boolean(json:"HOOPLA_C"::text)::int                                                                 as hoopla_c
    , json:"ID"::text                                                                                            as id
    , try_to_boolean(json:"IS_ACTIVE"::text)::int                                                                as is_active
    , try_to_boolean(json:"IS_EXT_INDICATOR_VISIBLE"::text)::int
        as is_ext_indicator_visible
    , try_to_boolean(json:"IS_PROFILE_PHOTO_ACTIVE"::text)::int
        as is_profile_photo_active
    , json:"LANGUAGE_LOCALE_KEY"::text
        as language_locale_key
    , json:"LAST_LOGIN_DATE"::text
        as last_login_date
    , json:"LAST_MODIFIED_BY_ID"::text
        as last_modified_by_id
    , json:"LAST_MODIFIED_DATE"::text
        as last_modified_date
    , json:"LAST_NAME"::text                                                                                     as last_name
    , json:"LAST_PASSWORD_CHANGE_DATE"::text
        as last_password_change_date
    , json:"LAST_REFERENCED_DATE"::text
        as last_referenced_date
    , json:"LAST_VIEWED_DATE"::text
        as last_viewed_date
    , json:"LOCALE_SID_KEY"::text                                                                                as locale_sid_key
    , json:"MANAGER_ID"::text                                                                                    as manager_id
    , json:"MEDIUM_BANNER_PHOTO_URL"::text
        as medium_banner_photo_url
    , json:"MEDIUM_PHOTO_URL"::text
        as medium_photo_url
    , json:"MIDDLE_NAME"::text                                                                                   as middle_name
    , json:"MOBILE_PHONE"::text                                                                                  as mobile_phone
    , json:"NAME"::text                                                                                          as name
    , json:"NUMBER_OF_FAILED_LOGINS"::int
        as number_of_failed_logins
    , json:"OUT_OF_OFFICE_MESSAGE"::text
        as out_of_office_message
    , json:"PARTNER_TEAM_C"::text                                                                                as partner_team_c
    , json:"PASSWORD_EXPIRATION_DATE"::text
        as password_expiration_date
    , json:"PHONE"::text                                                                                         as phone
    , json:"POSTAL_CODE"::text                                                                                   as postal_code
    , json:"PRIMARY_ADVISOR_C"::text
        as primary_advisor_c
    , json:"PROFILE_ID"::text                                                                                    as profile_id
    , try_to_boolean(json:"RECEIVES_ADMIN_INFO_EMAILS"::text)::int
        as receives_admin_info_emails
    , try_to_boolean(json:"RECEIVES_INFO_EMAILS"::text)::int
        as receives_info_emails
    , json:"REGION_C"::text                                                                                      as region_c
    , json:"SCHWAB_ABP_SMA_C"::int
        as schwab_abp_sma_c
    , json:"SCHWAB_NON_MANAGED_FA_C"::int
        as schwab_non_managed_fa_c
    , json:"SCHWAB_TBP_SMA_C"::int
        as schwab_tbp_sma_c
    , json:"SENDER_EMAIL"::text                                                                                  as sender_email
    , json:"SENDER_NAME"::text                                                                                   as sender_name
    , json:"SIGNATURE"::text                                                                                     as signature
    , json:"SMALL_BANNER_PHOTO_URL"::text
        as small_banner_photo_url
    , json:"SMALL_PHOTO_URL"::text
        as small_photo_url
    , json:"START_DAY"::int                                                                                      as start_day
    , json:"STATE"::text                                                                                         as state
    , json:"STATE_CODE"::text                                                                                    as state_code
    , json:"STREET"::text                                                                                        as street
    , json:"SYSTEM_MODSTAMP"::text
        as system_mod_stamp
    , json:"TIER_C"::int                                                                                         as tier_c
    , json:"TIME_ZONE_SID_KEY"::text
        as time_zone_sid_key
    , json:"TITLE"::text                                                                                         as title
    , json:"USERNAME"::text                                                                                      as username
    , try_to_boolean(json:"USER_PERMISSIONS_AVANTGO_USER"::text)::int
        as user_permissions_avantgo_user
    , try_to_boolean(json:"USER_PERMISSIONS_CALL_CENTER_AUTO_LOGIN"::text)::int
        as user_permissions_call_center_autologin
    , try_to_boolean(json:"USER_PERMISSIONS_INTERACTION_USER"::text)::int
        as user_permissions_interaction_user
    , try_to_boolean(json:"USER_PERMISSIONS_MARKETING_USER"::text)::int
        as user_permissions_marketing_user
    , try_to_boolean(json:"USER_PERMISSIONS_OFFLINE_USER"::text)::int
        as user_permissions_offline_user
    , try_to_boolean(json:"USER_PERMISSIONS_SFCONTENT_USER"::text)::int
        as user_permissions_sf_content_user
    , try_to_boolean(json:"USER_PERMISSIONS_SUPPORT_USER"::text)::int
        as user_permissions_support_user
    , try_to_boolean(json:"USER_PREFERENCES_ACTION_LAUNCHER_EINSTEIN_GPT_CONSENT"::text)::int
        as user_preferences_action_launcher_einstein_gpt_consent
    , try_to_boolean(json:"USER_PREFERENCES_ACTIVITY_REMINDERS_POPUP"::text)::int
        as user_preferences_activity_reminders_popup
    , try_to_boolean(json:"USER_PREFERENCES_APEX_PAGES_DEVELOPER_MODE"::text)::int
        as user_preferences_apex_pages_developer_mode
    , try_to_boolean(json:"USER_PREFERENCES_ASSISTIVE_ACTIONS_ENABLED_IN_ACTION_LAUNCHER"::text)::int
        as user_preferences_assistive_actions_enabled_in_action_launcher
    , try_to_boolean(json:"USER_PREFERENCES_CACHE_DIAGNOSTICS"::text)::int
        as user_preferences_cache_diagnostics
    , try_to_boolean(json:"USER_PREFERENCES_CREATE_LEXAPPS_WTSHOWN"::text)::int
        as user_preferences_create_lex_apps_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_ALL_FEEDS_EMAIL"::text)::int
        as user_preferences_disable_all_feeds_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_BOOKMARK_EMAIL"::text)::int
        as user_preferences_disable_bookmark_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_CHANGE_COMMENT_EMAIL"::text)::int
        as user_preferences_disable_change_comment_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_ENDORSEMENT_EMAIL"::text)::int
        as user_preferences_disable_endorsement_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_FILE_SHARE_NOTIFICATIONS_FOR_API"::text)::int
        as user_preferences_disable_fileshare_notifications_for_api
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_FOLLOWERS_EMAIL"::text)::int
        as user_preferences_disable_followers_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_LATER_COMMENT_EMAIL"::text)::int
        as user_preferences_disable_later_comment_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_LIKE_EMAIL"::text)::int
        as user_preferences_disable_like_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_MENTIONS_POST_EMAIL"::text)::int
        as user_preferences_disable_mentions_post_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_MESSAGE_EMAIL"::text)::int
        as user_preferences_disable_message_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_PROFILE_POST_EMAIL"::text)::int
        as user_preferences_disable_profile_post_email
    , try_to_boolean(json:"USER_PREFERENCES_DISABLE_SHARE_POST_EMAIL"::text)::int
        as user_preferences_disable_share_post_email
    , try_to_boolean(json:"USER_PREFERENCES_DIS_COMMENT_AFTER_LIKE_EMAIL"::text)::int
        as user_preferences_dis_comment_after_like_email
    , try_to_boolean(json:"USER_PREFERENCES_DIS_MENTIONS_COMMENT_EMAIL"::text)::int
        as user_preferences_dis_mentions_comment_email
    , try_to_boolean(json:"USER_PREFERENCES_DIS_PROF_POST_COMMENT_EMAIL"::text)::int
        as user_preferences_dis_prof_post_comment_email
    , try_to_boolean(json:"USER_PREFERENCES_ENABLE_AUTO_SUB_FOR_FEEDS"::text)::int
        as user_preferences_enable_auto_sub_for_feeds
    , try_to_boolean(json:"USER_PREFERENCES_EVENT_REMINDERS_CHECKBOX_DEFAULT"::text)::int
        as user_preferences_event_reminders_checkbox_default
    , try_to_boolean(json:"USER_PREFERENCES_EXCLUDE_MAIL_APP_ATTACHMENTS"::text)::int
        as user_preferences_exclude_mail_app_attachments
    , try_to_boolean(json:"USER_PREFERENCES_FAVORITES_SHOW_TOP_FAVORITES"::text)::int
        as user_preferences_favorites_show_top_favorites
    , try_to_boolean(json:"USER_PREFERENCES_FAVORITES_WTSHOWN"::text)::int
        as user_preferences_favorites_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_GLOBAL_NAV_BAR_WTSHOWN"::text)::int
        as user_preferences_global_navbar_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_GLOBAL_NAV_GRID_MENU_WTSHOWN"::text)::int
        as user_preferences_global_nav_grid_menu_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_HAS_CELEBRATION_BADGE"::text)::int
        as user_preferences_has_celebration_badge
    , try_to_boolean(json:"USER_PREFERENCES_HAS_SENT_WARNING_EMAIL"::text)::int
        as user_preferences_has_sent_warning_email
    , try_to_boolean(json:"USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_238"::text)::int
        as user_preferences_has_sent_warning_email_238
    , try_to_boolean(json:"USER_PREFERENCES_HAS_SENT_WARNING_EMAIL_240"::text)::int
        as user_preferences_has_sent_warning_email_240
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_BIGGER_PHOTO_CALLOUT"::text)::int
        as user_preferences_hide_bigger_photo_call_out
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_BROWSE_PRODUCT_REDIRECT_CONFIRMATION"::text)::int
        as user_preferences_hide_browse_product_redirect_confirmation
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_CHATTER_ONBOARDING_SPLASH"::text)::int
        as user_preferences_hide_chatter_on_boarding_splash
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_CSNDESKTOP_TASK"::text)::int
        as user_preferences_hide_csn_desktop_task
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_CSNGET_CHATTER_MOBILE_TASK"::text)::int
        as user_preferences_hide_csn_get_chatter_mobile_task
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_END_USER_ONBOARDING_ASSISTANT_MODAL"::text)::int
        as user_preferences_hide_end_user_on_boarding_assistant_modal
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_LIGHTNING_MIGRATION_MODAL"::text)::int
        as user_preferences_hide_lightning_migration_modal
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_ONLINE_SALES_APP_TAB_VISIBILITY_REQUIREMENTS_MODAL"::text)::int
        as user_preferences_hide_online_sales_app_tab_visibility_requirements_modal
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_ONLINE_SALES_APP_WELCOME_MAT"::text)::int
        as user_preferences_hide_online_sales_app_welcome_mat
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_SECOND_CHATTER_ONBOARDING_SPLASH"::text)::int
        as user_preferences_hide_second_chatter_on_boarding_splash
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_SFX_WELCOME_MAT"::text)::int
        as user_preferences_hide_sfx_welcome_mat
    , try_to_boolean(json:"USER_PREFERENCES_HIDE_S_1_BROWSER_UI"::text)::int
        as user_preferences_hide_s_1_browser_ui
    , try_to_boolean(json:"USER_PREFERENCES_LIGHTNING_EXPERIENCE_PREFERRED"::text)::int
        as user_preferences_lightning_experience_preferred
    , try_to_boolean(json:"USER_PREFERENCES_LIVE_AGENT_MIAW_SETUP_DEFLECTION"::text)::int
        as user_preferences_live_agent_miaw_setup_deflection
    , try_to_boolean(json:"USER_PREFERENCES_NATIVE_EMAIL_CLIENT"::text)::int
        as user_preferences_native_email_client
    , try_to_boolean(json:"USER_PREFERENCES_NEW_LIGHTNING_REPORT_RUN_PAGE_ENABLED"::text)::int
        as user_preferences_new_lightning_report_run_page_enabled
    , try_to_boolean(json:"USER_PREFERENCES_PATH_ASSISTANT_COLLAPSED"::text)::int
        as user_preferences_path_assistant_collapsed
    , try_to_boolean(json:"USER_PREFERENCES_PREVIEW_CUSTOM_THEME"::text)::int
        as user_preferences_preview_custom_theme
    , try_to_boolean(json:"USER_PREFERENCES_PREVIEW_LIGHTNING"::text)::int
        as user_preferences_preview_lightning
    , try_to_boolean(json:"USER_PREFERENCES_RECEIVE_NOTIFICATIONS_AS_DELEGATED_APPROVER"::text)::int
        as user_preferences_receive_notifications_as_delegated_approver
    , try_to_boolean(json:"USER_PREFERENCES_RECEIVE_NO_NOTIFICATIONS_AS_APPROVER"::text)::int
        as user_preferences_receive_no_notifications_as_approver
    , try_to_boolean(json:"USER_PREFERENCES_RECORD_HOME_RESERVED_WTSHOWN"::text)::int
        as user_preferences_record_home_reserved_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_RECORD_HOME_SECTION_COLLAPSE_WTSHOWN"::text)::int
        as user_preferences_record_home_section_collapse_wt_shown
    , try_to_boolean(json:"USER_PREFERENCES_REMINDER_SOUND_OFF"::text)::int
        as user_preferences_reminder_sound_off
    , try_to_boolean(json:"USER_PREFERENCES_REVERSE_OPEN_ACTIVITIES_VIEW"::text)::int
        as user_preferences_reverse_open_activities_view
    , try_to_boolean(json:"USER_PREFERENCES_SEND_LIST_EMAIL_THROUGH_EXTERNAL_SERVICE"::text)::int
        as user_preferences_send_list_email_through_external_service
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_CITY_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_city_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_CITY_TO_GUEST_USERS"::text)::int
        as user_preferences_show_city_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_COUNTRY_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_country_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_COUNTRY_TO_GUEST_USERS"::text)::int
        as user_preferences_show_country_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_EMAIL_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_email_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_EMAIL_TO_GUEST_USERS"::text)::int
        as user_preferences_show_email_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_FAX_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_fax_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_FAX_TO_GUEST_USERS"::text)::int
        as user_preferences_show_fax_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_FORECASTING_CHANGE_SIGNALS"::text)::int
        as user_preferences_show_forecasting_change_signals
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_FORECASTING_ROUNDED_AMOUNTS"::text)::int
        as user_preferences_show_forecasting_rounded_amounts
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_MANAGER_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_manager_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_MANAGER_TO_GUEST_USERS"::text)::int
        as user_preferences_show_manager_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_mobile_phone_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_MOBILE_PHONE_TO_GUEST_USERS"::text)::int
        as user_preferences_show_mobile_phone_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_POSTAL_CODE_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_postal_code_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_POSTAL_CODE_TO_GUEST_USERS"::text)::int
        as user_preferences_show_postal_code_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_PROFILE_PIC_TO_GUEST_USERS"::text)::int
        as user_preferences_show_profile_pic_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_STATE_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_state_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_STATE_TO_GUEST_USERS"::text)::int
        as user_preferences_show_state_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_street_address_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_STREET_ADDRESS_TO_GUEST_USERS"::text)::int
        as user_preferences_show_street_address_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_TITLE_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_title_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_TITLE_TO_GUEST_USERS"::text)::int
        as user_preferences_show_title_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_WORK_PHONE_TO_EXTERNAL_USERS"::text)::int
        as user_preferences_show_work_phone_to_external_users
    , try_to_boolean(json:"USER_PREFERENCES_SHOW_WORK_PHONE_TO_GUEST_USERS"::text)::int
        as user_preferences_show_work_phone_to_guest_users
    , try_to_boolean(json:"USER_PREFERENCES_SORT_FEED_BY_COMMENT"::text)::int
        as user_preferences_sort_feed_by_comment
    , try_to_boolean(json:"USER_PREFERENCES_SRHOVERRIDE_ACTIVITIES"::text)::int
        as user_preferences_srh_override_activities
    , try_to_boolean(json:"USER_PREFERENCES_SUPPRESS_EVENT_SFXREMINDERS"::text)::int
        as user_preferences_suppress_events_fx_reminders
    , try_to_boolean(json:"USER_PREFERENCES_SUPPRESS_TASK_SFXREMINDERS"::text)::int
        as user_preferences_suppress_tasks_fx_reminders
    , try_to_boolean(json:"USER_PREFERENCES_TASK_REMINDERS_CHECKBOX_DEFAULT"::text)::int
        as user_preferences_task_reminders_checkbox_default
    , try_to_boolean(json:"USER_PREFERENCES_USER_DEBUG_MODE_PREF"::text)::int
        as user_preferences_user_debug_mode_pref
    , json:"USER_ROLE_ID"::text                                                                                  as user_role_id
    , json:"USER_TYPE"::text                                                                                     as user_type
    , try_to_boolean(json:"_FIVETRAN_DELETED"::text)::int
        as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text
        as fivetran_synced

    , effective_at::timestamp                                                                                    as effective_at
    , _created_at::timestamp                                                                                     as _created_at
    , {{ col_is_head(reference=src, source_date_col='effective_at', reference_date_col='effective_at') }}
    , case when row_number()
                over (
                    partition by effective_at
                    order by _created_at desc
                )
            = 1 then 1
        else 0
    end                                                                                                          as is_latest
from {{ src }}
