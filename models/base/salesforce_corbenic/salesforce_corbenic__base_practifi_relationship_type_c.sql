select
    a.json:ID:: VARCHAR(18)                              as id
  , a.json:OWNER_ID:: VARCHAR(18)                        as owner_id
  , a.json:IS_DELETED:: BOOLEAN                          as is_deleted
  , a.json:NAME:: VARCHAR(240)                           as name
  , a.json:CREATED_DATE:: TIMESTAMP_TZ(9)                as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                   as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMP_TZ(9)          as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)             as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMP_TZ(9)             as system_modstamp
  , a.json:LAST_VIEWED_DATE:: TIMESTAMP_TZ(9)            as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMP_TZ(9)        as last_referenced_date
  , a.json:PRACTIFI_CODE_C:: VARCHAR(765)                as practifi_code_c
  , a.json:PRACTIFI_TYPE_C:: VARCHAR(765)                as practifi_type_c
  , a.json:PRACTIFI_ACTION_TYPE_STRING_C:: VARCHAR(3900) as practifi_action_type_string_c
  , a.json:PRACTIFI_ACTION_TYPE_C:: VARCHAR(4099)        as practifi_action_type_c
  , a.json:PRACTIFI_ENTITY_TYPE_STRING_C:: VARCHAR(3900) as practifi_entity_type_string_c
  , a.json:PRACTIFI_ENTITY_TYPE_C:: VARCHAR(4099)        as practifi_entity_type_c
  , a.json:PRACTIFI_ORDER_C:: FLOAT                      as practifi_order_c
  , a.json:PRACTIFI_KEY_RELATIONSHIP_C:: BOOLEAN         as practifi_key_relationship_c
  , a.json:PRACTIFI_DISPLAY_IN_C:: VARCHAR(4099)         as practifi_display_in_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                   as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMP_TZ(9)            as _fivetran_synced

  , a.effective_at::timestamp                            as effective_at
  , a._created_at::timestamp                             as _created_at
  , {{ col_is_head(reference=source('salesforce_corbenic', 'practifi_relationship_type_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                 as is_latest
from {{ source('salesforce_corbenic', 'practifi_relationship_type_c') }} a
left join (
              select
                  effective_at::date                                                            as effective_at
                , _created_at
                , row_number() over (partition by effective_at::date order by _created_at desc) as rn
              from {{ source('salesforce_corbenic', 'practifi_relationship_type_c') }}
              group by 1, 2
          )                                                              b
          on a.effective_at::date = b.effective_at::date
              and a._created_at = b._created_at