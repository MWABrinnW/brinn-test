{%- macro fidelity_nabase_104_telephone_and_bank(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                              as RECORD_TYPE
  , RECORD_NUMBER                            as RECORD_NUMBER
  , FIRM                                     as FIRM
  , BRANCH                                   as BRANCH
  , ACCOUNT_NUMBER                           as ACCOUNT_NUMBER
  , CALL_BACK_NO_1                           as CALL_BACK_NO_1
  , CALL_BACK_NAME_1                         as CALL_BACK_NAME_1
  , AUTHORIZED_TRADER_FIXED_FORMAT_INDICATOR as AUTHORIZED_TRADER_FIXED_FORMAT_INDICATOR
  , TRADING_AUTH_CODE_1                      as TRADING_AUTH_CODE_1
  , TRADING_AUTH_NAME_1                      as TRADING_AUTH_NAME_1
  , TRADING_AUTH_CODE_2                      as TRADING_AUTH_CODE_2
  , TRADING_AUTH_NAME_2                      as TRADING_AUTH_NAME_2
  , TRADING_AUTH_CODE_3                      as TRADING_AUTH_CODE_3
  , TRADING_AUTH_NAME_3                      as TRADING_AUTH_NAME_3
  , CALL_BACK_NO_2                           as CALL_BACK_NO_2
  , CALL_BACK_NAME_2                         as CALL_BACK_NAME_2
  , RT_ABA_NO_BASE                           as RT_ABA_NO_BASE
  , CUSTOMER_BANK_ACCOUNT_NO                 as CUSTOMER_BANK_ACCOUNT_NO
  , ACH_ACCOUNT_TYPE                         as ACH_ACCOUNT_TYPE
  , CORE_SYMBOL                              as CORE_SYMBOL
  , is_head
  , is_current
  , effective_date
  , _created_at
  , _source_file
from {{ src }}
{%- endmacro -%}