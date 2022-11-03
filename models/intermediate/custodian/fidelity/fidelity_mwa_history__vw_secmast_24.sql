
select
    RECORD_TYPE   as RECORD_TYPE
  , RECORD_NUMBER as RECORD_NUMBER
  , SECURITY_TYPE as SECURITY_TYPE
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_secmast_24') }}