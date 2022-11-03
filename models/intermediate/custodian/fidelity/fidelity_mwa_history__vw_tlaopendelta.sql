
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_NUMBER                                                                                       as RECORD_NUMBER
  , TAS_DELTA_INDICATOR                                                                                 as TAS_DELTA_INDICATOR
  , BRANCH                                                                                              as BRANCH
  , ACCOUNT_NUMBER                                                                                      as ACCOUNT_NUMBER
  , ACCOUNT_TYPE                                                                                        as ACCOUNT_TYPE
  , CUSIP                                                                                               as CUSIP
  , SECURITY_DESCRIPTION_LINES_1_6                                                                      as SECURITY_DESCRIPTION_LINES_1_6
  , PRODUCT_CODE                                                                                        as PRODUCT_CODE
  , case
        when nvl(CLOSING_MARKET_PRICE, '') = '' then null::number(18, 9)
        else CLOSING_MARKET_PRICE::int * .000000001 end::number(18, 9)                                  as CLOSING_MARKET_PRICE
  , case
        when nvl(LOT_QUANTITY, '') = '' then null::number(18, 5)
        when LOT_QUANTITY_SIGN in ('0', '+', '') then (LOT_QUANTITY::int * .00001)::number(18, 5)
        else (LOT_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                            as LOT_QUANTITY
  , case
        when nvl(LOT_MARKET_VALUE, '') = '' then null::number(18, 2)
        when LOT_MARKET_VALUE_SIGN in ('0', '+', '') then (LOT_MARKET_VALUE::int * .01)::number(18, 2)
        else (LOT_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)                           as LOT_MARKET_VALUE
  , case
        when nvl(TAS_COST_BASIS_AMOUNT_PROCEEDS, '') = '' then null::number(18, 2)
        when TAS_COST_BASIS_AMOUNT_PROCEEDS_SIGN in ('0', '+', '')
            then (TAS_COST_BASIS_AMOUNT_PROCEEDS::int * .01)::number(18, 2)
        else (TAS_COST_BASIS_AMOUNT_PROCEEDS::int * -.01)::number(18, 2) end::number(18, 2)             as TAS_COST_BASIS_AMOUNT_PROCEEDS
  , case
        when nvl(UNREALIZED_GAIN_LOSS_AMOUNT, '') = '' then null::number(18, 2)
        when UNREALIZED_GAIN_LOSS_AMOUNT_SIGN in ('0', '+', '')
            then (UNREALIZED_GAIN_LOSS_AMOUNT::int * .01)::number(18, 2)
        else (UNREALIZED_GAIN_LOSS_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                as UNREALIZED_GAIN_LOSS_AMOUNT
  , COST_BASIS_EVENT_SOURCE_CODE                                                                        as COST_BASIS_EVENT_SOURCE_CODE
  , case
        when nvl(TAS_LOT_ACQUIRED_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(TAS_LOT_ACQUIRED_DATE, 'YYYYMMDD') end::date                                       as TAS_LOT_ACQUIRED_DATE
  , LOT_COST_BASIS_METHOD_CODE                                                                          as LOT_COST_BASIS_METHOD_CODE
  , HOLDING_PERIOD_FRACTURED_LOT_INDICATOR                                                              as HOLDING_PERIOD_FRACTURED_LOT_INDICATOR
  , WASH_SALE_INDICATOR                                                                                 as WASH_SALE_INDICATOR
  , LONG_SHORT_CODE                                                                                     as LONG_SHORT_CODE
  , MARK_TO_MARKET_INDICATOR                                                                            as MARK_TO_MARKET_INDICATOR
  , RETIREMENT_INDICATOR                                                                                as RETIREMENT_INDICATOR
  , case
        when nvl(FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT, '') = '' then null::number(18, 2)
        when FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT_SIGN in ('0', '+', '')
            then (FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT::int * .01)::number(18, 2)
        else (FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)  as FIXED_INCOME_UNADJUSTED_COST_BASIS_AMOUNT
  , FIXED_INCOME_ADJUSTED_COST_BASIS_INDICATOR                                                          as FIXED_INCOME_ADJUSTED_COST_BASIS_INDICATOR
  , case
        when nvl(YTD_ACQUISITION_PREMIUM, '') = '' then null::number(18, 2)
        when YTD_ACQUISITION_PREMIUM_SIGN in ('0', '+', '') then (YTD_ACQUISITION_PREMIUM::int * .01)::number(18, 2)
        else (YTD_ACQUISITION_PREMIUM::int * -.01)::number(18, 2) end::number(18, 2)                    as YTD_ACQUISITION_PREMIUM
  , case
        when nvl(YTD_AMORTIZED_PREMIUM, '') = '' then null::number(18, 2)
        when YTD_AMORTIZED_PREMIUM_SIGN in ('0', '+', '') then (YTD_AMORTIZED_PREMIUM::int * .01)::number(18, 2)
        else (YTD_AMORTIZED_PREMIUM::int * -.01)::number(18, 2) end::number(18, 2)                      as YTD_AMORTIZED_PREMIUM
  , case
        when nvl(YTD_MARKET_DISCOUNT_INCOME, '') = '' then null::number(18, 2)
        when YTD_MARKET_DISCOUNT_INCOME_SIGN in ('0', '+', '')
            then (YTD_MARKET_DISCOUNT_INCOME::int * .01)::number(18, 2)
        else (YTD_MARKET_DISCOUNT_INCOME::int * -.01)::number(18, 2) end::number(18, 2)                 as YTD_MARKET_DISCOUNT_INCOME
  , OPTION_CONTRACT_ID                                                                                  as OPTION_CONTRACT_ID
  , case
        when nvl(OPTION_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_EXPIRATION_DATE, 'YYMMDD') end::date                                        as OPTION_EXPIRATION_DATE
  , OPTION_CALL_PUT_INDICATOR                                                                           as OPTION_CALL_PUT_INDICATOR
  , case
        when nvl(OPTION_STRIKE_PRICE, '') = '' then null::number(18, 3)
        else OPTION_STRIKE_PRICE::int * .001 end::number(18, 3)                                         as OPTION_STRIKE_PRICE
  , OPTION_SYMBOL_ID                                                                                    as OPTION_SYMBOL_ID
  , CBL_COVERED_LOT_INDICATOR                                                                           as CBL_COVERED_LOT_INDICATOR
  , CBL_GIFTED_INHERITED_LOT_INDICATOR                                                                  as CBL_GIFTED_INHERITED_LOT_INDICATOR
  , case
        when nvl(GIFTED_LOT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(GIFTED_LOT_DATE, 'YYYYMMDD') end::date                                             as GIFTED_LOT_DATE
  , case
        when nvl(GIFTED_LOT_FAIR_MARKET_VALUE, '') = '' then null::number(18, 2)
        when GIFTED_LOT_FAIR_MARKET_VALUE_SIGN in ('0', '+', '')
            then (GIFTED_LOT_FAIR_MARKET_VALUE::int * .01)::number(18, 2)
        else (GIFTED_LOT_FAIR_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)               as GIFTED_LOT_FAIR_MARKET_VALUE
  , CBL_COVERED_REASON_CODE                                                                             as CBL_COVERED_REASON_CODE
  , case
        when nvl(WASH_SALE_HOLDING_PERIOD_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(WASH_SALE_HOLDING_PERIOD_DATE, 'YYYYMMDD') end::date                               as WASH_SALE_HOLDING_PERIOD_DATE
  , OPEN_LOT_IDENTIFIER                                                                                 as OPEN_LOT_IDENTIFIER
  , NIGO_OUT_OF_BALANCE_EXCEPTION_INDICATOR                                                             as NIGO_OUT_OF_BALANCE_EXCEPTION_INDICATOR
  , NIGO_TECH_SHORT_EXCEPTION_INDICATOR                                                                 as NIGO_TECH_SHORT_EXCEPTION_INDICATOR
  , NIGO_COST_EXCEPTION_INDICATOR                                                                       as NIGO_COST_EXCEPTION_INDICATOR
  , POSITION_COST_BASIS_METHOD_CODE                                                                     as POSITION_COST_BASIS_METHOD_CODE
  , case
        when nvl(OPEN_LOT_SETTLEMENT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPEN_LOT_SETTLEMENT_DATE, 'YYYYMMDD') end::date                                    as OPEN_LOT_SETTLEMENT_DATE
  , case
        when nvl(ORIGINAL_LOT_QUANTITY, '') = '' then null::number(18, 5)
        when ORIGINAL_LOT_QUANTITY_SIGN in ('0', '+', '') then (ORIGINAL_LOT_QUANTITY::int * .00001)::number(18, 5)
        else (ORIGINAL_LOT_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                   as ORIGINAL_LOT_QUANTITY
  , case
        when nvl(ORIGINAL_LOT_COST, '') = '' then null::number(18, 2)
        when ORIGINAL_LOT_COST_SIGN in ('0', '+', '') then (ORIGINAL_LOT_COST::int * .01)::number(18, 2)
        else (ORIGINAL_LOT_COST::int * -.01)::number(18, 2) end::number(18, 2)                          as ORIGINAL_LOT_COST
  , case
        when nvl(CURRENT_COST_UNADJUSTED_WASH, '') = '' then null::number(18, 2)
        when CURRENT_COST_UNADJUSTED_WASH_SIGN in ('0', '+', '')
            then (CURRENT_COST_UNADJUSTED_WASH::int * .01)::number(18, 2)
        else (CURRENT_COST_UNADJUSTED_WASH::int * -.01)::number(18, 2) end::number(18, 2)               as CURRENT_COST_UNADJUSTED_WASH
  , case
        when nvl(OPEN_RUN_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPEN_RUN_DATE, 'YYYYMMDD') end::date                                               as OPEN_RUN_DATE
  , SEDOL                                                                                               as SEDOL
  , case
        when nvl(YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT, '') = '' then null::number(18, 2)
        when YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT_SIGN in ('0', '+', '')
            then (YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT::int * .01)::number(18, 2)
        else (YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)         as YTD_ORIGINAL_ISSUE_DISCOUNT_AMOUNT
  , case
        when nvl(THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_DATE, 'YYYYMMDD') end::date                    as THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_DATE
  , case
        when nvl(THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT, '') = '' then null::number(18, 2)
        when THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT_SIGN in ('0', '+', '')
            then (THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT::int * .01)::number(18, 2)
        else (THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2) as THIRD_PARTY_FIXED_INCOME_ADJUSTMENT_AMOUNT
  , case
        when nvl(LOT_RECEIVED_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LOT_RECEIVED_DATE, 'YYYYMMDD') end::date                                           as LOT_RECEIVED_DATE
  , case
        when nvl(YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT, '') = '' then null::number(18, 2)
        when YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT_SIGN in ('0', '+', '')
            then (YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT::int * .01)::number(18, 2)
        else (YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)   as YTD_NON_QUALIFIED_STATED_INTEREST_AMOUNT
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_tlaopendelta') }}