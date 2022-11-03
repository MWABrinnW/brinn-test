select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as LIMITED_PARTNERSHIP_INDICATOR
  , nullif(trim(substring(content, 5, 1)), '')                                             as MASTER_LIMITED_PARTNERSHIP_INDICATOR
  , nullif(trim(substring(content, 6, 1)), '')                                             as UNIT_INVESTMENT_TRUST_INDICATOR
  , nullif(trim(substring(content, 7, 8)), '')                                             as UIT_TERMINATION_DATE
  , nullif(trim(substring(content, 15, 1)), '')                                            as REAL_ESTATE_INVESTMENT_TRUST_INDICATOR
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'secmast') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'secmast') }}
where 1 = 1
  and left(content, 3) = 'D29'