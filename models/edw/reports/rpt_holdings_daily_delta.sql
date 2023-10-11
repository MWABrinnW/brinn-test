with cte_effday_count   as (
                               select
                                   effective_date
                                 , (select max(effective_date) from edw.mwa.account_holdings_daily) as max_effday -- obtain max effective date from dateset
                                 , system_name
                                 , count(*)            as cnt
                                 , sum(market_value)   as market_value
                               from {{ source('edw_mwa','account_holdings_daily') }}
                               where effective_date >= dateadd(day, -75, (
                                                                             select
                                                                                 max(effective_date)
                                                                             from {{ source('edw_mwa','account_holdings_daily') }}
                                                                         ))
                               group by all
                           )
   , cte_lag_market_sum as (
                               select
                                   c.effective_date
                                 , case
                                       when c.effective_date <> c.max_effday then false
                                       else true
                                       end                                                         as is_current
                                 , c.system_name
                                 , c.cnt                                                           as cnt
                                 , c.market_value                                                  as market_val
                                 , lag(c.market_value, 1)
                                       over (partition by c.system_name order by c.effective_date) as market_val_01_effday
                                 , (
                                               (
                                                       c.market_value - lag(c.market_value, 1)
                                                                            over (partition by c.system_name order by c.effective_date)
                                                   ) / nullif(
                                                       lag(c.market_value, 1)
                                                           over (partition by c.system_name order by c.effective_date),
                                                       0
                                                   ) * 100
                                       )::decimal(10, 2)                                           as market_val_01_delta
                                 , lag(c.market_value, 15)
                                       over (partition by c.system_name order by c.effective_date) as market_val_15_effday
                                 , (
                                               (
                                                       c.market_value - lag(c.market_value, 15)
                                                                            over (partition by c.system_name order by c.effective_date)
                                                   ) / nullif(
                                                       lag(c.market_value, 15)
                                                           over (partition by c.system_name order by c.effective_date),
                                                       0
                                                   ) * 100
                                       )::decimal(10, 2)                                           as market_val_15_delta
                                 , lag(c.market_value, 30)
                                       over (partition by c.system_name order by c.effective_date) as market_val_30_effday
                                 , (
                                               (
                                                       c.market_value - lag(c.market_value, 30)
                                                                            over (partition by c.system_name order by c.effective_date)
                                                   ) / nullif(
                                                       lag(c.market_value, 30)
                                                           over (partition by c.system_name order by c.effective_date),
                                                       0
                                                   ) * 100
                                       )::decimal(10, 2)                                           as market_val_30_delta
                               from cte_effday_count c
                               order by c.system_name, c.effective_date desc
                           )
   , cte_effday_delta   as (
                               select *
                               from cte_lag_market_sum
                               where (system_name, effective_date) in (
                                                                          select
                                                                              system_name
                                                                            , max(effective_date)
                                                                          from cte_lag_market_sum
                                                                          group by system_name
                                                                      )
                                 and (
                                           market_val_01_delta < -10 or market_val_01_delta > 10 or
                                           market_val_15_delta < -10 or market_val_01_delta > 10 or
                                           market_val_30_delta < -10 or market_val_01_delta > 10
                                   )
                               order by system_name
                           )
select
    effective_date
  , is_current
  , system_name
  , to_varchar(cnt, '999,999,999,999')                         as cnt
  , '$' || to_varchar(market_val, '999,999,999,999')           as market_value
  , '$' || to_varchar(market_val_01_effday, '999,999,999,999') as market_val_01_effday
  , concat(market_val_01_delta::decimal(15, 2), '%')           as market_val_01_delta
  , '$' || to_varchar(market_val_15_effday, '999,999,999,999') as market_val_15_effday
  , concat(market_val_15_delta::decimal(15, 2), '%')           as market_val_15_delta
  , '$' || to_varchar(market_val_15_effday, '999,999,999,999') as market_val_30_effday
  , concat(market_val_30_delta::decimal(15, 2), '%')           as market_val_30_delta
from cte_effday_delta