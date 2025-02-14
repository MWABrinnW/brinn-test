select
    b.system_name::varchar(200)                                                        as system_name
    , b.system_instance::varchar(200)                                                  as system_instance
    , b.system_key::varchar(200)                                                       as system_key
    , b.firm_source::varchar(200)                                                      as firm_source
    , b.cwm_custodian::varchar(200)                                                    as cwm_custodian
    , b.cwm_lead_advisor::varchar(200)                                                 as cwm_lead_advisor
    , b.referral_fee_partner::varchar(200)                                             as referral_fee_partner
    , b.billing_id::varchar(200)                                                       as billing_id
    , b.billing_assets_billed_on::decimal(20 , 5)                                      as billing_assets_billed_on
    , b.billing_bill_to::varchar(200)                                                  as billing_bill_to
    , b.billing_bill_to_account_number::varchar(200)                                   as billing_bill_to_account_number
    , b.billing_date::date                                                             as billing_date
    , b.billing_effective_rate::decimal(20 , 5)                                        as billing_effective_rate
    , b.billing_fee_exclusion::varchar(200)                                            as billing_fee_exclusion
    , b.billing_fee_type::varchar(200)                                                 as billing_fee_type
    , b.billing_fee_value::decimal(20 , 5)                                             as billing_fee_value
    , b.billing_gross_fee::decimal(20 , 5)                                             as billing_gross_fee
    , b.billing_prorated_fee::decimal(20 , 5)                                          as billing_prorated_fee
    , b.billing_schedule_interval::varchar(200)                                        as billing_schedule_interval
    , b.billing_schedule_timing::varchar(200)                                          as billing_schedule_timing
    , b.billing_schedule::varchar(200)                                                 as billing_schedule
    , b.account_number_formatted::text(200)                                            as account_number_formatted
    , b.account_number::text(200)                                                      as account_number
    , b.billing_payment_method::varchar(200)                                           as billing_payment_method
    , b.inception_event_date::date                                                     as inception_event_date
    , b.owner::text(200)                                                               as owner--noqa: RF04
    , b.value::decimal(20 , 5)                                                         as value--noqa: RF04
    , b.entity_id::text(200)                                                           as entity_id
    , b.grouping::text(200)                                                            as grouping--noqa: RF04
    , b.name::text(200)                                                                as name--noqa: RF04
    , {{ col_is_head(reference=ref('addepar_corbenic_history__stg_bills')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
    , b._source_file::text(200)                                                        as _source_file
    , b._created_at::datetime                                                          as _created_at
    , max(b.billing_date::date) over (partition by b._source_file::varchar(200))::date
        as _max_billing_date_per_source_file
    , b._id::int                                                                       as _id
from {{ ref('addepar_corbenic_history__stg_bills') }} as b
where true
-- excludes records where a "billing_id" or "billing_date" could not be derived; no records have fees
    and b.billing_id is not null
{# [depulication] source returns identifical "billing_id" (aka runs) files daily; qualify returns
    the most recent file, per "billing_id", per "account_number" #}
qualify max(_created_at) over (
        partition by billing_id , account_number
    )::datetime = _created_at
