select
    * exclude (
        fee_schedule , fee_schedule_type
    )
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth') }}
{# union
select
    * exclude (
        fee_schedule , fee_schedule_type
    )
    , 1::int as is_legacy
from {{ ref('stg_bills_legacy_wealth') }}
where true
    and is_excluded = 0 #}
