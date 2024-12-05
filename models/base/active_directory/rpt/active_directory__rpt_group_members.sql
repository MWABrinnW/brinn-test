{{ config(
  grants = {'+select': ['db_hr_gen_r', 'db_it_r']}
) }}

with cte_fresh as (
    select
        *
        , {{ col_is_head(
          reference=source('active_directory', 'groups'),
          source_date_col='_effective_at::date',
          reference_date_col='_effective_at::date'
          ) }}
    from {{ ref('active_directory__rpt_group_members_fresh') }}
)

select
    *
    , {{ col_is_head(
        reference=source('active_directory', 'groups'),
        source_date_col='_effective_at::date',
        reference_date_col='_effective_at::date'
        ) }}
from {{ ref('active_directory__rpt_group_members_history') }}
where 1 = 1
    and _effective_at::date
    < coalesce(
        (select min(t._effective_at::date) from cte_fresh as t) , (_effective_at::date + 1)
    )

union all

select *
from cte_fresh
