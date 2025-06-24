{{ config(
  grants = {'+select': ['db_hr_gen_r', 'db_it_r']}
) }}

{%- set history_relation = 'active_directory__rpt_users_history' %}
{%- set fresh_relation = 'active_directory__rpt_users_fresh' %}

with max_effective_dates as (
    select max(_effective_at::date) as effective_date
    from {{ ref(history_relation) }}
    group by all

    union all

    select max(_effective_at::date) as effective_date
    from {{ ref(fresh_relation) }}
    group by all
)

, head_date as (
    select max(effective_date) as effective_date from max_effective_dates
)

select
    a.*
    , case
        when a._effective_at::date = b.effective_date
            then 1
        else 0
    end::int as is_head
from {{ ref(fresh_relation) }} as a
left join head_date as b
    on a._effective_at::date = b.effective_date

union all

select
    a.*
    , case
        when a._effective_at::date = b.effective_date
            then 1
        else 0
    end::int as is_head
from {{ ref(history_relation) }} as a
left join head_date as b
    on a._effective_at::date = b.effective_date
