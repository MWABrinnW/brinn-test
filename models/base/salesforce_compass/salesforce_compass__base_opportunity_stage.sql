select
    a.json:ID:: VARCHAR(18)                      as id
  , a.json:MASTER_LABEL:: VARCHAR(765)           as master_label
  , a.json:API_NAME:: VARCHAR(765)               as api_name
  , a.json:IS_ACTIVE:: BOOLEAN                   as is_active
  , a.json:SORT_ORDER:: NUMBER                   as sort_order
  , a.json:IS_CLOSED:: BOOLEAN                   as is_closed
  , a.json:IS_WON:: BOOLEAN                      as is_won
  , a.json:FORECAST_CATEGORY:: VARCHAR(120)      as forecast_category
  , a.json:FORECAST_CATEGORY_NAME:: VARCHAR(765) as forecast_category_name
  , a.json:DEFAULT_PROBABILITY:: DOUBLE          as default_probability
  , a.json:DESCRIPTION:: VARCHAR(765)            as description
  , a.json:CREATED_BY_ID:: VARCHAR(18)           as created_by_id
  , a.json:CREATED_DATE:: TIMESTAMPTZ            as created_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)     as last_modified_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ      as last_modified_date
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ         as system_modstamp
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ        as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: BOOLEAN           as _fivetran_deleted

  , a.effective_at::timestamp                    as effective_at
  , a._created_at::timestamp                     as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity_stage'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end         as is_latest
from {{ source('salesforce_compass', 'opportunity_stage') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'opportunity_stage') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
