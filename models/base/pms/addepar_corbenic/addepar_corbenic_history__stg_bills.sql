{% set src = source('addepar_corbenic', 'bills') %}

select
    'addepar'                                                                                            as system_name
    , 'corbenic'                                                                                         as system_instance
    , concat(system_name , '__' , system_instance)                                                       as system_key
    , 'mwa'                                                                                              as firm_source
    , src._json:columns._custom_cwm_custodian_126441::text(200)                                          as cwm_custodian--noqa: RF03
    , src._json:columns._custom_cwm_lead_advisor_136710::text(200)                                       as cwm_lead_advisor
    , src._json:columns._custom_referral_fee_partner_1060362::text(200)                                  as referral_fee_partner
    {# [comment] if null, partitions by source file for max billing date, used in a group by clause
    in the base bills model to extract the max created date by billing id  #}
    , replace(coalesce(
        src._json:columns.bill_id::text(200)
        , (
            max(src._json:columns.billing_date::date)
                over (partition by src._source_file::varchar(200))
        )::varchar(200)
    ) , '-' , '')::varchar(200)                                                                          as billing_id
    , src._json:columns.billing_assets_billed_on_v2::decimal(20 , 5)
        as billing_assets_billed_on
    , src._json:columns.billing_bill_to::text(200)                                                       as billing_bill_to
    , src._json:columns.billing_bill_to_account_number::text(200)
        as billing_bill_to_account_number
    {# [comment] if null, partitions by source file for max billing date, 
    used to delinate nulls by reporting period #}
    , coalesce(
        src._json:columns.billing_date::date
        , max(src._json:columns.billing_date::date) over (partition by src._source_file::varchar(200))
    )::date                                                                                              as billing_date
    , src._json:columns.billing_effective_rate::decimal(20 , 5)                                          as billing_effective_rate
    , src._json:columns.billing_fee_exclusion::text(200)                                                 as billing_fee_exclusion
    , src._json:columns.billing_fee_type_v2::text(200)                                                   as billing_fee_type
    , src._json:columns.billing_fee_value_v2::decimal(20 , 5)                                            as billing_fee_value
    , src._json:columns.billing_gross_fee_v2::decimal(20 , 5)                                            as billing_gross_fee
    , src._json:columns.billing_prorated_fee_v2::decimal(20 , 5)                                         as billing_prorated_fee
    , src._json:columns.billing_schedule_interval_v2::text(200)
        as billing_schedule_interval
    , src._json:columns.billing_schedule_timing_v2::text(200)
        as billing_schedule_timing
    , src._json:columns.billing_schedule_v2::text(200)                                                   as billing_schedule
    , src._json:columns.bottom_level_holding_account_number::text(200)                                   as holding_account_number
    , src._json:columns.billing_payment_method::text(200)                                                as billing_payment_method
    , src._json:columns.inception_event_date::date                                                       as inception_event_date
    , src._json:columns.top_level_owner::text(200)                                                       as owner--noqa: RF04
    , src._json:columns.value::decimal(20 , 5)                                                           as value--noqa: RF04
    , src._json:entity_id::text(200)                                                                     as entity_id
    , src._json:grouping::text(200)                                                                      as grouping--noqa: RF04
    , src._json:name::text(200)                                                                          as name--noqa: RF04
    , src._id::int                                                                                       as _id
    , src._created_at::datetime                                                                          as _created_at
    , src._source_file::text(200)                                                                        as _source_file
    , max(src._json:columns.billing_date::date) over (partition by src._source_file::varchar(200))::date
        as _max_source_billing_date
from {{ src }} as src
