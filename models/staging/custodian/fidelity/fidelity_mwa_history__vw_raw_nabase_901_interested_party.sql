
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 2)), '')                                           as IPCS_NUMBER_OF_CONFIRMS
  , nullif(trim(substring(content, 20, 2)), '')                                           as IPCS_NO_STATEMENTS
  , nullif(trim(substring(content, 22, 9)), '')                                           as IPCS_ZIP_CODE
  , nullif(trim(substring(content, 31, 3)), '')                                           as STATE_COUNTRY_CODE
  , nullif(trim(substring(content, 34, 1)), '')                                           as LAST_UPDATE_CODE
  , nullif(trim(substring(content, 35, 8)), '')                                           as LAST_UPDATE_DATE
  , nullif(trim(substring(content, 43, 1)), '')                                           as NUMBER_OF_ADDRESS_LINES
  , nullif(trim(substring(content, 44, 32)), '')                                          as IPCS_ADDRESS_LINE_1
  , nullif(trim(substring(content, 76, 32)), '')                                          as IPCS_ADDRESS_LINE_2
  , nullif(trim(substring(content, 108, 32)), '')                                         as IPCS_ADDRESS_LINE_3
  , nullif(trim(substring(content, 140, 32)), '')                                         as IPCS_ADDRESS_LINE_4
  , nullif(trim(substring(content, 172, 32)), '')                                         as IPCS_ADDRESS_LINE_5
  , nullif(trim(substring(content, 204, 32)), '')                                         as IPCS_ADDRESS_LINE_6
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'nabase') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'nabase') }}
where 1 = 1
  and (
        rlike(left(content, 4), 'D90[1-9]')
        or rlike(left(content, 4), 'D9[1-9][0-9]')
        or rlike(left(content, 4), 'D90[1-9]')
    )