select
    effective_at                         as effective_at
    , _created_at                        as _created_at
    , json:NAME::string                  as name
    , json:AUTH_SETTING::string          as auth_setting
    , json:ID::string                    as id
    , json:FULL_NAME::string             as full_name
    , json:DOMAIN_NAME::string           as domain_name
    , json:SITE_ROLE::string             as site_role
    , json:LANGUAGES::string             as languages
    , json:EMAIL::string                 as email
    , json:_FIVETRAN_DELETED::string     as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::string      as _fivetran_synced
    , json:EXTERNAL_AUTH_USER_ID::string as external_auth_user_id
    , json:LAST_LOGIN::string            as last_login
    , {{ col_is_head(
    reference=source('tableau_mwa', 'users'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'users') }}
