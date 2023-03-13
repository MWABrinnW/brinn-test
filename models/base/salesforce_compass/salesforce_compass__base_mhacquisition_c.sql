select
    a.json:ID:: VARCHAR(18)                     as id
  , a.json:OWNER_ID:: VARCHAR(18)               as owner_id
  , a.json:IS_DELETED:: BOOLEAN                 as is_deleted
  , a.json:NAME:: VARCHAR(240)                  as name
  , a.json:CREATED_DATE:: TIMESTAMPTZ           as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)          as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ     as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)    as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ        as system_modstamp
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ       as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ   as last_referenced_date
  , a.json:ACQUIRED_DATE_C:: DATE               as acquired_date_c
  , a.json:COMMENTS_C:: VARCHAR(98304)          as comments_c
  , a.json:FIRM_C:: VARCHAR(18)                 as firm_c
  , a.json:MHLOCATION_C:: VARCHAR(18)           as mhlocation_c
  , a.json:TYPE_C:: VARCHAR(765)                as type_c
  , a.json:GOAL_CLIENTS_C:: DOUBLE              as goal_clients_c
  , a.json:GOAL_ASSETS_C:: NUMBER(18)           as goal_assets_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ       as _fivetran_synced
  , a.json:CLIENT_MANAGER_C:: VARCHAR(18)       as client_manager_c
  , a.json:GOAL_REVENUE_C:: NUMBER(12)          as goal_revenue_c
  , a.json:IGODEAL_ID_C:: VARCHAR(765)          as igodeal_id_c
  , a.json:ADP_EMPLOYEE_SOURCE_C:: VARCHAR(765) as adp_employee_source_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN          as _fivetran_deleted

  , a.effective_at::timestamp                   as effective_at
  , a._created_at::timestamp                    as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'mhacquisition_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end        as is_latest
from {{ source('salesforce_compass', 'mhacquisition_c') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'mhacquisition_c') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
