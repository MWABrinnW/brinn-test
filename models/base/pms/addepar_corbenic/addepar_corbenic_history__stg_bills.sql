select
    'addepar'                                                               as system_name
    , 'corbenic'                                                            as system_instance
    , concat(system_name , '__' , system_instance)                          as system_key
    , 'mwa'                                                                 as firm_source
    , b._json:columns._custom_cwm_custodian_126441::text(200)               as cwm_custodian--noqa: RF03
    , b._json:columns._custom_cwm_lead_advisor_136710::text(200)            as cwm_lead_advisor
    , b._json:columns._custom_referral_fee_partner_1060362::text(200)       as referral_fee_partner
    {# if null, generates a "billing_id" to group nulls by reporting period, 
    attribute is used in downstream model to return the latest "billing_id" aka run. #}
    , replace(coalesce(
        b._json:columns.bill_id::text(200)
        , (
            max(b._json:columns.billing_date::date)
                over (partition by b._source_file::varchar(200))
        )::varchar(200)
    ) , '-' , '')::varchar(200)                                             as billing_id
    , b._json:columns.billing_assets_billed_on_v2::decimal(20 , 5)
        as billing_assets_billed_on
    , b._json:columns.billing_bill_to::text(200)                            as billing_bill_to
    , b._json:columns.billing_bill_to_account_number::text(200)
        as billing_bill_to_account_number
    {# if null, partitions by source file for max "billing_date", 
    used to delinate nulls by reporting period #}
    , coalesce(
        b._json:columns.billing_date::date
        , max(b._json:columns.billing_date::date) over (partition by b._source_file::varchar(200))
    )::date                                                                 as billing_date
    , b._json:columns.billing_effective_rate::decimal(20 , 5)               as billing_effective_rate
    , b._json:columns.billing_fee_exclusion::text(200)                      as billing_fee_exclusion
    , b._json:columns.billing_fee_type_v2::text(200)                        as billing_fee_type
    , b._json:columns.billing_fee_value_v2::decimal(20 , 5)                 as billing_fee_value
    , b._json:columns.billing_gross_fee_v2::decimal(20 , 5)                 as billing_gross_fee
    , b._json:columns.billing_prorated_fee_v2::decimal(20 , 5)              as billing_prorated_fee
    , b._json:columns.billing_schedule_interval_v2::text(200)
        as billing_schedule_interval
    , b._json:columns.billing_schedule_timing_v2::text(200)
        as billing_schedule_timing
    , b._json:columns.billing_schedule_v2::text(200)                        as billing_schedule
    , upper(b._json:columns.bottom_level_holding_account_number::text(200)) as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(b._json:columns.bottom_level_holding_account_number::text(200)) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                                            as account_number
    , b._json:columns.billing_payment_method::text(200)                     as billing_payment_method
    , b._json:columns.inception_event_date::date                            as inception_event_date
    , b._json:columns.top_level_owner::text(200)                            as owner--noqa: RF04
    , b._json:columns.value::decimal(20 , 5)                                as value--noqa: RF04
    , b._json:entity_id::text(200)                                          as entity_id
    , b._json:grouping::text(200)                                           as grouping--noqa: RF04
    , b._json:name::text(200)                                               as name--noqa: RF04
    , b._id::int                                                            as _id
    , b._created_at::datetime                                               as _created_at
    , b._source_file::text(200)                                             as _source_file
from {{ source('addepar_corbenic', 'bills') }} as b
where true
