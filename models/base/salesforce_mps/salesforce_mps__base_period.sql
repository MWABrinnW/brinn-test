select
    a.json:_FIVETRAN_SYNCED::timestamp_tz     as _fivetran_synced
  , a.json:START_DATE::date                   as start_date
  , a.json:FISCAL_YEAR_SETTINGS_ID::text(900) as fiscal_year_settings_id
  , a.json:IS_FORECAST_PERIOD::boolean        as is_forecast_period
  , a.json:QUARTER_LABEL::text(1600)          as quarter_label
  , a.json:FULLY_QUALIFIED_LABEL::text(1100)  as fully_qualified_label
  , a.json:END_DATE::date                     as end_date
  , a.json:ID::text(900)                      as id
  , a.json:_FIVETRAN_DELETED::boolean         as _fivetran_deleted
  , a.json:TYPE::text(1000)                   as type
  , a.json:SYSTEM_MODSTAMP::timestamp_tz      as system_modstamp
  , a.json:PERIOD_LABEL::text(1600)           as period_label
  , a.json:NUMBER::number(38, 0)              as number
  , a.effective_at::timestamp                 as effective_at
  , a._created_at::timestamp                  as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'period'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end      as is_latest
from {{ source('salesforce_mps', 'period') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'period') }}
    group by 1, 2
)                                             b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
