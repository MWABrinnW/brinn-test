select
    a.json:ID:: VARCHAR(18)                        as id
  , a.json:OPPORTUNITY_ID:: VARCHAR(18)            as opportunity_id
  , a.json:USER_OR_GROUP_ID:: VARCHAR(18)          as user_or_group_id
  , a.json:OPPORTUNITY_ACCESS_LEVEL:: VARCHAR(120) as opportunity_access_level
  , a.json:ROW_CAUSE:: VARCHAR(120)                as row_cause
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ        as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)       as last_modified_by_id
  , a.json:IS_DELETED:: BOOLEAN                    as is_deleted
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ          as _fivetran_synced

  , a.effective_at::timestamp                      as effective_at
  , a._created_at::timestamp                       as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity_share'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end           as is_latest
from {{ source('salesforce_compass', 'opportunity_share') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'opportunity_share') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
