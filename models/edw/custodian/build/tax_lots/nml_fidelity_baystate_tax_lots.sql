{%- set instance = 'baystate' %}

with max_effective_dates as (
    select max(effective_date) as effective_date
    from {{ ref('nml_fidelity_' ~ instance ~ '_tax_lots_history') }}
    group by all

    union all

    select max(effective_date) as effective_date
    from {{ ref('nml_fidelity_' ~ instance ~ '_tax_lots_fresh') }}
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
from {{ ref('nml_fidelity_' ~ instance ~ '_tax_lots_fresh') }} as a
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
from {{ ref('nml_fidelity_' ~ instance ~ '_tax_lots_history') }} as a
left join head_date as b
    on a.effective_date = b.effective_date
