{% set src = source('sugarcrm_woodbridge', 'employee') %}

select
    json:"ACL_ROLE_SET_ID"::text                                as acl_role_set_id
    , try_to_boolean(json:"COOKIE_CONSENT"::text)::int          as cookie_consent
    , json:"COOKIE_CONSENT_RECEIVED_ON"::text                   as cookie_consent_received_on
    , json:"CREATED_BY_ID"::text                                as created_by_id
    , json:"CREATED_BY_NAME"::text                              as created_by_name
    , try_to_boolean(json:"CUSTOMER_JOURNEY_ACCESS"::text)::int as customer_journey_access
    , json:"CUSTOM_CLOUD_CONSOLE_USER_LINK"::text               as custom_cloud_console_user_link
    , try_to_boolean(json:"CUSTOM_MY_FAVORITE"::text)::int      as custom_my_favorite
    , try_to_boolean(
        json:"CUSTOM_U_CALCULATEDFIELDS_APP_NOTIFY_C"::text
    )::int                                                      as custom_u_calculated_fields_app_notify_c
    , try_to_boolean(
        json:"CUSTOM_U_CALCULATEDFIELDS_EMAIL_NOTIFY_C"::text
    )::int                                                      as custom_u_calculated_fields_email_notify_c
    , try_to_boolean(
        json:"CUSTOM_U_CUSTOM_APP_NOTIFY_C"::text
    )::int                                                      as custom_u_custom_app_notify_c
    , try_to_boolean(
        json:"CUSTOM_U_CUSTOM_EMAIL_NOTIFY_C"::text
    )::int                                                      as custom_u_custom_email_notify_c
    , try_to_boolean(
        json:"CUSTOM_U_DEDUPLICATE_APP_NOTIFY_C"::text
    )::int                                                      as custom_u_deduplicate_app_notify_c
    , try_to_boolean(
        json:"CUSTOM_U_DEDUPLICATE_EMAIL_NOTIFY_C"::text
    )::int                                                      as custom_u_deduplicate_email_notify_c
    , json:"DATE_ENTERED"::text                                 as date_entered
    , json:"DATE_MODIFIED"::text                                as date_modified
    , json:"DEFAULT_TEAM"::int                                  as default_team
    , try_to_boolean(json:"DELETED"::text)::int                 as deleted
    , json:"DEPARTMENT"::text                                   as department
    , json:"EMPLOYEE_STATUS"::text                              as employee_status
    , try_to_boolean(json:"EXTERNAL_AUTH_ONLY"::text)::int      as external_auth_only
    , json:"FIRST_NAME"::text                                   as first_name
    , json:"FULL_NAME"::text                                    as full_name
    , json:"ID"::text                                           as id
    , try_to_boolean(json:"IS_ADMIN"::text)::int                as is_admin
    , try_to_boolean(json:"IS_GROUP"::text)::int                as is_group
    , json:"LAST_LOGIN"::text                                   as last_login
    , json:"LAST_NAME"::text                                    as last_name
    , json:"MODIFIED_USER_ID"::text                             as modified_user_id
    , json:"PHONE_WORK"::text                                   as phone_work
    , try_to_boolean(json:"PORTAL_ONLY"::text)::int             as portal_only
    , json:"PREFERRED_LANGUAGE"::text                           as preferred_language
    , json:"PWD_LAST_CHANGED"::text                             as pwd_last_changed
    , try_to_boolean(json:"RECEIVE_NOTIFICATION"::text)::int    as receive_notification
    , try_to_boolean(json:"SEND_EMAIL_ON_MENTION"::text)::int   as send_email_on_mention
    , try_to_boolean(json:"SHOW_ON_EMPLOYEES"::text)::int       as show_on_employees
    , json:"SITE_USER_ID"::text                                 as site_user_id
    , json:"STATUS"::text                                       as status
    , try_to_boolean(json:"SUGAR_LOGIN"::text)::int             as sugar_login
    , json:"SYNC_KEY"::text                                     as sync_key
    , try_to_boolean(
        json:"SYSTEM_GENERATED_PASSWORD"::text
    )::int                                                      as system_generated_password
    , json:"TITLE"::text                                        as title
    , try_to_boolean(json:"USER_HASH"::text)::int               as user_hash
    , json:"USER_NAME"::text                                    as username
    , try_to_boolean(json:"_FIVETRAN_DELETED"::text)::int       as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text                             as fivetran_synced

    , effective_at::timestamp                                   as effective_at
    , _created_at::timestamp                                    as _created_at
    , {{ col_is_head(reference=src
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ src }}
