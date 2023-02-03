{%- macro fidelity_raw_nabase_102_business(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 1)), '')                                           as EXCEPTION_REGISTRATION_INDICATOR
  , nullif(trim(substring(content, 19, 8)), '')                                           as FIXED_FORMAT_TRUST_DATE
  , nullif(trim(substring(content, 27, 2)), '')                                           as MINOR_RESIDENCE_STATE
  , nullif(trim(substring(content, 29, 1)), '')                                           as AUTO_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 30, 1)), '')                                           as NCOA_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 31, 1)), '')                                           as FOREIGN_ADDRESS_CODE
  , nullif(trim(substring(content, 32, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_1
  , nullif(trim(substring(content, 64, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_2
  , nullif(trim(substring(content, 96, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_3
  , nullif(trim(substring(content, 128, 30)), '')                                         as FIXED_FORMAT_CITY_NAME
  , nullif(trim(substring(content, 158, 2)), '')                                          as FIXED_FORMAT_STATE
  , nullif(trim(substring(content, 160, 9)), '')                                          as FIXED_FORMAT_POSTAL_CODE
  , nullif(trim(substring(content, 169, 3)), '')                                          as STATE_COUNTRY_CODE
  , nullif(trim(substring(content, 172, 15)), '')                                         as FIXED_FORMAT_PROVINCE
  , nullif(trim(substring(content, 187, 4)), '')                                          as FFR_NAME_COUNT
  , nullif(trim(substring(content, 191, 1)), '')                                          as FIXED_FORMAT_NAME_TYPE_1
  , nullif(trim(substring(content, 192, 1)), '')                                          as FIXED_FORMAT_PRIMARY_NAME_CODE_1
  , nullif(trim(substring(content, 193, 50)), '')                                         as FIXED_FORMAT_BUSINESS_TRUST_NAME_1
  , nullif(trim(substring(content, 276, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE_1
  , nullif(trim(substring(content, 280, 9)), '')                                          as FIXED_FORMAT_SSN_NUMBER_1
  , nullif(trim(substring(content, 289, 1)), '')                                          as FIXED_FORMAT_SSN_CODE_1
  , nullif(trim(substring(content, 290, 9)), '')                                          as FFR_XREF_1
  , nullif(trim(substring(content, 299, 8)), '')                                          as FFR_CUSTOMER_ESTABLISH_DATE_1
  , nullif(trim(substring(content, 307, 1)), '')                                          as FIXED_FORMAT_NAME_TYPE_2
  , nullif(trim(substring(content, 308, 1)), '')                                          as FIXED_FORMAT_PRIMARY_NAME_CODE_2
  , nullif(trim(substring(content, 309, 50)), '')                                         as FIXED_FORMAT_BUSINESS_TRUST_NAME_2
  , nullif(trim(substring(content, 392, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE_2
  , nullif(trim(substring(content, 396, 9)), '')                                          as FIXED_FORMAT_SSN_NUMBER_2
  , nullif(trim(substring(content, 405, 1)), '')                                          as FIXED_FORMAT_SSN_CODE_2
  , nullif(trim(substring(content, 406, 9)), '')                                          as FFR_XREF_2
  , nullif(trim(substring(content, 415, 8)), '')                                          as FFR_CUSTOMER_ESTABLISH_DATE_2
  , nullif(trim(substring(content, 423, 1)), '')                                          as FIXED_FORMAT_NAME_TYPE_3
  , nullif(trim(substring(content, 424, 1)), '')                                          as FIXED_FORMAT_PRIMARY_NAME_CODE_3
  , nullif(trim(substring(content, 425, 50)), '')                                         as FIXED_FORMAT_BUSINESS_TRUST_NAME_3
  , nullif(trim(substring(content, 508, 4)), '')                                          as FIXED_FORMAT_RELATIONSHIP_CODE_3
  , nullif(trim(substring(content, 512, 9)), '')                                          as FIXED_FORMAT_SSN_NUMBER_3
  , nullif(trim(substring(content, 521, 1)), '')                                          as FIXED_FORMAT_SSN_CODE_3
  , nullif(trim(substring(content, 522, 9)), '')                                          as FFR_XREF_3
  , nullif(trim(substring(content, 531, 8)), '')                                          as FFR_CUSTOMER_ESTABLISH_DATE_3
  , nullif(trim(substring(content, 539, 1)), '')                                          as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_1
  , nullif(trim(substring(content, 540, 1)), '')                                          as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_2
  , nullif(trim(substring(content, 541, 1)), '')                                          as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_3
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _created_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 4) = 'D102'
  and substring(content, 191, 1) = 'B'
{%- endmacro -%}