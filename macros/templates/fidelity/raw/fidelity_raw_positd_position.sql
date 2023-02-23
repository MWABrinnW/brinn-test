{%- macro fidelity_raw_positd_position(src) -%}
select
    trim(substring(content, 7, 3)) || trim(substring(content, 10, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 7, 3)) || '-' || trim(substring(content, 10, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 2, 1)), '')                                            as POSITION_DELTA_INDICATOR
  , nullif(trim(substring(content, 3, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 7, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 10, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 16, 1)), '')                                           as ACCOUNT_TYPE
  , nullif(trim(substring(content, 19, 9)), '')                                           as CUSIP
  , nullif(trim(substring(content, 29, 1)), '')                                           as SECURITY_TYPE
  , nullif(trim(substring(content, 30, 1)), '')                                           as SECURITY_TYPE_MODIFIER
  , nullif(trim(substring(content, 31, 1)), '')                                           as PRIMARY_EXCHANGE
  , nullif(trim(substring(content, 33, 1)), '')                                           as DTC_ELIGIBILITY_CODE
  , nullif(trim(substring(content, 35, 3)), '')                                           as REGISTERED_REP_OWNING_REP_RR
  , nullif(trim(substring(content, 38, 6)), '')                                           as MARGIN_LAST_ACTIVITY_DATE
  , nullif(trim(substring(content, 44, 6)), '')                                           as STOCK_RECORD_LAST_ACTIVITY_DATE
  , nullif(trim(substring(content, 50, 9)), '')                                           as SYMBOL
  , nullif(trim(substring(content, 59, 18)), '')                                          as MARKET_PRICE
  , nullif(trim(substring(content, 77, 1)), '')                                           as POSITION_FIELD_SIGN_1
  , nullif(trim(substring(content, 78, 18)), '')                                          as TRADE_DATE_QUANTITY
  , nullif(trim(substring(content, 96, 1)), '')                                           as POSITION_FIELD_SIGN_2
  , nullif(trim(substring(content, 97, 8)), '')                                           as OPTION_STRIKE_PRICE
  , nullif(trim(substring(content, 105, 18)), '')                                         as SETTLEMENT_DATE_QUANTITY
  , nullif(trim(substring(content, 123, 1)), '')                                          as POSITION_FIELD_SIGN_3
  , nullif(trim(substring(content, 124, 18)), '')                                         as SEGREGATED_QUANTITY
  , nullif(trim(substring(content, 142, 1)), '')                                          as POSITION_FIELD_SIGN_4
  , nullif(trim(substring(content, 143, 18)), '')                                         as TRANSIT_QUANTITY
  , nullif(trim(substring(content, 161, 1)), '')                                          as POSITION_FIELD_SIGN_5
  , nullif(trim(substring(content, 162, 18)), '')                                         as TRANSFER_QUANTITY
  , nullif(trim(substring(content, 180, 1)), '')                                          as POSITION_FIELD_SIGN_6
  , nullif(trim(substring(content, 181, 18)), '')                                         as LEGAL_TRANSFER_QUANTITY
  , nullif(trim(substring(content, 199, 1)), '')                                          as POSITION_FIELD_SIGN_7
  , nullif(trim(substring(content, 200, 18)), '')                                         as NON_NEGOTIABLE_QUANTITY
  , nullif(trim(substring(content, 218, 1)), '')                                          as POSITION_FIELD_SIGN_8
  , nullif(trim(substring(content, 219, 18)), '')                                         as TRADE_DATE_SHORT_SALE_QUANTITY
  , nullif(trim(substring(content, 237, 1)), '')                                          as POSITION_FIELD_SIGN_9
  , nullif(trim(substring(content, 238, 18)), '')                                         as SETTLEMENT_DATE_SHORT_SALE_QUANTITY
  , nullif(trim(substring(content, 256, 1)), '')                                          as POSITION_FIELD_SIGN_10
  , nullif(trim(substring(content, 257, 17)), '')                                         as MTD_POSITION_TRADE_DATE_BALANCE
  , nullif(trim(substring(content, 274, 1)), '')                                          as POSITION_FIELD_SIGN_11
  , nullif(trim(substring(content, 275, 17)), '')                                         as MTD_POSITION_SETTLEMENT_DATE_BALANCE
  , nullif(trim(substring(content, 292, 1)), '')                                          as POSITION_FIELD_SIGN_12
  , nullif(trim(substring(content, 293, 11)), '')                                         as MTD_TRADE_DATE_POSITION_COMMISSION
  , nullif(trim(substring(content, 304, 1)), '')                                          as POSITION_FIELD_SIGN_13
  , nullif(trim(substring(content, 305, 11)), '')                                         as MTD_SETTLE_DATE_POSITION_COMMISSION
  , nullif(trim(substring(content, 316, 1)), '')                                          as POSITION_FIELD_SIGN_14
  , nullif(trim(substring(content, 317, 5)), '')                                          as COUPON_RATE
  , nullif(trim(substring(content, 322, 1)), '')                                          as POSITION_FIELD_SIGN_15
  , nullif(trim(substring(content, 324, 1)), '')                                          as NUMBER_OF_SECURITY_DESCRIPTION_LINES
  , nullif(trim(substring(content, 325, 10)), '')                                         as SHORT_NAME
  , nullif(trim(substring(content, 335, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_1
  , nullif(trim(substring(content, 355, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_2
  , nullif(trim(substring(content, 375, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_3
  , nullif(trim(substring(content, 395, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_4
  , nullif(trim(substring(content, 415, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_5
  , nullif(trim(substring(content, 435, 20)), '')                                         as SECURITY_DESCRIPTION_LINE_6
  , nullif(trim(substring(content, 455, 1)), '')                                          as DIVIDEND_INSTRUCTION_CODE
  , nullif(trim(substring(content, 456, 1)), '')                                          as SHORT_TERM_CAPITAL_GAINS_INSTRUCTION_CODE
  , nullif(trim(substring(content, 457, 1)), '')                                          as LONG_TERM_CAPITAL_GAINS_INSTRUCTION_CODE
  , nullif(trim(substring(content, 458, 6)), '')                                          as DIVIDEND_CAPITAL_GAINS_UPDATE_DATE
  , nullif(trim(substring(content, 464, 10)), '')                                         as DIVIDEND_CAPITAL_GAINS_UPDATE_USER_ID
  , nullif(trim(substring(content, 487, 17)), '')                                         as MTD_POSITION_INCOME_TRADE_DATE
  , nullif(trim(substring(content, 504, 1)), '')                                          as POSITION_FIELD_SIGN_16
  , nullif(trim(substring(content, 505, 17)), '')                                         as MTD_POSITION_INCOME_SETTLE_DATE
  , nullif(trim(substring(content, 522, 1)), '')                                          as POSITION_FIELD_SIGN_17
  , nullif(trim(substring(content, 523, 3)), '')                                          as REGISTERED_REP_EXEC_REP_RR2
  , nullif(trim(substring(content, 526, 8)), '')                                          as AGENCY_CODE
  , nullif(trim(substring(content, 534, 12)), '')                                         as PRODUCT_CODE
  , nullif(trim(substring(content, 546, 8)), '')                                          as MATURITY_DATE
  , nullif(trim(substring(content, 554, 13)), '')                                         as CASH_AVAILABLE_TO_PAY
  , nullif(trim(substring(content, 567, 1)), '')                                          as POSITION_FIELD_SIGN_18
  , nullif(trim(substring(content, 568, 1)), '')                                          as MULTI_CURRENCY_INDICATOR
  , nullif(trim(substring(content, 569, 17)), '')                                         as POSITION_MARKET_VALUE
  , nullif(trim(substring(content, 586, 1)), '')                                          as POSITION_FIELD_SIGN_19
  , nullif(trim(substring(content, 587, 10)), '')                                         as CURRENT_FACTOR_AMOUNT
  , nullif(trim(substring(content, 597, 1)), '')                                          as UNFACTORED_PRICE_SIGN
  , nullif(trim(substring(content, 598, 18)), '')                                         as UNFACTORED_PRICE
  , nullif(trim(substring(content, 616, 1)), '')                                          as CPI_RATIO_SIGN
  , nullif(trim(substring(content, 617, 10)), '')                                         as CPI_RATIO
  , nullif(trim(substring(content, 627, 8)), '')                                          as CPI_RATIO_DATE
  , nullif(trim(substring(content, 635, 1)), '')                                          as DATED_DATE_CPI_SIGN
  , nullif(trim(substring(content, 636, 8)), '')                                          as DATED_DATE_CPI
  , nullif(trim(substring(content, 644, 6)), '')                                          as OPTION_CONTRACT_ID
  , nullif(trim(substring(content, 650, 6)), '')                                          as OPTION_EXPIRATION_DATE
  , nullif(trim(substring(content, 656, 1)), '')                                          as OPTION_CALL_PUT_INDICATOR
  , nullif(trim(substring(content, 657, 30)), '')                                         as OPTION_SYMBOL_ID
  , nullif(trim(substring(content, 687, 18)), '')                                         as ELIGIBLE_SETTLEMENT_DATE_QUANTITY
  , nullif(trim(substring(content, 705, 1)), '')                                          as POSITION_FIELD_SIGN_20
  , nullif(trim(substring(content, 706, 18)), '')                                         as FIXED_INCOME_ACCRUED_INTEREST
  , nullif(trim(substring(content, 724, 1)), '')                                          as POSITION_FIELD_SIGN_21
  , nullif(trim(substring(content, 869, 15)), '')                                         as ISIN
  , nullif(trim(substring(content, 884, 15)), '')                                         as SEDOL
  , nullif(trim(substring(content, 899, 3)), '')                                          as CURRENCY_CODE
  , nullif(trim(substring(content, 902, 16)), '')                                         as REPORTING_CURRENCY_CONVERSION_PRICE
  , nullif(trim(substring(content, 918, 18)), '')                                         as LOCAL_CURRENCY_MARKET_VALUE
  , nullif(trim(substring(content, 936, 8)), '')                                          as MARKET_PRICE_DATE
  , nullif(trim(substring(content, 944, 8)), '')                                          as CONVERSION_PRICE_DATE
  , nullif(trim(substring(content, 952, 18)), '')                                         as LOCAL_CURRENCY_FIXED_INCOME_ACCRUED_INTEREST
  , nullif(trim(substring(content, 970, 1)), '')                                          as POSITION_FIELD_SIGN_22
  , case when lower(source_file) like '%full%' then 0 else 1 end                          as is_delta
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 1) = 'D'
{%- endmacro -%}