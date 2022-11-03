
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_NUMBER                                                                                                 as RECORD_NUMBER
  , POSITION_DELTA_INDICATOR                                                                                      as POSITION_DELTA_INDICATOR
  , FIRM                                                                                                          as FIRM
  , BRANCH                                                                                                        as BRANCH
  , ACCOUNT_NUMBER                                                                                                as ACCOUNT_NUMBER
  , ACCOUNT_TYPE                                                                                                  as ACCOUNT_TYPE
  , CUSIP                                                                                                         as CUSIP
  , SECURITY_TYPE                                                                                                 as SECURITY_TYPE
  , SECURITY_TYPE_MODIFIER                                                                                        as SECURITY_TYPE_MODIFIER
  , PRIMARY_EXCHANGE                                                                                              as PRIMARY_EXCHANGE
  , DTC_ELIGIBILITY_CODE                                                                                          as DTC_ELIGIBILITY_CODE
  , REGISTERED_REP_OWNING_REP_RR                                                                                  as REGISTERED_REP_OWNING_REP_RR
  , case
        when nvl(MARGIN_LAST_ACTIVITY_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MARGIN_LAST_ACTIVITY_DATE, 'YYMMDD') end::date                                               as MARGIN_LAST_ACTIVITY_DATE
  , case
        when nvl(STOCK_RECORD_LAST_ACTIVITY_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(STOCK_RECORD_LAST_ACTIVITY_DATE, 'YYMMDD') end::date                                         as STOCK_RECORD_LAST_ACTIVITY_DATE
  , SYMBOL                                                                                                        as SYMBOL
  , case
        when nvl(MARKET_PRICE, '') = '' then null::number(18, 9)
        when POSITION_FIELD_SIGN_1 in ('0', '+', '') then (MARKET_PRICE::int * .000000001)::number(18, 9)
        else (MARKET_PRICE::int * -.000000001)::number(18, 9) end::number(18, 9)                                  as MARKET_PRICE
  , case
        when nvl(TRADE_DATE_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_2 in ('0', '+', '') then (TRADE_DATE_QUANTITY::int * .00001)::number(18, 5)
        else (TRADE_DATE_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                               as TRADE_DATE_QUANTITY
  , case
        when nvl(OPTION_STRIKE_PRICE, '') = '' then null::number(18, 3)
        else OPTION_STRIKE_PRICE::int * .001 end::number(18, 3)                                                   as OPTION_STRIKE_PRICE
  , case
        when nvl(SETTLEMENT_DATE_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_3 in ('0', '+', '') then (SETTLEMENT_DATE_QUANTITY::int * .00001)::number(18, 5)
        else (SETTLEMENT_DATE_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                          as SETTLEMENT_DATE_QUANTITY
  , case
        when nvl(SEGREGATED_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_4 in ('0', '+', '') then (SEGREGATED_QUANTITY::int * .00001)::number(18, 5)
        else (SEGREGATED_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                               as SEGREGATED_QUANTITY
  , case
        when nvl(TRANSIT_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_5 in ('0', '+', '') then (TRANSIT_QUANTITY::int * .00001)::number(18, 5)
        else (TRANSIT_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                                  as TRANSIT_QUANTITY
  , case
        when nvl(TRANSFER_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_6 in ('0', '+', '') then (TRANSFER_QUANTITY::int * .00001)::number(18, 5)
        else (TRANSFER_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                                 as TRANSFER_QUANTITY
  , case
        when nvl(LEGAL_TRANSFER_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_7 in ('0', '+', '') then (LEGAL_TRANSFER_QUANTITY::int * .00001)::number(18, 5)
        else (LEGAL_TRANSFER_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                           as LEGAL_TRANSFER_QUANTITY
  , case
        when nvl(NON_NEGOTIABLE_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_8 in ('0', '+', '') then (NON_NEGOTIABLE_QUANTITY::int * .00001)::number(18, 5)
        else (NON_NEGOTIABLE_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                           as NON_NEGOTIABLE_QUANTITY
  , case
        when nvl(TRADE_DATE_SHORT_SALE_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_9 in ('0', '+', '') then (TRADE_DATE_SHORT_SALE_QUANTITY::int * .00001)::number(18, 5)
        else (TRADE_DATE_SHORT_SALE_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)                    as TRADE_DATE_SHORT_SALE_QUANTITY
  , case
        when nvl(SETTLEMENT_DATE_SHORT_SALE_QUANTITY, '') = '' then null::number(18, 5)
        when POSITION_FIELD_SIGN_10 in ('0', '+', '')
            then (SETTLEMENT_DATE_SHORT_SALE_QUANTITY::int * .00001)::number(18, 5)
        else (SETTLEMENT_DATE_SHORT_SALE_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)               as SETTLEMENT_DATE_SHORT_SALE_QUANTITY
  , case
        when nvl(MTD_POSITION_TRADE_DATE_BALANCE, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_11 in ('0', '+', '') then (MTD_POSITION_TRADE_DATE_BALANCE::int * .01)::number(18, 2)
        else (MTD_POSITION_TRADE_DATE_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)                      as MTD_POSITION_TRADE_DATE_BALANCE
  , case
        when nvl(MTD_POSITION_SETTLEMENT_DATE_BALANCE, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_12 in ('0', '+', '')
            then (MTD_POSITION_SETTLEMENT_DATE_BALANCE::int * .01)::number(18, 2)
        else (MTD_POSITION_SETTLEMENT_DATE_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)                 as MTD_POSITION_SETTLEMENT_DATE_BALANCE
  , case
        when nvl(MTD_TRADE_DATE_POSITION_COMMISSION, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_13 in ('0', '+', '')
            then (MTD_TRADE_DATE_POSITION_COMMISSION::int * .01)::number(18, 2)
        else (MTD_TRADE_DATE_POSITION_COMMISSION::int * -.01)::number(18, 2) end::number(18, 2)                   as MTD_TRADE_DATE_POSITION_COMMISSION
  , case
        when nvl(MTD_SETTLE_DATE_POSITION_COMMISSION, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_14 in ('0', '+', '')
            then (MTD_SETTLE_DATE_POSITION_COMMISSION::int * .01)::number(18, 2)
        else (MTD_SETTLE_DATE_POSITION_COMMISSION::int * -.01)::number(18, 2) end::number(18, 2)                  as MTD_SETTLE_DATE_POSITION_COMMISSION
  , case
        when nvl(COUPON_RATE, '') = '' then null::number(18, 3)
        when POSITION_FIELD_SIGN_15 in ('0', '+', '') then (COUPON_RATE::int * .001)::number(18, 3)
        else (COUPON_RATE::int * -.001)::number(18, 3) end::number(18, 3)                                         as COUPON_RATE
  , NUMBER_OF_SECURITY_DESCRIPTION_LINES::int                                                                     as NUMBER_OF_SECURITY_DESCRIPTION_LINES
  , SHORT_NAME                                                                                                    as SHORT_NAME
  , SECURITY_DESCRIPTION_LINE_1                                                                                   as SECURITY_DESCRIPTION_LINE_1
  , SECURITY_DESCRIPTION_LINE_2                                                                                   as SECURITY_DESCRIPTION_LINE_2
  , SECURITY_DESCRIPTION_LINE_3                                                                                   as SECURITY_DESCRIPTION_LINE_3
  , SECURITY_DESCRIPTION_LINE_4                                                                                   as SECURITY_DESCRIPTION_LINE_4
  , SECURITY_DESCRIPTION_LINE_5                                                                                   as SECURITY_DESCRIPTION_LINE_5
  , SECURITY_DESCRIPTION_LINE_6                                                                                   as SECURITY_DESCRIPTION_LINE_6
  , DIVIDEND_INSTRUCTION_CODE                                                                                     as DIVIDEND_INSTRUCTION_CODE
  , SHORT_TERM_CAPITAL_GAINS_INSTRUCTION_CODE                                                                     as SHORT_TERM_CAPITAL_GAINS_INSTRUCTION_CODE
  , LONG_TERM_CAPITAL_GAINS_INSTRUCTION_CODE                                                                      as LONG_TERM_CAPITAL_GAINS_INSTRUCTION_CODE
  , case
        when nvl(DIVIDEND_CAPITAL_GAINS_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(DIVIDEND_CAPITAL_GAINS_UPDATE_DATE, 'YYMMDD') end::date                                      as DIVIDEND_CAPITAL_GAINS_UPDATE_DATE
  , DIVIDEND_CAPITAL_GAINS_UPDATE_USER_ID                                                                         as DIVIDEND_CAPITAL_GAINS_UPDATE_USER_ID
  , case
        when nvl(MTD_POSITION_INCOME_TRADE_DATE, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_16 in ('0', '+', '') then (MTD_POSITION_INCOME_TRADE_DATE::int * .01)::number(18, 2)
        else (MTD_POSITION_INCOME_TRADE_DATE::int * -.01)::number(18, 2) end::number(18, 2)                       as MTD_POSITION_INCOME_TRADE_DATE
  , case
        when nvl(MTD_POSITION_INCOME_SETTLE_DATE, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_17 in ('0', '+', '') then (MTD_POSITION_INCOME_SETTLE_DATE::int * .01)::number(18, 2)
        else (MTD_POSITION_INCOME_SETTLE_DATE::int * -.01)::number(18, 2) end::number(18, 2)                      as MTD_POSITION_INCOME_SETTLE_DATE
  , REGISTERED_REP_EXEC_REP_RR2                                                                                   as REGISTERED_REP_EXEC_REP_RR2
  , AGENCY_CODE                                                                                                   as AGENCY_CODE
  , PRODUCT_CODE                                                                                                  as PRODUCT_CODE
  , case
        when nvl(MATURITY_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MATURITY_DATE, 'YYYYMMDD') end::date                                                         as MATURITY_DATE
  , case
        when nvl(CASH_AVAILABLE_TO_PAY, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_18 in ('0', '+', '') then (CASH_AVAILABLE_TO_PAY::int * .01)::number(18, 2)
        else (CASH_AVAILABLE_TO_PAY::int * -.01)::number(18, 2) end::number(18, 2)                                as CASH_AVAILABLE_TO_PAY
  , MULTI_CURRENCY_INDICATOR                                                                                      as MULTI_CURRENCY_INDICATOR
  , case
        when nvl(POSITION_MARKET_VALUE, '') = '' then null::number(18, 2)
        when POSITION_FIELD_SIGN_19 in ('0', '+', '') then (POSITION_MARKET_VALUE::int * .01)::number(18, 2)
        else (POSITION_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)                                as POSITION_MARKET_VALUE
  , case
        when nvl(CURRENT_FACTOR_AMOUNT, '') = '' then null::number(18, 8)
        when UNFACTORED_PRICE_SIGN in ('0', '+', '') then (CURRENT_FACTOR_AMOUNT::int * .00000001)::number(18, 8)
        else (CURRENT_FACTOR_AMOUNT::int * -.00000001)::number(18, 8) end::number(18, 8)                          as CURRENT_FACTOR_AMOUNT
  , case
        when nvl(UNFACTORED_PRICE, '') = '' then null::number(18, 9)
        when CPI_RATIO_SIGN in ('0', '+', '') then (UNFACTORED_PRICE::int * .000000001)::number(18, 9)
        else (UNFACTORED_PRICE::int * -.000000001)::number(18, 9) end::number(18, 9)                              as UNFACTORED_PRICE
  , case
        when nvl(CPI_RATIO, '') = '' then null::number(18, 8)
        else CPI_RATIO::int * .00000001 end::number(18, 8)                                                        as CPI_RATIO
  , CPI_RATIO_DATE                                                                                                as CPI_RATIO_DATE
  , case
        when nvl(DATED_DATE_CPI, '') = '' then null::number(18, 5)
        when DATED_DATE_CPI_SIGN in ('0', '+', '') then (DATED_DATE_CPI::int * .00001)::number(18, 5)
        else (DATED_DATE_CPI::int * -.00001)::number(18, 5) end::number(18, 5)                                    as DATED_DATE_CPI
  , OPTION_CONTRACT_ID                                                                                            as OPTION_CONTRACT_ID
  , case
        when nvl(OPTION_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_EXPIRATION_DATE, 'YYMMDD') end::date                                                  as OPTION_EXPIRATION_DATE
  , OPTION_CALL_PUT_INDICATOR                                                                                     as OPTION_CALL_PUT_INDICATOR
  , OPTION_SYMBOL_ID                                                                                              as OPTION_SYMBOL_ID
  , case
        when nvl(ELIGIBLE_SETTLEMENT_DATE_QUANTITY, '') = '' then null::number(18, 9)
        when POSITION_FIELD_SIGN_20 in ('0', '+', '')
            then (ELIGIBLE_SETTLEMENT_DATE_QUANTITY::int * .000000001)::number(18, 9)
        else (ELIGIBLE_SETTLEMENT_DATE_QUANTITY::int * -.000000001)::number(18, 9) end::number(18, 9)             as ELIGIBLE_SETTLEMENT_DATE_QUANTITY
  , case
        when nvl(FIXED_INCOME_ACCRUED_INTEREST, '') = '' then null::number(18, 9)
        when POSITION_FIELD_SIGN_21 in ('0', '+', '')
            then (FIXED_INCOME_ACCRUED_INTEREST::int * .000000001)::number(18, 9)
        else (FIXED_INCOME_ACCRUED_INTEREST::int * -.000000001)::number(18, 9) end::number(18, 9)                 as FIXED_INCOME_ACCRUED_INTEREST
  , ISIN                                                                                                          as ISIN
  , SEDOL                                                                                                         as SEDOL
  , CURRENCY_CODE                                                                                                 as CURRENCY_CODE
  , case
        when nvl(REPORTING_CURRENCY_CONVERSION_PRICE, '') = '' then null::number(18, 8)
        else REPORTING_CURRENCY_CONVERSION_PRICE::int * .00000001 end::number(18, 8)                              as REPORTING_CURRENCY_CONVERSION_PRICE
  , case
        when nvl(LOCAL_CURRENCY_MARKET_VALUE, '') = '' then null::number(18, 4)
        else LOCAL_CURRENCY_MARKET_VALUE::int * .0001 end::number(18, 4)                                          as LOCAL_CURRENCY_MARKET_VALUE
  , case
        when nvl(MARKET_PRICE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MARKET_PRICE_DATE, 'MMDDYYYY') end::date                                                     as MARKET_PRICE_DATE
  , case
        when nvl(CONVERSION_PRICE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CONVERSION_PRICE_DATE, 'MMDDYYYY') end::date                                                 as CONVERSION_PRICE_DATE
  , case
        when nvl(LOCAL_CURRENCY_FIXED_INCOME_ACCRUED_INTEREST, '') = '' then null::number(18, 9)
        when POSITION_FIELD_SIGN_22 in ('0', '+', '')
            then (LOCAL_CURRENCY_FIXED_INCOME_ACCRUED_INTEREST::int * .000000001)::number(18, 9)
        else (LOCAL_CURRENCY_FIXED_INCOME_ACCRUED_INTEREST::int * -.000000001)::number(18, 9) end::number(18, 9)  as LOCAL_CURRENCY_FIXED_INCOME_ACCRUED_INTEREST
  , is_delta
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_positd_position') }}