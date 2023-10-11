with cte_effday_count as (
                             select
                                 effective_date
                               , (select max(effective_date) from edw.mwa.account_holdings_daily) as max_effday
                               , system_name
                               , count(*)            as cnt
                             from {{ source('edw_mwa','financial_account_daily') }}
                             where effective_date >= dateadd(day, -75, (
                                                                           select
                                                                               max(effective_date)
                                                                           from {{ source('edw_mwa','financial_account_daily') }}
                                                                       ))
                             group by all
                         )
   , cte_lag_count    as (
                             select
                                 c.effective_date
                               , case
                                     when c.effective_date <> c.max_effday then false
                                     else true 
                                     end                                                                    as is_current
                               , c.system_name
                               , c.cnt                                                                      as cnt
                               , lag(c.cnt, 1)
                                     over (partition by c.system_name order by c.effective_date)            as cnt_01_effday_ago
                               , (
                                             (
                                                     c.cnt - lag(c.cnt, 1)
                                                                 over (partition by c.system_name order by c.effective_date)
                                                 ) / nullif(
                                                     lag(c.cnt, 1)
                                                         over (partition by c.system_name order by c.effective_date), 0
                                                 ) * 100
                                     )::decimal(10, 2)                                                      as cnt_01_delta
                               , lag(c.cnt, 15)
                                     over (partition by c.system_name order by c.effective_date)            as cnt_15_effday_ago
                               , (
                                             (
                                                     c.cnt - lag(c.cnt, 15)
                                                                 over (partition by c.system_name order by c.effective_date)
                                                 ) / nullif(
                                                     lag(c.cnt, 15)
                                                         over (partition by c.system_name order by c.effective_date), 0
                                                 ) * 100
                                     )::decimal(10, 2)                                                      as cnt_15_delta
                               , lag(c.cnt, 30)
                                     over (partition by c.system_name order by c.effective_date)            as cnt_30_effday_ago
                               , (
                                             (
                                                     c.cnt - lag(c.cnt, 30)
                                                                 over (partition by c.system_name order by c.effective_date)
                                                 ) / nullif(
                                                     lag(c.cnt, 30)
                                                         over (partition by c.system_name order by c.effective_date), 0
                                                 ) * 100
                                     )::decimal(10, 2)                                                      as cnt_30_delta
                             from cte_effday_count c
                             order by c.system_name, c.effective_date desc
                         )
   , cte_effday_delta as (
                             select *
                             from cte_lag_count
                             where (system_name, effective_date) in (
                                                                        select
                                                                            system_name
                                                                          , max(effective_date)
                                                                        from cte_lag_count
                                                                        group by system_name
                                                                    )
                               and (
                                         cnt_01_delta < -10 or cnt_01_delta > 10 or
                                         cnt_15_delta < -10 or cnt_15_delta > 10 or
                                         cnt_30_delta < -10 or cnt_30_delta > 10
                                 )
                             order by system_name
                         )
select
    effective_date
  , is_current
  , system_name
  , to_varchar(cnt, '999,999,999,999')        as cnt
  , to_varchar(cnt_01_effday_ago, '999,999,999,999') as cnt_01_effday_ago
  , concat(cnt_01_delta::decimal(15, 2), '%') as cnt_01_delta
  , to_varchar(cnt_15_effday_ago, '999,999,999,999') as cnt_15_effday_ago
  , concat(cnt_15_delta::decimal(15, 2), '%') as cnt_15_delta
  , to_varchar(cnt_30_effday_ago, '999,999,999,999') as cnt_30_effday_ago
  , concat(cnt_30_delta::decimal(15, 2), '%') as cnt_30_delta
from cte_effday_delta