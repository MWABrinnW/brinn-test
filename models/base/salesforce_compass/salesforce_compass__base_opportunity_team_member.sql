select
    a.json:ID:: VARCHAR(18)                        as id
  , a.json:OPPORTUNITY_ID:: VARCHAR(18)            as opportunity_id
  , a.json:USER_ID:: VARCHAR(18)                   as user_id
  , a.json:NAME:: VARCHAR(1083)                    as name
  , a.json:PHOTO_URL:: VARCHAR(765)                as photo_url
  , a.json:TITLE:: VARCHAR(240)                    as title
  , a.json:TEAM_MEMBER_ROLE:: VARCHAR(765)         as team_member_role
  , a.json:OPPORTUNITY_ACCESS_LEVEL:: VARCHAR(120) as opportunity_access_level
  , a.json:CREATED_DATE:: TIMESTAMPTZ              as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)             as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ        as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)       as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ           as system_modstamp
  , a.json:IS_DELETED:: BOOLEAN                    as is_deleted
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ          as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: boolean             as _fivetran_deleted

  , a.effective_at::timestamp                      as effective_at
  , a._created_at::timestamp                       as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity_team_member'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end           as is_latest
from {{ source('salesforce_compass', 'opportunity_team_member') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'opportunity_team_member') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
