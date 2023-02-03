{%- macro fidelity_raw_nabase_115_account_legal(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 1)), '')                                           as AUTO_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 19, 2)), '')                                           as ADDRESS_TYPE
  , nullif(trim(substring(content, 21, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_1
  , nullif(trim(substring(content, 53, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_2
  , nullif(trim(substring(content, 85, 32)), '')                                          as FIXED_FORMAT_ADDRESS_LINE_3
  , nullif(trim(substring(content, 117, 32)), '')                                         as FIXED_FORMAT_CITY_NAME
  , nullif(trim(substring(content, 149, 2)), '')                                          as FIXED_FORMAT_STATE
  , nullif(trim(substring(content, 151, 5)), '')                                          as FIXED_FORMAT_POSTAL_CODE
  , nullif(trim(substring(content, 156, 4)), '')                                          as FIXED_FORMAT_EXTENDED_ZIP
  , nullif(trim(substring(content, 160, 15)), '')                                         as FIXED_FORMAT_PROVINCE
  , nullif(trim(substring(content, 175, 29)), '')                                         as COUNTRY_NAME
  , nullif(trim(substring(content, 204, 3)), '')                                          as STATE_COUNTRY_CODE
  , nullif(trim(substring(content, 207, 10)), '')                                         as UPDATE_USER
  , nullif(trim(substring(content, 217, 8)), '')                                          as LAST_UPDATE_DATE
  , nullif(trim(substring(content, 225, 2)), '')                                          as SEASONAL_ADDRESS_TYPE_CODE
  , nullif(trim(substring(content, 227, 1)), '')                                          as SEASONAL_ADDRESS_STATUS_CODE
  , nullif(trim(substring(content, 228, 8)), '')                                          as SEASONAL_ADDRESS_START_DATE
  , nullif(trim(substring(content, 236, 8)), '')                                          as SEASONAL_ADDRESS_END_DATE
  , nullif(trim(substring(content, 244, 1)), '')                                          as SEASONAL_ADDRESS_AUTO_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 245, 1)), '')                                          as SEASONAL_ADDRESS_NCOA_ADDRESS_UPDATE_INDICATOR
  , nullif(trim(substring(content, 246, 32)), '')                                         as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_1
  , nullif(trim(substring(content, 278, 32)), '')                                         as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_2
  , nullif(trim(substring(content, 310, 32)), '')                                         as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_3
  , nullif(trim(substring(content, 342, 1)), '')                                          as SEASONAL_ADDRESS_FOREIGN_ADDRESS_CODE
  , nullif(trim(substring(content, 343, 30)), '')                                         as SEASONAL_ADDRESS_FIXED_FORMAT_CITY_NAME
  , nullif(trim(substring(content, 373, 2)), '')                                          as SEASONAL_ADDRESS_FIXED_FORMAT_STATE
  , nullif(trim(substring(content, 375, 9)), '')                                          as SEASONAL_ADDRESSFIXED_FORMAT_POSTAL_CODE
  , nullif(trim(substring(content, 384, 15)), '')                                         as SEASONAL_ADDRESS_FIXED_FORMAT_PROVINCE
  , nullif(trim(substring(content, 399, 3)), '')                                          as SEASONAL_ADDRESS_STATE_COUNTRY_CODE
  , nullif(trim(substring(content, 402, 10)), '')                                         as SEASONAL_ADDRESS_UPDATE_USER
  , nullif(trim(substring(content, 412, 8)), '')                                          as SEASONAL_ADDRESS_LAST_UPDATE_DATE
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _created_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 4) = 'D115'
{%- endmacro -%}