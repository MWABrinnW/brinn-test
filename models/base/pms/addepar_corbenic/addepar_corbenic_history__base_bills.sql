{% set src = ref('addepar_corbenic_history__stg_bills') %}

with cte_max_created_at as (
    select
        src.billing_id::varchar(200)     as billing_id
        , max(src._created_at)::datetime as _max_created_at
    from {{ src }} as src
    where true
    group by billing_id
)

select
    src.system_name::varchar(200)                      as system_name
    , src.system_instance::varchar(200)                as system_instance
    , src.system_key::varchar(200)                     as system_key
    , src.firm_source::varchar(200)                    as firm_source
    , src.cwm_custodian::varchar(200)                  as cwm_custodian
    , src.cwm_lead_advisor::varchar(200)               as cwm_lead_advisor
    , src.referral_fee_partner::varchar(200)           as referral_fee_partner
    , src.billing_id::varchar(200)                     as billing_id
    , src.billing_assets_billed_on::decimal(20 , 5)    as billing_assets_billed_on
    , src.billing_bill_to::varchar(200)                as billing_bill_to
    , src.billing_bill_to_account_number::varchar(200) as billing_bill_to_account_number
    , src.billing_date::date                           as billing_date
    , src.billing_effective_rate::decimal(20 , 5)      as billing_effective_rate
    , src.billing_fee_exclusion::varchar(200)          as billing_fee_exclusion
    , src.billing_fee_type::varchar(200)               as billing_fee_type
    , src.billing_fee_value::decimal(20 , 5)           as billing_fee_value
    , src.billing_gross_fee::decimal(20 , 5)           as billing_gross_fee
    , src.billing_prorated_fee::decimal(20 , 5)        as billing_prorated_fee
    , src.billing_schedule_interval::varchar(200)      as billing_schedule_interval
    , src.billing_schedule_timing::varchar(200)        as billing_schedule_timing
    , src.billing_schedule::varchar(200)               as billing_schedule
    , src.holding_account_number::varchar(200)         as holding_account_number
    , src.billing_payment_method::varchar(200)         as billing_payment_method
    , src.inception_event_date::date                   as inception_event_date
    , src.owner::text(200)                             as owner--noqa: RF04
    , src.value::decimal(20 , 5)                       as value--noqa: RF04
    , src.entity_id::text(200)                         as entity_id
    , src.grouping::text(200)                          as grouping--noqa: RF04
    , src.name::text(200)                              as name--noqa: RF04
    , case when src._created_at = mca._max_created_at then 1
        else 0
    end                                                as is_head
    , src._id::int                                     as _id
    , src._created_at::datetime                        as _created_at
    , mca._max_created_at::datetime                    as _max_created_at
    , src._source_file::text(200)                      as _source_file
from {{ src }} as src
left join cte_max_created_at as mca
    on src.billing_id = mca.billing_id
    and src._created_at = mca._max_created_at
