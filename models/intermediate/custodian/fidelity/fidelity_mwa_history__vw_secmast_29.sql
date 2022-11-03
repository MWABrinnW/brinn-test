
select
    RECORD_TYPE                                                  as RECORD_TYPE
  , RECORD_NUMBER                                                as RECORD_NUMBER
  , SECURITY_TYPE                                                as SECURITY_TYPE
  , LIMITED_PARTNERSHIP_INDICATOR                                as LIMITED_PARTNERSHIP_INDICATOR
  , MASTER_LIMITED_PARTNERSHIP_INDICATOR                         as MASTER_LIMITED_PARTNERSHIP_INDICATOR
  , UNIT_INVESTMENT_TRUST_INDICATOR                              as UNIT_INVESTMENT_TRUST_INDICATOR
  , case
        when nvl(UIT_TERMINATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(UIT_TERMINATION_DATE, 'MMDDYYYY') end::date as UIT_TERMINATION_DATE
  , REAL_ESTATE_INVESTMENT_TRUST_INDICATOR                       as REAL_ESTATE_INVESTMENT_TRUST_INDICATOR
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_secmast_29') }}