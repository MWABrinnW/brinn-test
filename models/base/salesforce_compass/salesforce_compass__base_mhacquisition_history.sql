select
    a.json:ID:: VARCHAR(18)               as id
  , a.json:IS_DELETED:: BOOLEAN           as is_deleted
  , a.json:PARENT_ID:: VARCHAR(18)        as parent_id
  , a.json:CREATED_BY_ID:: VARCHAR(18)    as created_by_id
  , a.json:CREATED_DATE:: TIMESTAMPTZ     as created_date
  , a.json:FIELD:: VARCHAR(765)           as field
  , a.json:DATA_TYPE:: VARCHAR(120)       as data_type
  , a.json:OLD_VALUE:: VARCHAR(765)       as old_value
  , a.json:NEW_VALUE:: VARCHAR(765)       as new_value
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: BOOLEAN    as _fivetran_deleted

  , a.effective_at::timestamp             as effective_at
  , a._created_at::timestamp              as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'mhacquisition_history'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end  as is_latest
from {{ source('salesforce_compass', 'mhacquisition_history') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'mhacquisition_history') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at