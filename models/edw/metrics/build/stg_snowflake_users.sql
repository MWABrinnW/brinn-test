select
    user_id                  as user_id
    , login_name             as user_name
    , created_on             as created_on
    , deleted_on             as deleted_on
    , login_name             as login_name
    , display_name           as display_name
    , first_name             as first_name
    , last_name              as last_name
    , email                  as email
    , owner                  as owner
    , type                   as type
    , default_role           as default_role
    , default_secondary_role as default_secondary_role
    , comment                as comment
    , default_warehouse      as default_warehouse
    , default_namespace      as default_namespace
    , must_change_password   as must_change_password
    , disabled               as disabled
    , has_mfa                as has_mfa
    , has_password           as has_password
    , password_last_set_time as password_last_set_time
    , snowflake_lock         as snowflake_lock
    , locked_until_time      as locked_until_time
    , ext_authn_duo          as ext_authn_duo
    , ext_authn_uid          as ext_authn_uid
    , last_success_login     as last_success_login
    , expires_at             as expires_at
    , has_rsa_public_key     as has_rsa_public_key
from {{ source('snowflake_internal', 'users') }}
