select
    'salesforce'::text(200)                                 as system_name
  , 'corbenic'::text(200)                                   as system_instance
  , concat(system_name, '__', system_instance)::text(200)   as system_key
  , 'mwa'::text(200)                                        as firm_source
  , a.json:ID:: varchar(18)                                 as id
  , a.json:OWNER_ID:: varchar(18)                           as owner_id
  , a.json:IS_DELETED:: boolean                             as is_deleted
  , a.json:NAME:: varchar(240)                              as name
  , a.json:CREATED_DATE:: timestamp_tz(9)                   as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                      as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamp_tz(9)             as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamp_tz(9)                as system_modstamp
  , a.json:LAST_VIEWED_DATE:: timestamp_tz(9)               as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamp_tz(9)           as last_referenced_date
  , a.json:PRACTIFI_BATCH_C:: varchar(18)                   as practifi_batch_c
  , a.json:PRACTIFI_DESCRIPTION_C:: varchar(765)            as practifi_description_c
  , a.json:PRACTIFI_END_DATE_C:: date                       as practifi_end_date_c
  , a.json:PRACTIFI_EXTERNAL_ID_C:: varchar(765)            as practifi_external_id_c
  , a.json:PRACTIFI_FROM_ENTITY_C:: varchar(18)             as practifi_from_entity_c
  , a.json:PRACTIFI_RELATED_DIVISION_C:: varchar(18)        as practifi_related_division_c
  , a.json:PRACTIFI_RELATIONSHIP_TYPE_C:: varchar(18)       as practifi_relationship_type_c
  , a.json:PRACTIFI_SHARING_SCOPE_C:: varchar(765)          as practifi_sharing_scope_c
  , a.json:PRACTIFI_START_DATE_C:: date                     as practifi_start_date_c
  , a.json:PRACTIFI_TO_ENTITY_C:: varchar(18)               as practifi_to_entity_c
  , a.json:PRACTIFI_TO_DIVISION_C:: varchar(18)             as practifi_to_division_c
  , a.json:PRACTIFI_AUM_FROM_REFERRAL_C:: number            as practifi_aum_from_referral_c
  , a.json:PRACTIFI_SET_AS_CREATED_DATE_C:: timestamp_tz(9) as practifi_set_as_created_date_c
  , a.json:PRACTIFI_ACTIVE_C:: boolean                      as practifi_active_c
  , a.json:PRACTIFI_FROM_CONTACT_C:: varchar(18)            as practifi_from_contact_c
  , a.json:PRACTIFI_TO_CONTACT_C:: varchar(18)              as practifi_to_contact_c
  , a.json:PRACTIFI_DEFER_AUTOMATION_C:: boolean            as practifi_defer_automation_c
  , a.json:PRACTIFI_FROM_NAME_C:: varchar(765)              as practifi_from_name_c
  , a.json:PRACTIFI_TO_NAME_C:: varchar(765)                as practifi_to_name_c
  , a.json:PRACTIFI_TO_RELATED_DIVISION_C:: varchar(18)     as practifi_to_related_division_c
  , a.json:PRACTIFI_SHARING_SCOPE_2_C:: varchar(765)        as practifi_sharing_scope_2_c
  , a.json:PRACTIFI_SHARING_SCOPE_3_C:: varchar(765)        as practifi_sharing_scope_3_c
  , a.json:PRACTIFI_SHARING_SCOPE_4_C:: varchar(765)        as practifi_sharing_scope_4_c
  , a.json:PRACTIFI_SHARING_SCOPE_5_C:: varchar(765)        as practifi_sharing_scope_5_c
  , a.json:PRACTIFI_AUTHORIZED_REPRESENTATIVE_C:: boolean   as practifi_authorized_representative_c
  , a.json:_FIVETRAN_DELETED:: boolean                      as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED:: timestamp_tz(9)               as _fivetran_synced

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
)                                                                   b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at