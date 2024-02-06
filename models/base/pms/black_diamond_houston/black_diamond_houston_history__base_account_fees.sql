{% set src = source('black_diamond_houston', 'accounts') %}

select
    'black_diamond'                               as system_name
    , 'houston'                                   as system_instance
    , concat(system_name , '_' , system_instance) as system_key
    , 'mwa'                                       as firm_source
    , effective_date                              as effective_date
    , json:AccountNumber::string                  as account_number
    , feeschedule.value:FeeScheduleType::string   as fee_schedule_type
    , feeschedule.value:Name::string              as fee_name
    , feeschedule.value:RateType::string          as fee_rate_type
    , record_id                                   as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                             as _source_loaded_at
from {{ src }}
, table(flatten(json , 'FeeSchedules')) as feeschedule
