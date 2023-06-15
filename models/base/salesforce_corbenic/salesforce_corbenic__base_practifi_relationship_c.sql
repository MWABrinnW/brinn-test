select
    a.json:ID:: VARCHAR(18)                                 as id
  , a.json:OWNER_ID:: VARCHAR(18)                           as owner_id
  , a.json:IS_DELETED:: BOOLEAN                             as is_deleted
  , a.json:NAME:: VARCHAR(240)                              as name
  , a.json:CREATED_DATE:: TIMESTAMP_TZ(9)                   as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                      as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMP_TZ(9)             as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)                as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMP_TZ(9)                as system_modstamp
  , a.json:LAST_VIEWED_DATE:: TIMESTAMP_TZ(9)               as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMP_TZ(9)           as last_referenced_date
  , a.json:PRACTIFI_BATCH_C:: VARCHAR(18)                   as practifi_batch_c
  , a.json:PRACTIFI_DESCRIPTION_C:: VARCHAR(765)            as practifi_description_c
  , a.json:PRACTIFI_END_DATE_C:: DATE                       as practifi_end_date_c
  , a.json:PRACTIFI_EXTERNAL_ID_C:: VARCHAR(765)            as practifi_external_id_c
  , a.json:PRACTIFI_FROM_ENTITY_C:: VARCHAR(18)             as practifi_from_entity_c
  , a.json:PRACTIFI_RELATED_DIVISION_C:: VARCHAR(18)        as practifi_related_division_c
  , a.json:PRACTIFI_RELATIONSHIP_TYPE_C:: VARCHAR(18)       as practifi_relationship_type_c
  , a.json:PRACTIFI_SHARING_SCOPE_C:: VARCHAR(765)          as practifi_sharing_scope_c
  , a.json:PRACTIFI_START_DATE_C:: DATE                     as practifi_start_date_c
  , a.json:PRACTIFI_TO_ENTITY_C:: VARCHAR(18)               as practifi_to_entity_c
  , a.json:PRACTIFI_TO_DIVISION_C:: VARCHAR(18)             as practifi_to_division_c
  , a.json:PRACTIFI_AUM_FROM_REFERRAL_C:: NUMBER            as practifi_aum_from_referral_c
  , a.json:PRACTIFI_SET_AS_CREATED_DATE_C:: TIMESTAMP_TZ(9) as practifi_set_as_created_date_c
  , a.json:PRACTIFI_ACTIVE_C:: BOOLEAN                      as practifi_active_c
  , a.json:PRACTIFI_FROM_CONTACT_C:: VARCHAR(18)            as practifi_from_contact_c
  , a.json:PRACTIFI_TO_CONTACT_C:: VARCHAR(18)              as practifi_to_contact_c
  , a.json:PRACTIFI_DEFER_AUTOMATION_C:: BOOLEAN            as practifi_defer_automation_c
  , a.json:PRACTIFI_FROM_NAME_C:: VARCHAR(765)              as practifi_from_name_c
  , a.json:PRACTIFI_TO_NAME_C:: VARCHAR(765)                as practifi_to_name_c
  , a.json:PRACTIFI_TO_RELATED_DIVISION_C:: VARCHAR(18)     as practifi_to_related_division_c
  , a.json:PRACTIFI_SHARING_SCOPE_2_C:: VARCHAR(765)        as practifi_sharing_scope_2_c
  , a.json:PRACTIFI_SHARING_SCOPE_3_C:: VARCHAR(765)        as practifi_sharing_scope_3_c
  , a.json:PRACTIFI_SHARING_SCOPE_4_C:: VARCHAR(765)        as practifi_sharing_scope_4_c
  , a.json:PRACTIFI_SHARING_SCOPE_5_C:: VARCHAR(765)        as practifi_sharing_scope_5_c
  , a.json:PRACTIFI_AUTHORIZED_REPRESENTATIVE_C:: BOOLEAN   as practifi_authorized_representative_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                      as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMP_TZ(9)               as _fivetran_synced

  , a.effective_at::timestamp                               as effective_at
  , a._created_at::timestamp                                as _created_at
  , {{ col_is_head(reference=source('salesforce_corbenic', 'practifi_relationship_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                    as is_latest
from {{ source('salesforce_corbenic', 'practifi_relationship_c') }} a
left join (
              select
                  effective_at::date                                                            as effective_at
                , _created_at
                , row_number() over (partition by effective_at::date order by _created_at desc) as rn
              from {{ source('salesforce_corbenic', 'practifi_relationship_c') }}
              group by 1, 2
          )                                                         b
          on a.effective_at::date = b.effective_at::date
              and a._created_at = b._created_at