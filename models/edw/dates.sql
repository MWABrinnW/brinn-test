{{ config(
  materialized='table',
  schema='ref',
  grants = {'select': ['db_edw_general_mwa_r']}
) }}

with cte_dates as
(
  select
      a.*
    , case 
        when h.market_holiday is not null 
          then 1 
        else 0 
        end                   as is_holiday
  from {{ ref('base_dates') }} a
  left join {{ ref('market_holidays') }} h
    on a.date_day = h.market_holiday
  order by a.date_day
)
,cte_flagged as
(
  select
      date_day                                                as date_key
    , to_char(date_day, 'YYYYMMDD')::int                      as datenum
    , prior_date_day                                          as prior_day_date
    , next_date_day                                           as next_day_date
    , prior_year_date_day                                     as prior_year_day_date
    , prior_year_over_year_date_day                           as prior_year_over_year_day_date
    , day_of_week                                             as week_daynum
    , day_of_week_iso                                         as week_iso_daynum
    , case when week_daynum in (2,3,4,5,6)
      then 1
      else 0
      end                                                     as is_weekday
    , case when week_daynum in (1,7)
      then 1
      else 0
      end                                                     as is_weekend
    , day_of_week_name                                        as day_of_week_name
    , day_of_week_name_short                                  as day_of_week_name_short
    , day_of_month                                            as month_daynum
    , day_of_year                                             as year_daynum
    , week_start_date                                         as week_start_date
    , week_end_date                                           as week_end_date
    , prior_year_week_start_date                              as prior_year_week_start_date
    , prior_year_week_end_date                                as prior_year_week_end_date
    , week_of_year                                            as year_weeknum
    , iso_week_start_date                                     as iso_week_start_date
    , iso_week_end_date                                       as iso_week_end_date
    , prior_year_iso_week_start_date                          as prior_year_iso_week_start_date
    , prior_year_iso_week_end_date                            as prior_year_iso_week_end_date
    , iso_week_of_year                                        as year_iso_weeknum
    , prior_year_week_of_year                                 as prior_year_weeknum
    , prior_year_iso_week_of_year                             as prior_year_iso_weeknum
    , month_of_year                                           as year_monthnum
    , month_name                                              as month_name
    , month_name_short                                        as month_name_short
    , month_start_date                                        as month_start_date
    , month_end_date                                          as month_end_date
    , prior_year_month_start_date                             as prior_year_month_start_date
    , prior_year_month_end_date                               as prior_year_month_end_date
    , to_char(quarter_end_date, 'YYYYMM')::int                as year_quarternum
    , quarter_of_year                                         as quarternum
    , concat('Q', quarter_of_year)                            as quarter
    , quarter_start_date                                      as quarter_start_date
    , quarter_end_date                                        as quarter_end_date
    , date_trunc(month, dateadd(month, -2, quarter_end_date)) as prior_quarter_start_date
    , dateadd(d, -1, quarter_start_date)                      as prior_quarter_end_date
    , year_number                                             as yearnum
    , year_start_date                                         as year_start_date
    , year_end_date                                           as year_end_date
    , is_holiday                                              as is_holiday
    , case
        when is_weekday = 1 and is_holiday = 0
          then 1
        else 0
        end                                                   as is_market_day
  from cte_dates
  order by date_day
)


select
  *
  ,last_value(case when is_market_day = 1 then date_key end) ignore nulls
            over (order by date_key asc rows between unbounded preceding and 1 preceding)
            as prior_market_date
  ,min(case when is_market_day = 1 then date_key else null end::date) over(partition by date_trunc('MONTH', date_key) order by date_key asc) as month_first_market_date
  ,max(case when is_market_day = 1 then date_key else null end::date) over(partition by date_trunc('MONTH', date_key) order by date_key desc) as month_last_market_date
from cte_flagged
order by date_key
