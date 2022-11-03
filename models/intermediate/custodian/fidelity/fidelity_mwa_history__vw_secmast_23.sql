
select
    RECORD_TYPE                                                   as RECORD_TYPE
  , RECORD_NUMBER                                                 as RECORD_NUMBER
  , SECURITY_TYPE                                                 as SECURITY_TYPE
  , case
        when nvl(INITIAL_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(INITIAL_EXPIRATION_DATE, 'YYMMDD') end::date as INITIAL_EXPIRATION_DATE
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_secmast_23') }}