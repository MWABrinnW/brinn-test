-- transform year and month strings into start and end dates for an fmv 
with trans_cte as (
    select
        f.plan_id
        , f.fmv
        , f.year
        , f.month
        , last_day(try_to_date((f.year || f.month) , 'YYYYMM') , 'month') as start_dt
        , row_number() over (
            partition by f.plan_id
            order by f.plan_id asc , f.year desc , f.month desc
        )                                                                 as rn
        , case
            when row_number()
                    over (
                        partition by f.plan_id
                        order by f.plan_id asc , f.year desc , f.month desc
                    )
                = 1 then null
            else lag(
                    dateadd('day' , -1 , last_day(try_to_date((f.year || f.month) , 'YYYYMM') , 'month'))
                    , 1
                ) over (
                    order by f.plan_id asc , f.year desc , f.month desc
                )
        end                                                               as end_dt
    from {{ ref('cambak__stg_latestfmventry') }} as f
    where true
)

, match_cte as (
    select
        bld.effective_date
        , bld.account_number
        , bld.is_active
        , bld.firm_source
        , bld.system_key
        , bld.account_value                                                                   as bld_value
        , trans.start_dt
        , trans.end_dt
        , trans.fmv                                                                           as trans_value
        , coalesce(trans_value::number(18 , 2) , 0) = coalesce(bld_value::number(18 , 2) , 0) as match_value
    from {{ ref('edw_accounts') }} as bld
    left join trans_cte as trans
        on bld.account_number = trans.plan_id
        and bld.effective_date between trans.start_dt::date and coalesce(trans.end_dt::date , current_date())
    where true
        and bld.system_key = 'cambak__andco'
        and bld.is_institutional = 1
        and bld.is_legacy = 0
    order by bld.account_number asc , bld.effective_date desc
)

select * from match_cte
where match_value = false
