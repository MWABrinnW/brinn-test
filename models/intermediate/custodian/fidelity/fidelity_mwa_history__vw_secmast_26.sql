
select
    RECORD_TYPE                                      as RECORD_TYPE
  , RECORD_NUMBER                                    as RECORD_NUMBER
  , SECURITY_TYPE                                    as SECURITY_TYPE
  , case
        when nvl(IFM_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(IFM_DATE, 'YYYYMMDD') end::date as IFM_DATE
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_secmast_26') }}