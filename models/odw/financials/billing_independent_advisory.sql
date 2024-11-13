select
    * exclude (
        fee_schedule , fee_schedule_type
    )
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth') }}
where true
    and system_key in ('black_diamond__baystate' , 'black_diamond__mps')
    or (
        system_key = 'salesforce__compass' and (_extra_fields['is_cpg'] = 1)
    )
