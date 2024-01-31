select
    _json:columns._custom_cwm_custodian_126441::text(200)           as cwm_custodian
    , _json:columns._custom_cwm_lead_advisor_136710::text(200)      as cwm_lead_advisor
    , _json:columns._custom_referral_fee_partner_1060362::text(200) as referral_fee_partner
    , _json:columns.bill_id::text(200)                              as billing_id
    , _json:columns.billing_assets_billed_on_v2::decimal(20 , 5)    as billing_assets_billed
    , _json:columns.billing_bill_to::text(200)                      as billing_bill_to
    , _json:columns.billing_bill_to_account_number::text(200)       as billing_bill_to_account_number
    , _json:columns.billing_date::date                              as billing_date
    , _json:columns.billing_effective_rate::decimal(20 , 5)         as billing_effective_rate
    , _json:columns.billing_fee_exclusion::text(200)                as billing_fee_exclusion
    , _json:columns.billing_fee_type_v2::text(200)                  as billing_fee_type
    , _json:columns.billing_fee_value_v2::decimal(20 , 5)           as billing_fee_value
    , _json:columns.billing_gross_fee_v2::decimal(20 , 5)           as billing_gross_fee
    , _json:columns.billing_prorated_fee_v2::decimal(20 , 5)        as billing_prorated_fee
    , _json:columns.billing_schedule_interval_v2::text(200)         as billing_schedule_interval
    , _json:columns.billing_schedule_timing_v2::text(200)           as billing_schedule_timing
    , _json:columns.bottom_level_holding_account_number::text(200)  as holding_account_number
    , _json:columns.inception_event_date::date                      as inception_event_date
    , _json:columns.top_level_owner::text(200)                      as owner
    , _json:columns.value::decimal(20 , 5)                          as value
    , _json:entity_id::text(200)                                    as entity_id
    , _json:grouping::text(200)                                     as grouping
    , _json:name::text(200)                                         as name
    , _created_at::datetime                                         as _created_at
    , _source_file::text(200)                                       as _source_file
from {{ source('addepar_corbenic', 'bills') }}
