
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as CLOSED_END_FUND_INDICATOR
  , nullif(trim(substring(content, 5, 1)), '')                                             as EXCHANGE_TRADED_FUND_INDICATOR
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'secmast') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'secmast') }}
where 1 = 1
  and left(content, 3) = 'D21'