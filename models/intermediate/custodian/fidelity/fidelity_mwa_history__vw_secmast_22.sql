
select
    RECORD_TYPE               as RECORD_TYPE
  , RECORD_NUMBER             as RECORD_NUMBER
  , SECURITY_TYPE             as SECURITY_TYPE
  , CLOSED_END_FUND_INDICATOR as CLOSED_END_FUND_INDICATOR
  , EXCHANGE_TRADED           as EXCHANGE_TRADED
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_secmast_22') }}