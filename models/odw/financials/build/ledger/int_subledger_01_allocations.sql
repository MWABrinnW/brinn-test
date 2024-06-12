{{ config(enabled=false) }}

with cte_rev_period_window as (
    select
        max(revenue_period_end_date)   as max_period
        , min(revenue_period_end_date) as min_period
    from {{ ref('billing_wealth') }}
)

, cte_distinct_quarters as (
    select distinct d.quarter_end_date as quarter_end_date
    from cte_rev_period_window as pw
    left join
        {{ ref('dates') }} as d
        on d.date_key between pw.min_period and pw.max_period
)

, cte_quarter_explode as (
    select
        date_trunc(
            'MONTH' , dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date)
        )::date                         as revenue_month_start_date
        , last_day(
            dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date)
        )::date                         as revenue_month_end_date
        , date_trunc(
            'quarter' , dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date)
        )::date                         as revenue_quarter_start_date
        , cte_dq.quarter_end_date::date
            as revenue_quarter_end_date
        , datediff(
            day
            , date_trunc('quarter' , dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date))
            , dateadd(day , 1 , cte_dq.quarter_end_date)
        )::int                          as days_in_quarter
        , datediff(
            day , date_trunc('MONTH' , dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date))
            , dateadd(day , 1 , last_day(dateadd('month' , offsets.months_offset , cte_dq.quarter_end_date))
            )
        )::int                          as days_in_month
    from cte_distinct_quarters as cte_dq
    cross join (values (-2) , (-1) , (0)) as offsets (months_offset)
)

select
    *--noqa: RF02
    , case
        when a.billing_frequency = 'quarterly'
            then (a.client_fee_net * (b.days_in_month / b.days_in_quarter))
        when a.billing_frequency = 'monthly'
            then a.client_fee_net
    end::number(18 , 2) as client_fee_net_allocation
from {{ ref('billing_wealth') }} as a
left join cte_quarter_explode as b
    on
    case
        when a.billing_frequency ilike 'quarterly'
            then a.revenue_period_end_date = b.revenue_quarter_end_date
        when a.billing_frequency ilike 'monthly'
            then a.revenue_period_end_date = b.revenue_month_end_date
    end
order by
    a.system_key asc
    , a._invoice_key asc
    , b.revenue_month_end_date desc
