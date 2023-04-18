{% set src = source('black_diamond_mcgervey', 'accounts') %}

select
  'black_diamond'                            as pms
  , 'mcgervey'                                    as pms_location
  , 'mwa'                                    as firm_source
  , EFFECTIVE_DATE as effective_date
  , JSON:AccountNumber::string as account_number
  , JSON:Id::varchar(50) as account_id
  , feeSchedule.value:FeeScheduleType::string as fee_schedule_type
  , feeSchedule.value:Name::string as fee_name
  , feeSchedule.value:RateType::string as fee_rate_type
  , RECORD_ID as record_id
  , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime as _source_loaded_at
from {{ src }},
  table(flatten(JSON, 'FeeSchedules')) AS feeSchedule

