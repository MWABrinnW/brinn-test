select
    basecapacity::integer                           as base_capacity
    , externalplanid::text                          as external_plan_id
    , feetargetamount::text                         as fee_target_amount
    , to_boolean(feetargetautoincrement::text)::int as fee_target_auto_increment
    , feetargetend::text                            as fee_target_end
    , feetargetnote::text                           as fee_target_note
    , feetargetstart::text                          as fee_target_start
    , to_boolean(feetargetusesbps::text)::int       as fee_target_uses_bps
    , mtgfrequency::integer                         as mtg_frequency
    , mtgfrquencynotes::text                        as mtg_frquency_notes
    , to_boolean(newassignment::text)::int          as new_assignment
    , plancapacityid::integer                       as plan_capacity_id
    , planid::integer                               as plan_id
    , portfoliocomplexity::integer                  as portfolio_complexity
    , to_boolean(recordedexternally::text)::int     as recorded_externally
    , relationshipcomplexity::integer               as relationship_complexity
    , to_boolean(requirestravel::text)::int         as requires_travel
    , svcmodifier::integer                          as svc_modifier
    , svcmodifiernote::text                         as svc_modifier_note
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                               as _extracted_at
    , file_type::text                               as file_type
    , _created_at::timestamp                        as _created_at
    , _source_file::text                            as _source_file
from {{ source('cambak', 'cbplancapacitycomplexity') }}
