select
    * exclude (
        fee_schedule , fee_schedule_type , _extra_fields
    )
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth') }}
union all
select
    * exclude (
        fee_schedule , fee_schedule_type , _extra_fields
    )
    , 1::int as is_legacy
from {{ ref('stg_bills_legacy_wealth') }}
where true
