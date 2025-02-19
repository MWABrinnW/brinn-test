select
    json:ID::text                                       as id
    , json:OWNER_ID::text                               as owner_id
    , json:IS_DELETED::boolean                          as is_deleted
    , json:NAME::text                                   as name
    , json:CREATED_DATE::timestamp_tz                   as created_date
    , json:CREATED_BY_ID::text                          as created_by_id
    , json:LAST_MODIFIED_DATE::timestamp_tz             as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text                    as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamp_tz                as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                     as last_activity_date
    , json:LAST_VIEWED_DATE::timestamp_tz               as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamp_tz           as last_referenced_date
    , json:PRACTIFI_EMAIL_C::text                       as practifi_email_c
    , json:PRACTIFI_PARENT_DIVISION_C::text             as practifi_parent_division_c
    , json:PRACTIFI_PHONE_C::text                       as practifi_phone_c
    , json:PRACTIFI_SHARING_SCOPE_C::text               as practifi_sharing_scope_c
    , json:PRACTIFI_SET_AS_CREATED_DATE_C::timestamp_tz as practifi_set_as_created_date_c
    , json:PRACTIFI_SHARING_SCOPE_2_C::text             as practifi_sharing_scope_2_c
    , json:PRACTIFI_SHARING_SCOPE_3_C::text             as practifi_sharing_scope_3_c
    , json:PRACTIFI_SHARING_SCOPE_4_C::text             as practifi_sharing_scope_4_c
    , json:PRACTIFI_SHARING_SCOPE_5_C::text             as practifi_sharing_scope_5_c
    , json:PRACTIFI_EXTERNAL_ID_C::text                 as practifi_external_id_c
    , json:_FIVETRAN_DELETED::boolean                   as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz               as _fivetran_synced
    , 'salesforce'::text                                as system_name
    , 'igo'::text                                       as system_instance
    , system_name || '__' || system_instance            as system_key
    , effective_at                                      as effective_at
    , _created_at                                       as _created_at
    , {{ col_is_head(
      reference=source('salesforce_igo', 'practifi_division_c'),
      source_date_col='effective_at',
      reference_date_col='effective_at'
      ) }}
from {{ source('salesforce_igo', 'practifi_division_c') }}
