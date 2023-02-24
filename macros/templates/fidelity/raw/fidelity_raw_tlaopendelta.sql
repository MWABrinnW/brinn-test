{%- macro fidelity_raw_tlaopendelta(src) -%}
select
    trim(substring(content, 3, 3)) || trim(substring(content, 6, 6))                       as ACCOUNT_CUSTODIAL
  , trim(substring(content, 3, 3)) || '-' ||
    trim(substring(content, 6, 6))                                                         as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 2, 1)), '')                                             as TAS_DELTA_INDICATOR
  , nullif(trim(substring(content, 3, 3)), '')                                             as BRANCH
  , nullif(trim(substring(content, 6, 6)), '')                                             as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 12, 1)), '')                                            as ACCOUNT_TYPE
  , nullif(trim(substring(content, 13, 9)), '')                                            as CUSIP
  , nullif(trim(substring(content, 22, 120)), '')                                          as SECURITY_DESCRIPTION_LINES_1_6
  , nullif(trim(substring(content, 142, 12)), '')                                          as PRODUCT_CODE
  , nullif(trim(substring(content, 154, 18)), '')                                          as CLOSING_MARKET_PRICE
  , nullif(trim(substring(content, 172, 1)), '')                                           as CLOSING_MARKET_PRICE_SIGN
  , nullif(trim(substring(content, 173, 18)), '')                                          as LOT_QUANTITY
  , nullif(trim(substring(content, 191, 1)), '')                                           as LOT_QUANTITY_SIGN
  , nullif(trim(substring(content, 192, 17)), '')                                          as LOT_MARKET_VALUE
  , nullif(trim(substring(content, 209, 1)), '')                                           as LOT_MARKET_VALUE_SIGN
  , nullif(trim(substring(content, 210, 17)), '')                                          as TAS_COST_BASIS_AMOUNT_PROCEEDS
  , nullif(trim(substring(content, 227, 1)), '')                                           as TAS_COST_BASIS_AMOUNT_PROCEEDS_SIGN
  , nullif(trim(substring(content, 228, 17)), '')                                          as UNREALIZED_GAIN_LOSS_AMOUNT
  , nullif(trim(substring(content, 245, 1)), '')                                           as UNREALIZED_GAIN_LOSS_AMOUNT_SIGN
  , nullif(trim(substring(content, 246, 1)), '')                                           as COST_BASIS_EVENT_SOURCE_CODE
  , nullif(trim(substring(content, 247, 8)), '')                                           as TAS_LOT_ACQUIRED_DATE
  , nullif(trim(substring(content, 255, 1)), '')                                           as LOT_COST_BASIS_METHOD_CODE
  , nullif(trim(substring(content, 256, 1)), '')                                           as HOLDING_PERIOD_FRACTURED_LOT_INDICATOR
  , nullif(trim(substring(content, 257, 1)), '')                                           as WASH_SALE_INDICATOR
  , nullif(trim(substring(content, 258, 1)), '')                                           as LONG_SHORT_CODE
  , nullif(trim(substring(content, 259, 1)), '')                                           as MARK_TO_MARKET_INDICATOR
  , nullif(trim(substring(content, 260, 1)), '')                                           as RETIREMENT_INDICATOR
  , nullif(trim(substring(content, 261, 17)), '')                                          as FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT
  , nullif(trim(substring(content, 278, 1)), '')                                           as FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT_SIGN
  , nullif(trim(substring(content, 279, 1)), '')                                           as FIXED_INCOME_ADJUSTED_COST_BASIS_INDICATOR
  , nullif(trim(substring(content, 280, 17)), '')                                          as YTD_ACQUISITION_PREMIUM
  , nullif(trim(substring(content, 297, 1)), '')                                           as YTD_ACQUISITION_PREMIUM_SIGN
  , nullif(trim(substring(content, 298, 17)), '')                                          as YTD_AMORTIZED_PREMIUM
  , nullif(trim(substring(content, 315, 1)), '')                                           as YTD_AMORTIZED_PREMIUM_SIGN
  , nullif(trim(substring(content, 316, 17)), '')                                          as YTD_MARKET_DISCOUNT_INCOME
  , nullif(trim(substring(content, 333, 1)), '')                                           as YTD_MARKET_DISCOUNT_INCOME_SIGN
  , nullif(trim(substring(content, 334, 6)), '')                                           as OPTION_CONTRACT_ID
  , nullif(trim(substring(content, 340, 6)), '')                                           as OPTION_EXPIRATION_DATE
  , nullif(trim(substring(content, 346, 1)), '')                                           as OPTION_CALL_PUT_INDICATOR
  , nullif(trim(substring(content, 347, 8)), '')                                           as OPTION_STRIKE_PRICE
  , nullif(trim(substring(content, 355, 30)), '')                                          as OPTION_SYMBOL_ID
  , nullif(trim(substring(content, 385, 1)), '')                                           as CBL_COVERED_LOT_INDICATOR
  , nullif(trim(substring(content, 386, 1)), '')                                           as CBL_GIFTED_INHERITED_LOT_INDICATOR
  , nullif(trim(substring(content, 387, 8)), '')                                           as GIFTED_LOT_DATE
  , nullif(trim(substring(content, 395, 17)), '')                                          as GIFTED_LOT_FAIR_MARKET_VALUE
  , nullif(trim(substring(content, 412, 1)), '')                                           as GIFTED_LOT_FAIR_MARKET_VALUE_SIGN
  , nullif(trim(substring(content, 413, 1)), '')                                           as CBL_COVERED_REASON_CODE
  , nullif(trim(substring(content, 414, 8)), '')                                           as WASH_SALE_HOLDING_PERIOD_DATE
  , nullif(trim(substring(content, 440, 34)), '')                                          as OPEN_LOT_IDENTIFIER
  , nullif(trim(substring(content, 474, 1)), '')                                           as NIGO_OUT_OF_BALANCE_EXCEPTION_INDICATOR
  , nullif(trim(substring(content, 475, 1)), '')                                           as NIGO_TECH_SHORT_EXCEPTION_INDICATOR
  , nullif(trim(substring(content, 476, 1)), '')                                           as NIGO_COST_EXCEPTION_INDICATOR
  , nullif(trim(substring(content, 477, 1)), '')                                           as POSITION_COST_BASIS_METHOD_CODE
  , nullif(trim(substring(content, 478, 8)), '')                                           as OPEN_LOT_SETTLEMENT_DATE
  , nullif(trim(substring(content, 486, 18)), '')                                          as ORIGINAL_LOT_QUANTITY
  , nullif(trim(substring(content, 504, 1)), '')                                           as ORIGINAL_LOT_QUANTITY_SIGN
  , nullif(trim(substring(content, 505, 17)), '')                                          as ORIGINAL_LOT_COST
  , nullif(trim(substring(content, 522, 1)), '')                                           as ORIGINAL_LOT_COST_SIGN
  , nullif(trim(substring(content, 523, 17)), '')                                          as CURRENT_COST_UNADJUSTED_WASH
  , nullif(trim(substring(content, 540, 1)), '')                                           as CURRENT_COST_UNADJUSTED_WASH_SIGN
  , nullif(trim(substring(content, 541, 8)), '')                                           as OPEN_RUN_DATE
  , nullif(trim(substring(content, 549, 7)), '')                                           as SEDOL
  , nullif(trim(substring(content, 556, 17)), '')                                          as YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT
  , nullif(trim(substring(content, 573, 1)), '')                                           as YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT_SIGN
  , nullif(trim(substring(content, 574, 8)), '')                                           as THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_DATE
  , nullif(trim(substring(content, 582, 17)), '')                                          as THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT
  , nullif(trim(substring(content, 599, 1)), '')                                           as THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT_SIGN
  , nullif(trim(substring(content, 600, 8)), '')                                           as LOT_RECEIVED_DATE
  , nullif(trim(substring(content, 608, 17)), '')                                          as YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT
  , nullif(trim(substring(content, 625, 1)), '')                                           as YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT_SIGN
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date, record_datetime::date as record_date, record_datetime::timestamp as record_datetime, source_file as source_file
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 1) = 'D'
{%- endmacro -%}