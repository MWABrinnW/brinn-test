select
    json:ID::text                            as id
    , json:IS_DELETED::boolean               as is_deleted
    , json:PARENT_ID::text                   as parent_id
    , json:CREATED_BY_ID::text               as created_by_id
    , json:CREATED_DATE::timestamp_tz        as created_date
    , json:FIELD::text                       as field
    , json:DATA_TYPE::text                   as data_type
    , json:OLD_VALUE::text                   as old_value
    , json:NEW_VALUE::text                   as new_value
    , json:_FIVETRAN_DELETED::boolean        as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz    as _fivetran_synced
    , 'salesforce'::text                     as system_name
    , 'igo'::text                            as system_instance
    , system_name || '__' || system_instance as system_key
    , effective_at                           as effective_at
    , _created_at                            as _created_at
    , {{ col_is_head(
      reference=source('salesforce_igo', 'practifi_deal_history'),
      source_date_col='effective_at',
      reference_date_col='effective_at'
      ) }}
from {{ source('salesforce_igo', 'practifi_deal_history') }}
