{%- set history_relation = 'schwab__base_cash_history' %}
{%- set fresh_relation = 'schwab__base_cash_fresh' %}

with max_effective_dates as (
    select max(effective_date) as effective_date
    from {{ ref(history_relation) }}
    group by all

    union all

    select max(effective_date) as effective_date
    from {{ ref(fresh_relation) }}
    group by all
)

, head_date as (
    select max(effective_date) as effective_date from max_effective_dates
)

select
    a.*
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int as is_head
from {{ ref(fresh_relation) }} as a
left join head_date as b
    on a.effective_date = b.effective_date

union all

select
    a.*
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int as is_head
from {{ ref(history_relation) }} as a
left join head_date as b
    on a.effective_date = b.effective_date
