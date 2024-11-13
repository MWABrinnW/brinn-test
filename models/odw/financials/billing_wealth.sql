with cte_union as (
    select
        *
        , 0::int as is_legacy
    from {{ ref('bld_billing_wealth') }}
    union all
    select
        *
        , 1::int as is_legacy
    from {{ ref('stg_bills_legacy_wealth') }}
)

select
    *
    exclude (
        fee_schedule , fee_schedule_type
    )
from cte_union
where true
    and system_key in (
        'addepar__corbenic'
        , 'black_diamond__houston'
        , 'black_diamond__uhnw'
        , 'sei__manasquan'
        , 'envestnet__manasquan'
    )
    or (
        system_key = 'salesforce__compass' and (_extra_fields['is_cpg'] = 0)
    )
    or is_legacy = 1
