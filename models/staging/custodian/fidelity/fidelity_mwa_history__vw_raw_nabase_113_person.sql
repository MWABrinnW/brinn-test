
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 4)), '')                                           as FFR_NAME_COUNT
  , nullif(trim(substring(content, 22, 1)), '')                                           as FIXED_FORMAT_NAME_TYPE_1
  , nullif(trim(substring(content, 23, 1)), '')                                           as FIXED_FORMAT_PRIMARY_NAME_CODE_1
  , nullif(trim(substring(content, 24, 12)), '')                                          as FIXED_FORMAT_FIRST_NAME_1
  , nullif(trim(substring(content, 36, 10)), '')                                          as FIXED_FORMAT_MIDDLE_NAME_1
  , nullif(trim(substring(content, 46, 25)), '')                                          as FIXED_FORMAT_LAST_NAME_1
  , nullif(trim(substring(content, 71, 10)), '')                                          as FIXED_FORMAT_NAME_TITLE_PREFIX_1
  , nullif(trim(substring(content, 81, 10)), '')                                          as FIXED_FORMAT_NAME_TITLE_SUFFIX_1
  , nullif(trim(substring(content, 91, 8)), '')                                           as FIXED_FORMAT_DATE_OF_BIRTH_1
  , nullif(trim(substring(content, 99, 8)), '')                                           as FFR_DATE_OF_DEATH_1
  , nullif(trim(substring(content, 107, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE_1
  , nullif(trim(substring(content, 111, 9)), '')                                          as FIXED_FORMAT_SSN_NUMBER_1
  , nullif(trim(substring(content, 120, 1)), '')                                          as FIXED_FORMAT_SSN_CODE_1
  , nullif(trim(substring(content, 121, 9)), '')                                          as FFR_XREF_1
  , nullif(trim(substring(content, 130, 8)), '')                                          as FFR_CUSTOMER_ESTABLISH_DATE_1
  , nullif(trim(substring(content, 138, 1)), '')                                          as FIXED_FORMAT_NAME_TYPE_2
  , nullif(trim(substring(content, 139, 1)), '')                                          as FIXED_FORMAT_PRIMARY_NAME_CODE_2
  , nullif(trim(substring(content, 140, 12)), '')                                         as FIXED_FORMAT_FIRST_NAME_2
  , nullif(trim(substring(content, 152, 10)), '')                                         as FIXED_FORMAT_MIDDLE_NAME_2
  , nullif(trim(substring(content, 162, 25)), '')                                         as FIXED_FORMAT_LAST_NAME_2
  , nullif(trim(substring(content, 187, 10)), '')                                         as FIXED_FORMAT_NAME_TITLE_PREFIX_2
  , nullif(trim(substring(content, 197, 10)), '')                                         as FIXED_FORMAT_NAME_TITLE_SUFFIX_2
  , nullif(trim(substring(content, 207, 8)), '')                                          as FIXED_FORMAT_DATE_OF_BIRTH_2
  , nullif(trim(substring(content, 215, 8)), '')                                          as FFR_DATE_OF_DEATH_2
  , nullif(trim(substring(content, 223, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE_2
  , nullif(trim(substring(content, 227, 9)), '')                                          as FIXED_FORMAT_SSN_NUMBER_2
  , nullif(trim(substring(content, 236, 1)), '')                                          as FIXED_FORMAT_SSN_CODE_2
  , nullif(trim(substring(content, 237, 9)), '')                                          as FFR_XREF_2
  , nullif(trim(substring(content, 246, 8)), '')                                          as FFR_CUSTOMER_ESTABLISH_DATE_2
  , nullif(trim(substring(content, 254, 1)), '')                                          as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_1
  , nullif(trim(substring(content, 255, 1)), '')                                          as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_2
  , case when effective_date = (select max(effective_date) from {{ source('fidelity_mwa', 'nabase') }}) then 1 else 0 end as is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ source('fidelity_mwa', 'nabase') }}
where 1 = 1
  and left(content, 4) = 'D113'
  and substring(content, 22, 1) = 'P'