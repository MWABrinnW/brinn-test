with dates as ( --- date spine
  select date_key as _date
  from {{ ref('dates') }}
  where true
    and _date between current_date - 90 and current_date
)

,metadata as (
  select
    table_schema,table_name,row_count
    ,convert_timezone('UTC', 'America/Chicago', dbt_valid_from) as dbt_valid_from
    ,convert_timezone('UTC', 'America/Chicago', dbt_valid_to) as dbt_valid_to
  from {{ ref('snapshots__datalake_tables_history') }}
  where true
    and table_type = 'BASE TABLE'
)

,daily_row_counts as (
  select _date,table_name,max(row_count) as daily_row_count
  from dates
  inner join metadata
      on _date between metadata.dbt_valid_from::date and ifnull(dbt_valid_to,current_timestamp)
  group by 1,2
)

,new_row_counts as (
  select *
  ,lag(daily_row_count,1) over (partition by table_name order by _date) as prior_day_rows
  ,daily_row_count - prior_day_rows as row_diff
  from daily_row_counts
)

select _date,table_name,sum(row_diff) as daily_row_diff
from new_row_counts
where true
  and row_diff is not null
group by _date,table_name
