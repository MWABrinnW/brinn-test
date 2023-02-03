{%- macro fidelity_raw_nabase_104_telephone_and_bank(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 10)), '')                                          as CALL_BACK_NO_1
  , nullif(trim(substring(content, 28, 20)), '')                                          as CALL_BACK_NAME_1
  , nullif(trim(substring(content, 48, 1)), '')                                           as AUTHORIZED_TRADER_FIXED_FORMAT_INDICATOR
  , nullif(trim(substring(content, 49, 1)), '')                                           as TRADING_AUTH_CODE_1
  , nullif(trim(substring(content, 50, 32)), '')                                          as TRADING_AUTH_NAME_1
  , nullif(trim(substring(content, 82, 1)), '')                                           as TRADING_AUTH_CODE_2
  , nullif(trim(substring(content, 83, 32)), '')                                          as TRADING_AUTH_NAME_2
  , nullif(trim(substring(content, 115, 1)), '')                                          as TRADING_AUTH_CODE_3
  , nullif(trim(substring(content, 116, 32)), '')                                         as TRADING_AUTH_NAME_3
  , nullif(trim(substring(content, 148, 10)), '')                                         as CALL_BACK_NO_2
  , nullif(trim(substring(content, 158, 20)), '')                                         as CALL_BACK_NAME_2
  , nullif(trim(substring(content, 178, 9)), '')                                          as RT_ABA_NO_BASE
  , nullif(trim(substring(content, 187, 17)), '')                                         as CUSTOMER_BANK_ACCOUNT_NO
  , nullif(trim(substring(content, 204, 1)), '')                                          as ACH_ACCOUNT_TYPE
  , nullif(trim(substring(content, 205, 9)), '')                                          as CORE_SYMBOL
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _created_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 4) = 'D104'
{%- endmacro -%}