select
    json:ID::text                            as id
    , json:IS_DELETED::boolean               as is_deleted
    , json:NAME::text                        as name
    , json:CREATED_DATE::timestamp_tz        as created_date
    , json:CREATED_BY_ID::text               as created_by_id
    , json:LAST_MODIFIED_DATE::timestamp_tz  as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text         as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamp_tz     as system_modstamp
    , json:LAST_ACTIVITY_DATE::date          as last_activity_date
    , json:CONTACT_C::text                   as contact_c
    , json:DEAL_C::text                      as deal_c
    , json:ROLES_C::text                     as roles_c
    , json:_FIVETRAN_DELETED::boolean        as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz    as _fivetran_synced
    , 'salesforce'::text                     as system_name
    , 'igo'::text                            as system_instance
    , system_name || '__' || system_instance as system_key
    , effective_at                           as effective_at
    , _created_at                            as _created_at
    , {{ col_is_head(
      reference=source('salesforce_igo', 'deal_contact_relationship_c'),
      source_date_col='effective_at',
      reference_date_col='effective_at'
      ) }}
from {{ source('salesforce_igo', 'deal_contact_relationship_c') }}
