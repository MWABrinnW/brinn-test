select
    a.json:ID:: VARCHAR(18)                  as id
  , a.json:IS_DELETED:: BOOLEAN              as is_deleted
  , a.json:DEVELOPER_NAME:: VARCHAR(240)     as developer_name
  , a.json:LANGUAGE:: VARCHAR(120)           as language
  , a.json:MASTER_LABEL:: VARCHAR(240)       as master_label
  , a.json:NAMESPACE_PREFIX:: VARCHAR(45)    as namespace_prefix
  , a.json:CREATED_DATE:: TIMESTAMPTZ        as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)       as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ  as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18) as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ     as system_modstamp
  , a.json:IS_ACTIVE:: BOOLEAN               as is_active
  , a.json:SPLIT_ENTITY:: VARCHAR(765)       as split_entity
  , a.json:SPLIT_FIELD:: VARCHAR(765)        as split_field
  , a.json:DESCRIPTION:: VARCHAR(765)        as description
  , a.json:IS_TOTAL_VALIDATED:: BOOLEAN      as is_total_validated
  , a.json:SPLIT_DATA_STATUS:: VARCHAR(765)  as split_data_status
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ    as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: BOOLEAN       as _fivetran_deleted

  , a.effective_at::timestamp                as effective_at
  , a._created_at::timestamp                 as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity_split_type'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end     as is_latest
from {{ source('salesforce_compass', 'opportunity_split_type') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'opportunity_split_type') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
