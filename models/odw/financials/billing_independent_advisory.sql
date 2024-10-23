select
    * exclude (
        fee_schedule , fee_schedule_type , _extra_fields
    )
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_like') }}
where true
    and system_key in ('black_diamond__baystate')
