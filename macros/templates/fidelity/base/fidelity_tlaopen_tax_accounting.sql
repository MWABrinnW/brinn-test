{%- macro fidelity_tlaopen_tax_accounting(src) -%}
select
    ACCOUNT_CUSTODIAL
    ,ACCOUNT_CUSTODIAL_FORMATTED
    ,RECORD_NUMBER
    , 'fidelity'                                                                             as custodian
    , {{ "'" ~ src ~ "'" }}                                 as firm_source
    ,TAS_DELTA_INDICATOR
    ,BRANCH
    ,ACCOUNT_NUMBER
    ,ACCOUNT_TYPE
    ,CUSIP
    ,SECURITY_DESCRIPTION_LINES_1_6
    ,PRODUCT_CODE
    ,CLOSING_MARKET_PRICE
    ,LOT_QUANTITY
    ,LOT_MARKET_VALUE
    ,TAS_COST_BASIS_AMOUNT_PROCEEDS
    ,UNREALIZED_GAIN_LOSS_AMOUNT
    ,COST_BASIS_EVENT_SOURCE_CODE
    ,TAS_LOT_ACQUIRED_DATE
    ,LOT_COST_BASIS_METHOD_CODE
    ,HOLDING_PERIOD_FRACTURED_LOT_INDICATOR
    ,WASH_SALE_INDICATOR
    ,LONG_SHORT_CODE
    ,MARK_TO_MARKET_INDICATOR
    ,RETIREMENT_INDICATOR
    ,FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT
    ,FIXED_INCOME_ADJUSTED_COST_BASIS_INDICATOR
    ,YTD_ACQUISITION_PREMIUM
    ,YTD_AMORTIZED_PREMIUM
    ,YTD_MARKET_DISCOUNT_INCOME
    ,OPTION_CONTRACT_ID
    ,OPTION_EXPIRATION_DATE
    ,OPTION_CALL_PUT_INDICATOR
    ,OPTION_STRIKE_PRICE
    ,OPTION_SYMBOL_ID
    ,CBL_COVERED_LOT_INDICATOR
    ,CBL_GIFTED_INHERITED_LOT_INDICATOR
    ,GIFTED_LOT_DATE
    ,GIFTED_LOT_FAIR_MARKET_VALUE
    ,CBL_COVERED_REASON_CODE
    ,WASH_SALE_HOLDING_PERIOD_DATE
    ,OPEN_LOT_IDENTIFIER
    ,NIGO_OUT_OF_BALANCE_EXCEPTION_INDICATOR
    ,NIGO_TECH_SHORT_EXCEPTION_INDICATOR
    ,NIGO_COST_EXCEPTION_INDICATOR
    ,POSITION_COST_BASIS_METHOD_CODE
    ,OPEN_LOT_SETTLEMENT_DATE
    ,ORIGINAL_LOT_QUANTITY
    ,ORIGINAL_LOT_COST
    ,CURRENT_COST_UNADJUSTED_WASH
    ,OPEN_RUN_DATE
    ,SEDOL
    ,YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT
    ,THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_DATE
    ,THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT
    ,LOT_RECEIVED_DATE
    ,YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT
    ,DTNUM
  , {{ col_is_head(reference=source('fidelity_' ~ src, 'tlaopen_tax_accounting')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , effective_date_original
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ source('fidelity_' ~ src, 'tlaopen_tax_accounting') }}
{%- endmacro -%}