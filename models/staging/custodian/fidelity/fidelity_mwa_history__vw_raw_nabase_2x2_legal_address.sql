
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 2)), '')                                           as ADDRESS_TYPE
  , nullif(trim(substring(content, 20, 32)), '')                                          as LABEL_LINE_1
  , nullif(trim(substring(content, 52, 32)), '')                                          as LABEL_LINE_2
  , nullif(trim(substring(content, 84, 1)), '')                                           as AUTO_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 85, 1)), '')                                           as NCOA_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 86, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_1
  , nullif(trim(substring(content, 118, 32)), '')                                         as FIXED_FORMAT_ADDRESS_LINE_2
  , nullif(trim(substring(content, 150, 32)), '')                                         as FIXED_FORMAT_ADDRESS_LINE_3
  , nullif(trim(substring(content, 182, 10)), '')                                         as FIXED_FORMAT_PO_BOX
  , nullif(trim(substring(content, 192, 30)), '')                                         as FIXED_FORMAT_CITY_NAME
  , nullif(trim(substring(content, 222, 2)), '')                                          as FIXED_FORMAT_STATE
  , nullif(trim(substring(content, 224, 5)), '')                                          as FIXED_FORMAT_POSTAL_CODE
  , nullif(trim(substring(content, 229, 4)), '')                                          as FIXED_FORMAT_EXTENDED_ZIP
  , nullif(trim(substring(content, 233, 30)), '')                                         as FIXED_FORMAT_PROVINCE
  , nullif(trim(substring(content, 263, 8)), '')                                          as LAST_MAINT_DATE
  , nullif(trim(substring(content, 271, 1)), '')                                          as ADDRESS_FORMAT
  , nullif(trim(substring(content, 272, 3)), '')                                          as STATE_COUNTRY_CODE
  , nullif(trim(substring(content, 275, 50)), '')                                         as COUNTRY_NAME
  , nullif(trim(substring(content, 325, 10)), '')                                         as INTERNATIONAL_PO_CODE
  , nullif(trim(substring(content, 335, 10)), '')                                         as UPDATE_USER
  , nullif(trim(substring(content, 345, 26)), '')                                         as UPDATE_TIME_STAMP
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'nabase') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'nabase') }}
where 1 = 1
  and rlike(left(content, 4), 'D2[0-9]2')