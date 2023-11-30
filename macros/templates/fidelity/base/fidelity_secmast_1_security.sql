{%- macro fidelity_secmast_1_security(src) -%}
select
    RECORD_TYPE                                                                                                      as RECORD_TYPE
  , RECORD_NUMBER                                                                                                    as RECORD_NUMBER
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src ~ "'" }}                                 as firm_source
  , RECORD_STATUS_CODE                                                                                               as RECORD_STATUS_CODE
  , CUSIP                                                                                                            as CUSIP
  , SYMBOL                                                                                                           as SYMBOL
  , FLOOR_TRADING_SYMBOL                                                                                             as FLOOR_TRADING_SYMBOL
  , SECURITY_TYPE                                                                                                    as SECURITY_TYPE
  , SECURITY_TYPE_MODIFIER                                                                                           as SECURITY_TYPE_MODIFIER
  , SECURITY_TYPE_CALCULATION                                                                                        as SECURITY_TYPE_CALCULATION
  , SECURITY_DESCRIPTION_LINE_1                                                                                      as SECURITY_DESCRIPTION_LINE_1
  , SECURITY_DESCRIPTION_LINE_2                                                                                      as SECURITY_DESCRIPTION_LINE_2
  , SECURITY_DESCRIPTION_LINE_3                                                                                      as SECURITY_DESCRIPTION_LINE_3
  , SECURITY_DESCRIPTION_LINE_4                                                                                      as SECURITY_DESCRIPTION_LINE_4
  , SECURITY_DESCRIPTION_LINE_5                                                                                      as SECURITY_DESCRIPTION_LINE_5
  , SECURITY_DESCRIPTION_LINE_6                                                                                      as SECURITY_DESCRIPTION_LINE_6
  , case
        when nvl(ISSUE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(ISSUE_DATE, 'YYYYMMDD') end::date                                                               as ISSUE_DATE
  , ISSUER_COUNTRY                                                                                                   as ISSUER_COUNTRY
  , PRIMARY_EXCHANGE_1                                                                                               as PRIMARY_EXCHANGE_1
  , DTC_ELIGIBILITY_CODE                                                                                             as DTC_ELIGIBILITY_CODE
  , case
        when nvl(OPTION_RIGHTS_WTS_EXPIRE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_RIGHTS_WTS_EXPIRE_DATE, 'YYYYMMDD') end::date                                            as OPTION_RIGHTS_WTS_EXPIRE_DATE
  , case -- for use in option_symbol_id_occ, renaming allows us to use "cleaned" version of OPTION_RIGHTS_WTS_EXPIRE_DATE
        when nvl(OPTION_RIGHTS_WTS_EXPIRE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_RIGHTS_WTS_EXPIRE_DATE, 'YYYYMMDD') end::date                                            as OPTION_RIGHTS_WTS_EXPIRE_DATE_NEW
  , DISTRIBUTION_FREQUENCY_CODE                                                                                      as DISTRIBUTION_FREQUENCY_CODE
  , SECURITY_SHORT_NAME                                                                                              as SECURITY_SHORT_NAME
  , case
        when nvl(DATED_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(DATED_DATE, 'YYMMDD') end::date                                                                 as DATED_DATE
  , ISIN                                                                                                             as ISIN
  , SEDOL                                                                                                            as SEDOL
  , CURRENCY_CODE                                                                                                    as CURRENCY_CODE
  , COUNTRY_CODE                                                                                                     as COUNTRY_CODE
  , FOREIGN                                                                                                          as FOREIGN
  , ISSUER_STATE_CODE                                                                                                as ISSUER_STATE_CODE
  , PRODUCT_CODE                                                                                                     as PRODUCT_CODE
  , UNDERLYING_CUSIP_CODE                                                                                            as UNDERLYING_CUSIP_CODE
  , UNDERLYING_CUSIP                                                                                                 as UNDERLYING_CUSIP
  , USER_CUSIP_INDICATOR                                                                                             as USER_CUSIP_INDICATOR
  , PIP_ELIGIBLE                                                                                                     as PIP_ELIGIBLE
  , SWP_ELIGIBLE                                                                                                     as SWP_ELIGIBLE
  , BASE_INTEREST_DATE                                                                                               as BASE_INTEREST_DATE
  , INTEREST_DAYS                                                                                                    as INTEREST_DAYS
  , case
        when nvl(FIRST_COUPON_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FIRST_COUPON_DATE, 'YYMMDD') end::date                                                          as FIRST_COUPON_DATE
  , case
        when nvl(DEBT_INTEREST_RATE, '') = '' then null::number(18, 5)
        when DEBT_INTEREST_RATE_SIGN in ('0', '+', '') then (DEBT_INTEREST_RATE::int * .00001)::number(18, 5)
        else (DEBT_INTEREST_RATE::int * -.00001)::number(18, 5) end::number(18, 5)                                   as DEBT_INTEREST_RATE
  , case
        when nvl(DEBT_MATURITY_DATE_1, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(DEBT_MATURITY_DATE_1, 'YYMMDD') end::date                                                       as DEBT_MATURITY_DATE_1
  , BOND_CLASS_CODE                                                                                                  as BOND_CLASS_CODE
  , EXCHANGE_GROUP_NUMBER                                                                                            as EXCHANGE_GROUP_NUMBER
  , FUND_FAMILY_NUMBER                                                                                               as FUND_FAMILY_NUMBER
  , FUND_FAMILY_DESCRIPTION                                                                                          as FUND_FAMILY_DESCRIPTION
  , FUND_LOAD_TYPE                                                                                                   as FUND_LOAD_TYPE
  , FUND_CLASS_OF_SHARES                                                                                             as FUND_CLASS_OF_SHARES
  , TYPE_OF_FUND                                                                                                     as TYPE_OF_FUND
  , REORGANIZATION_PENDING_CODE                                                                                      as REORGANIZATION_PENDING_CODE
  , case
        when nvl(INITIAL_MINIMUM, '') = '' then null::number(18, 2)
        else INITIAL_MINIMUM::int * .01 end::number(18, 2)                                                           as INITIAL_MINIMUM
  , case
        when nvl(SUBSEQUENT_MINIMUM, '') = '' then null::number(18, 2)
        else SUBSEQUENT_MINIMUM::int * .01 end::number(18, 2)                                                        as SUBSEQUENT_MINIMUM
  , case
        when nvl(REDEMPTION_MINIMUM, '') = '' then null::number(18, 2)
        else REDEMPTION_MINIMUM::int * .01 end::number(18, 2)                                                        as REDEMPTION_MINIMUM
  , case
        when nvl(REDEMPTION_MAXIMUM, '') = '' then null::number(18, 2)
        else REDEMPTION_MAXIMUM::int * .01 end::number(18, 2)                                                        as REDEMPTION_MAXIMUM
  , RATING_AGENT_CODE_1                                                                                              as RATING_AGENT_CODE_1
  , RATING_1                                                                                                         as RATING_1
  , RATING_AGENT_CODE_2                                                                                              as RATING_AGENT_CODE_2
  , RATING_2                                                                                                         as RATING_2
  , RATING_AGENT_CODE_3                                                                                              as RATING_AGENT_CODE_3
  , RATING_3                                                                                                         as RATING_3
  , case
        when nvl(CURRENT_FACTOR_AMOUNT, '') = '' then null::number(18, 8)
        else CURRENT_FACTOR_AMOUNT::int * .00000001 end::number(18, 8)                                               as CURRENT_FACTOR_AMOUNT
  , case
        when nvl(CURRENT_FACTOR_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CURRENT_FACTOR_DATE, 'YYYYMMDD') end::date                                                      as CURRENT_FACTOR_DATE
  , ZERO_COUPON_INDICATOR                                                                                            as ZERO_COUPON_INDICATOR
  , case
        when nvl(LAST_COUPON_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_COUPON_DATE, 'YYMMDD') end::date                                                           as LAST_COUPON_DATE
  , case
        when nvl(OPTION_ACTIVITY_BEGIN_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_ACTIVITY_BEGIN_DATE, 'YYMMDD') end::date                                                 as OPTION_ACTIVITY_BEGIN_DATE
  , case
        when nvl(OPTION_ACTIVITY_END_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_ACTIVITY_END_DATE, 'YYMMDD') end::date                                                   as OPTION_ACTIVITY_END_DATE
  , CBL_COVERED_SECURITY_INDICATOR                                                                                   as CBL_COVERED_SECURITY_INDICATOR
  , case
        when nvl(CBL_COVERED_SECURITY_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CBL_COVERED_SECURITY_EFFECTIVE_DATE, 'YYYYMMDD') end::date                                      as CBL_COVERED_SECURITY_EFFECTIVE_DATE
  , case
        when nvl(BID_PRICE, '') = '' then null::number(18, 9)
        else BID_PRICE::int * .000000001 end::number(18, 9)                                                          as BID_PRICE
  , case
        when nvl(ASK_PRICE, '') = '' then null::number(18, 9)
        else ASK_PRICE::int * .000000001 end::number(18, 9)                                                          as ASK_PRICE
  , case
        when nvl(CLOSING_MARKET_PRICE, '') = '' then null::number(18, 9)
        else CLOSING_MARKET_PRICE::int * .000000001 end::number(18, 9)                                               as CLOSING_MARKET_PRICE
  , case
        when nvl(PRICE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(PRICE_DATE, 'YYYYMMDD') end::date                                                               as PRICE_DATE
  , case
        when nvl(UNFACTORED_PRICE, '') = '' then null::number(18, 9)
        when FACTORED_PRICE_SIGN in ('0', '+', '') then (UNFACTORED_PRICE::int * .000000001)::number(18, 9)
        else (UNFACTORED_PRICE::int * -.000000001)::number(18, 9) end::number(18, 9)                                 as UNFACTORED_PRICE
  , case
        when nvl(FACTORED_PRICE, '') = '' then null::number(18, 9)
        else FACTORED_PRICE::int * .000000001 end::number(18, 9)                                                     as FACTORED_PRICE
  , case
        when nvl(PREVIOUS_FACTOR_AMOUNT, '') = '' then null::number(18, 8)
        else PREVIOUS_FACTOR_AMOUNT::int * .00000001 end::number(18, 8)                                              as PREVIOUS_FACTOR_AMOUNT
  , case
        when nvl(PREVIOUS_FACTOR_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(PREVIOUS_FACTOR_DATE, 'YYYYMMDD') end::date                                                     as PREVIOUS_FACTOR_DATE
  , case
        when nvl(SECOND_PREVIOUS_FACTOR_AMOUNT, '') = '' then null::number(18, 8)
        else SECOND_PREVIOUS_FACTOR_AMOUNT::int * .00000001 end::number(18, 8)                                       as SECOND_PREVIOUS_FACTOR_AMOUNT
  , case
        when nvl(SECOND_PREVIOUS_FACTOR_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(SECOND_PREVIOUS_FACTOR_DATE, 'YYYYMMDD') end::date                                              as SECOND_PREVIOUS_FACTOR_DATE
  , DAY_DELAY                                                                                                        as DAY_DELAY
  , case
        when nvl(CPI_RATIO, '') = '' then null::number(18, 8)
        when CPI_RATIO_SIGN in ('0', '+', '') then (CPI_RATIO::int * .00000001)::number(18, 8)
        else (CPI_RATIO::int * -.00000001)::number(18, 8) end::number(18, 8)                                         as CPI_RATIO
  , case
        when nvl(CPI_RATIO_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CPI_RATIO_DATE, 'YYYYMMDD') end::date                                                           as CPI_RATIO_DATE
  , case
        when nvl(DATED_DATE_CPI, '') = '' then null::number(18, 5)
        when DATED_DATE_CPI_SIGN in ('0', '+', '') then (DATED_DATE_CPI::int * .00001)::number(18, 5)
        else (DATED_DATE_CPI::int * -.00001)::number(18, 5) end::number(18, 5)                                       as DATED_DATE_CPI
  , case
        when nvl(CURRENT_COUPON_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CURRENT_COUPON_EFFECTIVE_DATE, 'YYYYMMDD') end::date                                            as CURRENT_COUPON_EFFECTIVE_DATE
  , case
        when nvl(NEXT_STEPPED_COUPON_RATE, '') = '' then null::number(18, 5)
        when NEXT_STEPPED_COUPON_RATE_SIGN in ('0', '+', '')
            then (NEXT_STEPPED_COUPON_RATE::int * .00001)::number(18, 5)
        else (NEXT_STEPPED_COUPON_RATE::int * -.00001)::number(18, 5) end::number(18, 5)                             as NEXT_STEPPED_COUPON_RATE
  , case
        when nvl(NEXT_COUPON_RESET_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NEXT_COUPON_RESET_DATE, 'YYYYMMDD') end::date                                                   as NEXT_COUPON_RESET_DATE
  , COUPON_RESET_FREQUENCY                                                                                           as COUPON_RESET_FREQUENCY
  , case
        when nvl(COUPON_RATE_MINIMUM, '') = '' then null::number(18, 3)
        when COUPON_RATE_MINIMUM_SIGN in ('0', '+', '') then (COUPON_RATE_MINIMUM::int * .001)::number(18, 3)
        else (COUPON_RATE_MINIMUM::int * -.001)::number(18, 3) end::number(18, 3)                                    as COUPON_RATE_MINIMUM
  , case
        when nvl(COUPON_RATE_MAXIMUM, '') = '' then null::number(18, 3)
        when COUPON_RATE_MAXIMUM_SIGN in ('0', '+', '') then (COUPON_RATE_MAXIMUM::int * .001)::number(18, 3)
        else (COUPON_RATE_MAXIMUM::int * -.001)::number(18, 3) end::number(18, 3)                                    as COUPON_RATE_MAXIMUM
  , COUPON_TYPE_CODE                                                                                                 as COUPON_TYPE_CODE
  , COUPON_FORMULA_TEXT                                                                                              as COUPON_FORMULA_TEXT
  , case
        when nvl(COUPON_FORMULA_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(COUPON_FORMULA_EFFECTIVE_DATE, 'YYYYMMDD') end::date                                            as COUPON_FORMULA_EFFECTIVE_DATE
  , COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_1                                                                       as COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_1
  , COUPON_FORMULA_BENCHMARK_1                                                                                       as COUPON_FORMULA_BENCHMARK_1
  , COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_2                                                                       as COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_2
  , COUPON_FORMULA_BENCHMARK_2                                                                                       as COUPON_FORMULA_BENCHMARK_2
  , COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_3                                                                       as COUPON_FORMULA_BENCHMARK_SEQUENCE_NUMBER_3
  , COUPON_FORMULA_BENCHMARK_3                                                                                       as COUPON_FORMULA_BENCHMARK_3
  , DEFAULT_TYPE_CODE                                                                                                as DEFAULT_TYPE_CODE
  , case
        when nvl(DEFAULT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(DEFAULT_DATE, 'YYYYMMDD') end::date                                                             as DEFAULT_DATE
  , CALL_FREQUENCY_CODE                                                                                              as CALL_FREQUENCY_CODE
  , MAKE_WHOLE_INDICATOR                                                                                             as MAKE_WHOLE_INDICATOR
  , EXTRAORDINARY_CALL_INDICATOR                                                                                     as EXTRAORDINARY_CALL_INDICATOR
  , MUNICIPAL_REDEMPTION_TYPE_CODE                                                                                   as MUNICIPAL_REDEMPTION_TYPE_CODE
  , MUNICIPAL_REDEMPTION_TYPE_LONG_DESCRIPTION                                                                       as MUNICIPAL_REDEMPTION_TYPE_LONG_DESCRIPTION
  , case
        when nvl(MANDATORY_PUT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MANDATORY_PUT_DATE, 'YYYYMMDD') end::date                                                       as MANDATORY_PUT_DATE
  , case
        when nvl(MANDATORY_PUT_PRICE, '') = '' then null::number(18, 5)
        else MANDATORY_PUT_PRICE::int * .00001 end::number(18, 5)                                                    as MANDATORY_PUT_PRICE
  , case
        when nvl(NEXT_CALL_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NEXT_CALL_DATE, 'YYYYMMDD') end::date                                                           as NEXT_CALL_DATE
  , case
        when nvl(NEXT_CALL_PRICE, '') = '' then null::number(18, 5)
        when NEXT_CALL_PRICE_SIGN in ('0', '+', '') then (NEXT_CALL_PRICE::int * .00001)::number(18, 5)
        else (NEXT_CALL_PRICE::int * -.00001)::number(18, 5) end::number(18, 5)                                      as NEXT_CALL_PRICE
  , case
        when nvl(FIRST_PAR_CALL_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FIRST_PAR_CALL_DATE, 'YYYYMMDD') end::date                                                      as FIRST_PAR_CALL_DATE
  , case
        when nvl(FIRST_PAR_CALL_PRICE, '') = '' then null::number(18, 5)
        when FIRST_PAR_CALL_PRICE_SIGN in ('0', '+', '') then (FIRST_PAR_CALL_PRICE::int * .00001)::number(18, 5)
        else (FIRST_PAR_CALL_PRICE::int * -.00001)::number(18, 5) end::number(18, 5)                                 as FIRST_PAR_CALL_PRICE
  , case
        when nvl(NEXT_PUT_PRICE, '') = '' then null::number(18, 5)
        when NEXT_PUT_PRICE_SIGN in ('0', '+', '') then (NEXT_PUT_PRICE::int * .00001)::number(18, 5)
        else (NEXT_PUT_PRICE::int * -.00001)::number(18, 5) end::number(18, 5)                                       as NEXT_PUT_PRICE
  , case
        when nvl(NEXT_PUT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NEXT_PUT_DATE, 'YYYYMMDD') end::date                                                            as NEXT_PUT_DATE
  , CALL_NOTIFICATION_MINIMUM                                                                                        as CALL_NOTIFICATION_MINIMUM
  , case
        when nvl(CONTINUOUSLY_CALLABLE_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CONTINUOUSLY_CALLABLE_EFFECTIVE_DATE, 'YYYYMMDD') end::date                                     as CONTINUOUSLY_CALLABLE_EFFECTIVE_DATE
  , case
        when nvl(NEXT_SINK_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NEXT_SINK_DATE, 'YYYYMMDD') end::date                                                           as NEXT_SINK_DATE
  , NEXT_SINK_TYPE                                                                                                   as NEXT_SINK_TYPE
  , case
        when nvl(NEXT_SINK_PRICE, '') = '' then null::number(18, 5)
        when NEXT_SINK_PRICE_SIGN in ('0', '+', '') then (NEXT_SINK_PRICE::int * .00001)::number(18, 5)
        else (NEXT_SINK_PRICE::int * -.00001)::number(18, 5) end::number(18, 5)                                      as NEXT_SINK_PRICE
  , case
        when nvl(NEXT_SINK_AMOUNT, '') = '' then null::number(18, 2)
        when NEXT_SINK_AMOUNT_SIGN in ('0', '+', '') then (NEXT_SINK_AMOUNT::int * .01)::number(18, 2)
        else (NEXT_SINK_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                                        as NEXT_SINK_AMOUNT
  , AUCTION_RATE_PREFERRED_INDICATOR                                                                                 as AUCTION_RATE_PREFERRED_INDICATOR
  , VARIABLE_RATE_INDICATOR                                                                                          as VARIABLE_RATE_INDICATOR
  , UIT_FUND_FAMILY_CODE                                                                                             as UIT_FUND_FAMILY_CODE
  , UIT_FUND_FAMILY_SPONSOR                                                                                          as UIT_FUND_FAMILY_SPONSOR
  , UIT_FUND_FAMILY_NUMBER                                                                                           as UIT_FUND_FAMILY_NUMBER
  , REDEMPTION_CALL_INDICATOR                                                                                        as REDEMPTION_CALL_INDICATOR
  , REDEMPTION_PUT_INDICATOR                                                                                         as REDEMPTION_PUT_INDICATOR
  , OPTION_CONTRACT_ID                                                                                               as OPTION_CONTRACT_ID
  , OPTION_SYMBOL_ID                                                                                                 as OPTION_SYMBOL_ID
  , OPTION_CALL_PUT_INDICATOR                                                                                        as OPTION_CALL_PUT_INDICATOR
  , case
        when nvl(CONVERSION_RATIO, '') = '' then null::number(18, 3)
        when CONVERSION_RATIO_SIGN in ('0', '+', '') then (CONVERSION_RATIO::int * .001)::number(18, 3)
        else (CONVERSION_RATIO::int * -.001)::number(18, 3) end::number(18, 3)                                       as CONVERSION_RATIO
  , PRIMARY_EXCHANGE_2                                                                                               as PRIMARY_EXCHANGE_2
  , TRADABLE_FLAG                                                                                                    as TRADABLE_FLAG
  , CALL_DEFEASED_INDICATOR                                                                                          as CALL_DEFEASED_INDICATOR
  , SINK_DEFEASED_INDICATOR                                                                                          as SINK_DEFEASED_INDICATOR
  , BANK_QUALIFIED_INDICATOR                                                                                         as BANK_QUALIFIED_INDICATOR
  , ALTERNATIVE_INVESTMENT_INDICATOR                                                                                 as ALTERNATIVE_INVESTMENT_INDICATOR
  , case
        when nvl(CALLABLE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(CALLABLE_DATE, 'YYYYMMDD') end::date                                                            as CALLABLE_DATE
  , MARGIN_CODE                                                                                                      as MARGIN_CODE
  , case
        when nvl(MARGIN_PRICE_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MARGIN_PRICE_EFFECTIVE_DATE, 'YYMMDD') end::date                                                as MARGIN_PRICE_EFFECTIVE_DATE
  , case
        when nvl(MARGIN_PRICE_EXPIRE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(MARGIN_PRICE_EXPIRE_DATE, 'YYMMDD') end::date                                                   as MARGIN_PRICE_EXPIRE_DATE
  , case
        when nvl(STRIKE_PRICE, '') = '' then null::number(18, 5)
        else STRIKE_PRICE::int * .00001 end::number(18, 5)                                                           as STRIKE_PRICE
  , case -- for use in option_symbol_id_occ, renaming allows us to use "cleaned" version of STRIKE_PRICE
        when nvl(STRIKE_PRICE, '') = '' then null::number(18, 5)
        else STRIKE_PRICE::int * .00001 end::number(18, 5)                                                           as STRIKE_PRICE_NEW
  , WORTHLESS_SECURITY_INDICATOR                                                                                     as WORTHLESS_SECURITY_INDICATOR
  , INTEREST_POSTING_CODE                                                                                            as INTEREST_POSTING_CODE
  , case
        when nvl(DEBT_MATURITY_DATE_2, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(DEBT_MATURITY_DATE_2, 'YYYYMMDD') end::date                                                     as DEBT_MATURITY_DATE_2
  , case
        when nvl(LAST_CHANGED_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_CHANGED_DATE, 'YYMMDD') end::date                                                          as LAST_CHANGED_DATE
  , MONEY_MARKET_FUND_DESIGNATION                                                                                    as MONEY_MARKET_FUND_DESIGNATION
  , concat(
        rpad(OPTION_CONTRACT_ID, 6, ' '), 
        to_varchar(OPTION_RIGHTS_WTS_EXPIRE_DATE_NEW, 'YYMMDD'),
        OPTION_CALL_PUT_INDICATOR,
        replace(to_varchar(round(STRIKE_PRICE_NEW, 3), 'FM00000.000'), '.')
    )                                                                                                                as OPTION_SYMBOL_ID_OCC
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ ref('fidelity_' ~ src ~ '_history__vw_raw_secmast_1_security') }}
{%- endmacro -%}