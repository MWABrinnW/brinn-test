
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 9)), '')                                           as FFR_XREF
  , nullif(trim(substring(content, 27, 1)), '')                                           as MAIL_CODE
  , nullif(trim(substring(content, 28, 1)), '')                                           as LEGAL_CODE
  , nullif(trim(substring(content, 29, 1)), '')                                           as AFF_CODE
  , nullif(trim(substring(content, 30, 1)), '')                                           as DAY_TEL_CODE
  , nullif(trim(substring(content, 31, 1)), '')                                           as NTE_TEL_CODE
  , nullif(trim(substring(content, 32, 1)), '')                                           as BOOK_NAME_COUNT
  , nullif(trim(substring(content, 33, 30)), '')                                          as CUST_STATE_ID
  , nullif(trim(substring(content, 63, 1)), '')                                           as CUST_STATE_ID_TYPE
  , nullif(trim(substring(content, 64, 2)), '')                                           as CUST_STATE_ISSUED
  , nullif(trim(substring(content, 66, 1)), '')                                           as BROKER_AFFILIATION_CODE
  , nullif(trim(substring(content, 67, 32)), '')                                          as EMPLOYEE_OCCUPATION
  , nullif(trim(substring(content, 99, 3)), '')                                           as CITIZEN_ORGANIZATION_COUNTRY
  , nullif(trim(substring(content, 102, 8)), '')                                          as LAST_MAINT_DATE
  , nullif(trim(substring(content, 110, 10)), '')                                         as UPDATE_USER_1
  , nullif(trim(substring(content, 120, 26)), '')                                         as UPDATE_TIME_STAMP_1
  , nullif(trim(substring(content, 146, 1)), '')                                          as NAME_FORMAT
  , nullif(trim(substring(content, 147, 10)), '')                                         as FIXED_TITLE_FORMAT_NAME_PREFIX
  , nullif(trim(substring(content, 157, 10)), '')                                         as FIXED_TITLE_FORMAT_NAME_SUFFIX
  , nullif(trim(substring(content, 167, 25)), '')                                         as FIXED_NAME_FORMAT_FIRST
  , nullif(trim(substring(content, 192, 10)), '')                                         as FIXED_NAME_FORMAT_MIDDLE
  , nullif(trim(substring(content, 202, 30)), '')                                         as FIXED_NAME_FORMAT_LAST
  , nullif(trim(substring(content, 232, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE
  , nullif(trim(substring(content, 236, 1)), '')                                          as IRS_CODE
  , nullif(trim(substring(content, 237, 9)), '')                                          as IRS_NO
  , nullif(trim(substring(content, 246, 8)), '')                                          as BIRTH_DATE
  , nullif(trim(substring(content, 254, 1)), '')                                          as TELEPHONE_TYPE_1
  , nullif(trim(substring(content, 255, 1)), '')                                          as TELEPHONE_FORMAT_1
  , nullif(trim(substring(content, 256, 15)), '')                                         as TELEPHONE_NUMBER_1
  , nullif(trim(substring(content, 271, 4)), '')                                          as TELEPHONE_EXTENSION_1
  , nullif(trim(substring(content, 275, 10)), '')                                         as TELEPHONE_PIN_1
  , nullif(trim(substring(content, 285, 20)), '')                                         as CONTACT_NAME_1
  , nullif(trim(substring(content, 305, 5)), '')                                          as PRIORITY_NUMBER_1
  , nullif(trim(substring(content, 310, 10)), '')                                         as UPDATE_USER_2
  , nullif(trim(substring(content, 320, 26)), '')                                         as UPDATE_TIME_STAMP_2
  , nullif(trim(substring(content, 346, 1)), '')                                          as TELEPHONE_TYPE_2
  , nullif(trim(substring(content, 347, 1)), '')                                          as TELEPHONE_FORMAT_2
  , nullif(trim(substring(content, 348, 15)), '')                                         as TELEPHONE_NUMBER_2
  , nullif(trim(substring(content, 363, 4)), '')                                          as TELEPHONE_EXTENSION_2
  , nullif(trim(substring(content, 367, 10)), '')                                         as TELEPHONE_PIN_2
  , nullif(trim(substring(content, 377, 20)), '')                                         as CONTACT_NAME_2
  , nullif(trim(substring(content, 397, 5)), '')                                          as PRIORITY_NUMBER_2
  , nullif(trim(substring(content, 402, 10)), '')                                         as UPDATE_USER_3
  , nullif(trim(substring(content, 412, 26)), '')                                         as UPDATE_TIME_STAMP_3
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'nabase') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'nabase') }}
where 1 = 1
  and rlike(left(content, 4), 'D2[0-9]0')