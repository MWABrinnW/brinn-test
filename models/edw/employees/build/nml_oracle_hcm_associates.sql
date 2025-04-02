{{ config(
    grants = {'select': ['engineering', 'security', 'datamanagement']}
) }}

with max_ts_from_source as (
    select max(effective_at) as effective_at
    from {{ ref('hcm__stg_employee_demographics') }}
)

select
    a.*
    , case
        when a.effective_at = b.effective_at
            then 1
        else 0
    end::int as is_head
from {{ ref('nml_oracle_hcm_associates_fresh') }} as a
left join max_ts_from_source as b
    on a.effective_at = b.effective_at

union all

select
    a.*
    , case
        when a.effective_at = b.effective_at
            then 1
        else 0
    end::int as is_head
from {{ ref('nml_oracle_hcm_associates_history') }} as a
left join max_ts_from_source as b
    on a.effective_at = b.effective_at
