select
    * exclude (
        fee_schedule , fee_schedule_type , _extra_fields
    )
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_like') }}
union all
select
    * exclude (
        fee_schedule , fee_schedule_type , _extra_fields
    )
    , 1::int as is_legacy
from {{ ref('stg_bills_legacy_wealth') }}
where true
    and system_key in (
        'addepar__corbenic'
        , 'black_diamond__houston'
        , 'black_diamond__uhnw'
        , 'salesforce__compass'
        , 'sei__manasquan'
        , 'envestnet__manasquan'
    )
