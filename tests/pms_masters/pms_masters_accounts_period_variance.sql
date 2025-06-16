{{ config(enabled=false) }}

-- acctBySystemKey
with data_cte as (
    select
        a.system_key
        , a.effective_date
        --key
        , case
            when a.system_key in ('axys__granite') then 'monthly'
            when a.system_key in ('tpg__hfw') then 'delayed'
            else 'daily'
        end::text               as reconciliation_frequency
        , a.is_market_day       as is_market_day
        , a.is_market_month_end as is_market_month_end
        , sum(a.account_value)  as account_value
        , count(*)              as cnt
    from {{ ref('odw_accounts') }} as a
    where true
        and a.is_legacy = 0
        and a.is_manual_account = 0
        and a.is_market_day = 1
        and a.effective_date >= dateadd('days' , -183 , current_date())
        and a.effective_date < current_date()
    group by all
)

, data_agg_cte as (
    select
        *
        , lead(cnt) over (
            partition by system_key
            order by effective_date desc
        )                                                                                        as cnt_prior_day
        , round(((cnt - cnt_prior_day) / cnt_prior_day) * 100 , 2)                               as cnt_delta
        , lead(account_value) over (
            partition by system_key
            order by effective_date desc
        )                                                                                        as account_value_prior_day
        , round(((account_value - account_value_prior_day) / account_value_prior_day) * 100 , 2) as account_value_delta
    from data_cte
    where true
        and case
            when reconciliation_frequency = 'daily'
                then effective_date >= dateadd('day' , -30 , current_date())
            when reconciliation_frequency = 'monthly'
                then effective_date >= dateadd('month' , -6 , current_date())
            when reconciliation_frequency = 'delayed'
                then (
                    effective_date >= dateadd('day' , -30 , current_date())
                    and effective_date <= dateadd('day' , -14 , current_date())
                )
        end
)

, data_agg_with_exclusions_cte as (
    select
        a.system_key
        , a.effective_date
        , a.reconciliation_frequency
        , a.is_market_day
        , a.is_market_month_end
        , a.cnt
        , a.cnt_prior_day
        , a.cnt_delta
        , a.account_value
        , a.account_value_prior_day
        , a.account_value_delta
        , ovrd_sys_eff.is_excluded
        , ovrd_sys_eff.excluded_reasons
    from data_agg_cte as a
    left join {{ ref('aux__stg_masters_variance_accounts') }} as ovrd_sys_eff
        on a.system_key = ovrd_sys_eff.system_key
        and a.effective_date = ovrd_sys_eff.effective_date
)

-- define thresholds
select *
from data_agg_with_exclusions_cte
where true
    and (
        abs(cnt_delta) > 5
        or abs(account_value_delta) > 5
    )
    and coalesce(is_excluded , 0) = 0
order by system_key asc , effective_date desc
