{% set src = source('black_diamond_mps', 'accounts') %}

select
    'black_diamond'                                as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mps'                                        as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , feeschedule.value:FeeScheduleType::string    as fee_schedule_type
    , feeschedule.value:Name::string               as fee_name
    , feeschedule.value:RateType::string           as fee_rate_type
    , a.record_id                                  as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , a.record_datetime                            as _source_loaded_at
from {{ src }} as a
, table(flatten(a.json , 'FeeSchedules')) as feeschedule
