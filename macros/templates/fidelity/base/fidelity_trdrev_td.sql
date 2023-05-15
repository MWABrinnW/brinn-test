{%- macro fidelity_trdrev_td(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_NUMBER                                                                                                    as RECORD_NUMBER
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src ~ "'" }}                                 as firm_source
  , FIRM                                                                                                             as FIRM
  , BUY_SELL_CODE                                                                                                    as BUY_SELL_CODE
  , case
        when nvl(TRADE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(TRADE_DATE, 'YYYYMMDD') end::date                                                               as TRADE_DATE
  , case
        when nvl(SETTLEMENT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(SETTLEMENT_DATE, 'YYYYMMDD') end::date                                                          as SETTLEMENT_DATE
  , MARKET_CODE                                                                                                      as MARKET_CODE
  , BLOTTER_CODE                                                                                                     as BLOTTER_CODE
  , CANCEL_CODE                                                                                                      as CANCEL_CODE
  , CORRECTION_CODE                                                                                                  as CORRECTION_CODE
  , BRANCH                                                                                                           as BRANCH
  , ACCOUNT_NUMBER                                                                                                   as ACCOUNT_NUMBER
  , ACCOUNT_TYPE                                                                                                     as ACCOUNT_TYPE
  , CUSIP                                                                                                            as CUSIP
  , BASIS_PRICE_CODE                                                                                                 as BASIS_PRICE_CODE
  , case
        when nvl(RUN_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(RUN_DATE, 'YYYYMMDD') end::date                                                                 as RUN_DATE
  , TRADE_REFERENCE_NUMBER                                                                                           as TRADE_REFERENCE_NUMBER
  , USER_REFERENCE_NUMBER                                                                                            as USER_REFERENCE_NUMBER
  , CANCELED_COMBINED_REFERENCE                                                                                      as CANCELED_COMBINED_REFERENCE
  , BATCH                                                                                                            as BATCH
  , COUNT                                                                                                            as COUNT
  , SYMBOL                                                                                                           as SYMBOL
  , SECURITY_TYPE                                                                                                    as SECURITY_TYPE
  , SECURITY_TYPE_MODIFIER                                                                                           as SECURITY_TYPE_MODIFIER
  , SECURITY_TYPE_CALCULATION                                                                                        as SECURITY_TYPE_CALCULATION
  , CNS_CODE                                                                                                         as CNS_CODE
  , PRIMARY_EXCHANGE                                                                                                 as PRIMARY_EXCHANGE
  , DTC_ELIGIBILITY_CODE                                                                                             as DTC_ELIGIBILITY_CODE
  , FOREIGN_CODE                                                                                                     as FOREIGN_CODE
  , REGISTERED_REP_ENTER_REP                                                                                         as REGISTERED_REP_ENTER_REP
  , STATE_COUNTRY_CODE                                                                                               as STATE_COUNTRY_CODE
  , SECURITIES_INSTRUCTIONS                                                                                          as SECURITIES_INSTRUCTIONS
  , PARENT_ACCOUNT                                                                                                   as PARENT_ACCOUNT
  , AGENCY_CODE                                                                                                      as AGENCY_CODE
  , PROCEEDS_INSTRUCTIONS                                                                                            as PROCEEDS_INSTRUCTIONS
  , CASH_DIVIDEND_INSTRUCTIONS                                                                                       as CASH_DIVIDEND_INSTRUCTIONS
  , TRADE_UNIT                                                                                                       as TRADE_UNIT
  , SHORT_NAME                                                                                                       as SHORT_NAME
  , ACCOUNT_CLASSIFICATION                                                                                           as ACCOUNT_CLASSIFICATION
  , CITIZEN_CODE                                                                                                     as CITIZEN_CODE
  , COUNTRY_OF_TAX_RESIDENCY                                                                                         as COUNTRY_OF_TAX_RESIDENCY
  , TRANSFER_LEGEND_CODE                                                                                             as TRANSFER_LEGEND_CODE
  , MARKET_MAKER_CODE                                                                                                as MARKET_MAKER_CODE
  , MINOR_EXECUTING_BROKER                                                                                           as MINOR_EXECUTING_BROKER
  , MINOR_CLEARING_BROKER                                                                                            as MINOR_CLEARING_BROKER
  , OFFSET_ACCOUNT                                                                                                   as OFFSET_ACCOUNT
  , OFFSET_SHORTNAME                                                                                                 as OFFSET_SHORTNAME
  , OFFSET_RR                                                                                                        as OFFSET_RR
  , case
        when nvl(OFFSET_COMMISSION, '') = '' then null::number(18, 2)
        else OFFSET_COMMISSION::int * .01 end::number(18, 2)                                                         as OFFSET_COMMISSION
  , SOURCE                                                                                                           as SOURCE
  , TYPE_OF_ORDER                                                                                                    as TYPE_OF_ORDER
  , CONFIRMATION_PRINT                                                                                               as CONFIRMATION_PRINT
  , COMMISSION_ACCUMULATION                                                                                          as COMMISSION_ACCUMULATION
  , COMMISSION_SCHEDULE                                                                                              as COMMISSION_SCHEDULE
  , BLOTTER_OVERRIDE_CODE                                                                                            as BLOTTER_OVERRIDE_CODE
  , NSCC_CODE                                                                                                        as NSCC_CODE
  , COMMISSION_CONCESSION_CODE_1                                                                                     as COMMISSION_CONCESSION_CODE_1
  , case
        when nvl(QUANTITY, '') = '' then null::number(18, 5)
        else QUANTITY::int * .00001 end::number(18, 5)                                                               as QUANTITY
  , case
        when nvl(PRICE, '') = '' then null::number(18, 9)
        else PRICE::int * .000000001 end::number(18, 9)                                                              as PRICE
  , ALPHAPRICE_DOLLAR::int                                                                                           as ALPHAPRICE_DOLLAR
  , ALPHAPRICE_SPACE                                                                                                 as ALPHAPRICE_SPACE
  , ALPHAPRICE_FRACTION                                                                                              as ALPHAPRICE_FRACTION
  , case
        when nvl(PLUS_MINUS, '') = '' then null::number(18, 9)
        else PLUS_MINUS::int * .000000001 end::number(18, 9)                                                         as PLUS_MINUS
  , case
        when nvl(PRINCIPAL, '') = '' then null::number(18, 2)
        else PRINCIPAL::int * .01 end::number(18, 2)                                                                 as PRINCIPAL
  , case
        when nvl(ACCRUED_INTEREST, '') = '' then null::number(18, 2)
        else ACCRUED_INTEREST::int * .01 end::number(18, 2)                                                          as ACCRUED_INTEREST
  , case
        when nvl(TRADE_COMMISSION, '') = '' then null::number(18, 2)
        else TRADE_COMMISSION::int * .01 end::number(18, 2)                                                          as TRADE_COMMISSION
  , case
        when nvl(STATE_TAX, '') = '' then null::number(18, 2)
        else STATE_TAX::int * .01 end::number(18, 2)                                                                 as STATE_TAX
  , case
        when nvl(SEC_FEE, '') = '' then null::number(18, 2)
        else SEC_FEE::int * .01 end::number(18, 2)                                                                   as SEC_FEE
  , case
        when nvl(OPTIONS_REGULATORY_FEE, '') = '' then null::number(18, 2)
        else OPTIONS_REGULATORY_FEE::int * .01 end::number(18, 2)                                                    as OPTIONS_REGULATORY_FEE
  , case
        when nvl(SERVICE_CHARGE_MISC_FEE, '') = '' then null::number(18, 2)
        else SERVICE_CHARGE_MISC_FEE::int * .01 end::number(18, 2)                                                   as SERVICE_CHARGE_MISC_FEE
  , case
        when nvl(NET, '') = '' then null::number(18, 2)
        else NET::int * .01 end::number(18, 2)                                                                       as NET
  , case
        when nvl(TRADE_CONCESSION, '') = '' then null::number(18, 2)
        else TRADE_CONCESSION::int * .01 end::number(18, 2)                                                          as TRADE_CONCESSION
  , case
        when nvl(STANDARD_COMMISSION, '') = '' then null::number(18, 2)
        else STANDARD_COMMISSION::int * .01 end::number(18, 2)                                                       as STANDARD_COMMISSION
  , NUMBER_OF_SECURITY_DESCRIPTION_LINES::int                                                                        as NUMBER_OF_SECURITY_DESCRIPTION_LINES
  , SECURITY_DESCRIPTION_LINE_1                                                                                      as SECURITY_DESCRIPTION_LINE_1
  , SECURITY_DESCRIPTION_LINE_2                                                                                      as SECURITY_DESCRIPTION_LINE_2
  , SECURITY_DESCRIPTION_LINE_3                                                                                      as SECURITY_DESCRIPTION_LINE_3
  , SECURITY_DESCRIPTION_LINE_4                                                                                      as SECURITY_DESCRIPTION_LINE_4
  , SECURITY_DESCRIPTION_LINE_5                                                                                      as SECURITY_DESCRIPTION_LINE_5
  , SECURITY_DESCRIPTION_LINE_6                                                                                      as SECURITY_DESCRIPTION_LINE_6
  , SECURITY_DESCRIPTION_LINE_7                                                                                      as SECURITY_DESCRIPTION_LINE_7
  , SECURITY_DESCRIPTION_LINE_8                                                                                      as SECURITY_DESCRIPTION_LINE_8
  , SECURITY_DESCRIPTION_LINE_9                                                                                      as SECURITY_DESCRIPTION_LINE_9
  , CONFIRM_LEGEND_CODE_1                                                                                            as CONFIRM_LEGEND_CODE_1
  , CONFIRM_LEGEND_CODE_2                                                                                            as CONFIRM_LEGEND_CODE_2
  , REGISTERED_REP_EXEC_REP_RR2                                                                                      as REGISTERED_REP_EXEC_REP_RR2
  , case
        when nvl(COMMISSION_DISCOUNT_PERCENT, '') = '' then null::number(18, 4)
        else COMMISSION_DISCOUNT_PERCENT::int * .0001 end::number(18, 4)                                             as COMMISSION_DISCOUNT_PERCENT
  , case
        when nvl(STRIKE_PRICE, '') = '' then null::number(18, 3)
        else STRIKE_PRICE::int * .001 end::number(18, 3)                                                             as STRIKE_PRICE
  , COMMISSION_CONCESSION_CODE_2                                                                                     as COMMISSION_CONCESSION_CODE_2
  , case
        when nvl(FUND_LOAD_OVERRIDE, '') = '' then null::number(18, 2)
        else FUND_LOAD_OVERRIDE::int * .01 end::number(18, 2)                                                        as FUND_LOAD_OVERRIDE
  , QUANTITY_TYPE                                                                                                    as QUANTITY_TYPE
  , CONFIRM_LINE_NUMBER                                                                                              as CONFIRM_LINE_NUMBER
  , EXCHANGE_LINE_NUMBER                                                                                             as EXCHANGE_LINE_NUMBER
  , case
        when nvl(YIELD, '') = '' then null::number(18, 3)
        else YIELD::int * .001 end::number(18, 3)                                                                    as YIELD
  , YIELD_TYPE                                                                                                       as YIELD_TYPE
  , case
        when nvl(YIELD_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(YIELD_DATE, 'MMDDYY') end::date                                                                 as YIELD_DATE
  , case
        when nvl(YIELD_PRICE, '') = '' then null::number(18, 3)
        else YIELD_PRICE::int * .001 end::number(18, 3)                                                              as YIELD_PRICE
  , TRADING_AWAY_CODE                                                                                                as TRADING_AWAY_CODE
  , MAJOR_CLEARING_BROKER                                                                                            as MAJOR_CLEARING_BROKER
  , MAJOR_EXECUTING_BROKER                                                                                           as MAJOR_EXECUTING_BROKER
  , EXECUTION_TIME_1                                                                                                 as EXECUTION_TIME_1
  , BRANCH_2                                                                                                         as BRANCH_2
  , COMPLEX_ORDER_INDICATOR                                                                                          as COMPLEX_ORDER_INDICATOR
  , MARKET_PLACE                                                                                                     as MARKET_PLACE
  , MARKET_SEQUENCE                                                                                                  as MARKET_SEQUENCE
  , TIME_IN_FORCE_CODE                                                                                               as TIME_IN_FORCE_CODE
  , AUTO_EXEC_CODE                                                                                                   as AUTO_EXEC_CODE
  , ISSUER                                                                                                           as ISSUER
  , ISSUER_TYPE                                                                                                      as ISSUER_TYPE
  , BOND_TRADER                                                                                                      as BOND_TRADER
  , BOND_CLASS_CODE                                                                                                  as BOND_CLASS_CODE
  , case
        when nvl(ADDITIONAL_MARKUP, '') = '' then null::number(18, 9)
        else ADDITIONAL_MARKUP::int * .000000001 end::number(18, 9)                                                  as ADDITIONAL_MARKUP
  , TERMINAL_ID                                                                                                      as TERMINAL_ID
  , REGISTERED_REP_OWNING_REP_RR                                                                                     as REGISTERED_REP_OWNING_REP_RR
  , case
        when nvl(FUND_LOAD_PERCENT, '') = '' then null::number(18, 2)
        else FUND_LOAD_PERCENT::int * .01 end::number(18, 2)                                                         as FUND_LOAD_PERCENT
  , PRODUCT_CODE                                                                                                     as PRODUCT_CODE
  , TRADING_FLAT_CODE                                                                                                as TRADING_FLAT_CODE
  , "12B1_CODE"                                                                                                      as "12B1_CODE"
  , ADDITIONAL_FEE_CODE_1                                                                                            as ADDITIONAL_FEE_CODE_1
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_1, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_1::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_1
  , ADDITIONAL_FEE_CODE_2                                                                                            as ADDITIONAL_FEE_CODE_2
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_2, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_2::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_2
  , ADDITIONAL_FEE_CODE_3                                                                                            as ADDITIONAL_FEE_CODE_3
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_3, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_3::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_3
  , ADDITIONAL_FEE_CODE_4                                                                                            as ADDITIONAL_FEE_CODE_4
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_4, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_4::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_4
  , ADDITIONAL_FEE_CODE_5                                                                                            as ADDITIONAL_FEE_CODE_5
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_5, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_5::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_5
  , ADDITIONAL_FEE_CODE_6                                                                                            as ADDITIONAL_FEE_CODE_6
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_6, '') = '' then null::number(18, 2)
        else ADDITIONAL_FEE_AMOUNT_6::int * .01 end::number(18, 2)                                                   as ADDITIONAL_FEE_AMOUNT_6
  , INSTITUTIONAL_THIRD_PARTY                                                                                        as INSTITUTIONAL_THIRD_PARTY
  , BORD_TORD_CODE                                                                                                   as BORD_TORD_CODE
  , MUTUAL_FUND_DTC_NUMBER                                                                                           as MUTUAL_FUND_DTC_NUMBER
  , TRADE_ENTRY                                                                                                      as TRADE_ENTRY
  , ENTRY_SEQUENCE_NUMBER                                                                                            as ENTRY_SEQUENCE_NUMBER
  , SOLICITED_CODE                                                                                                   as SOLICITED_CODE
  , ELECTRONIC_TRADE_ID                                                                                              as ELECTRONIC_TRADE_ID
  , ROLLUP_COUNT                                                                                                     as ROLLUP_COUNT
  , CONFIRM_LEGEND_CODE_3                                                                                            as CONFIRM_LEGEND_CODE_3
  , CONFIRM_LEGEND_CODE_4                                                                                            as CONFIRM_LEGEND_CODE_4
  , RELATIONSHIP_ID                                                                                                  as RELATIONSHIP_ID
  , CAPACITY_CODE                                                                                                    as CAPACITY_CODE
  , CONFIRM_LEGEND_CODE_5                                                                                            as CONFIRM_LEGEND_CODE_5
  , CONFIRM_LEGEND_CODE_6                                                                                            as CONFIRM_LEGEND_CODE_6
  , ALTERNATIVE_INVESTMENT_CODE                                                                                      as ALTERNATIVE_INVESTMENT_CODE
  , case
        when nvl(EXPANDED_YIELD, '') = '' then null::number(18, 6)
        when EXPANDED_YIELD_SIGN in ('0', '+', '') then (EXPANDED_YIELD::int * .000001)::number(18, 6)
        else (EXPANDED_YIELD::int * -.000001)::number(18, 6) end::number(18, 6)                                      as EXPANDED_YIELD
  , OPTION_CONTRACT_ID                                                                                               as OPTION_CONTRACT_ID
  , case
        when nvl(OPTION_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_EXPIRATION_DATE, 'YYMMDD') end::date                                                     as OPTION_EXPIRATION_DATE
  , OPTION_CALL_PUT_INDICATOR                                                                                        as OPTION_CALL_PUT_INDICATOR
  , case
        when nvl(OPTION_STRIKE_PRICE, '') = '' then null::number(18, 3)
        else OPTION_STRIKE_PRICE::int * .001 end::number(18, 3)                                                      as OPTION_STRIKE_PRICE
  , OPTION_SYMBOL_ID                                                                                                 as OPTION_SYMBOL_ID
  , COST_BASIS_DISPOSAL_METHOD_CODE                                                                                  as COST_BASIS_DISPOSAL_METHOD_CODE
  , case
        when nvl(REVENUE_CLEARING_CHARGE_AMOUNT, '') = '' then null::number(18, 2)
        when REVENUE_CLEARING_CHARGE_SIGN in ('0', '+', '')
            then (REVENUE_CLEARING_CHARGE_AMOUNT::int * .01)::number(18, 2)
        else (REVENUE_CLEARING_CHARGE_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                          as REVENUE_CLEARING_CHARGE_AMOUNT
  , case
        when nvl(REVENUE_MISCELLANEOUS_FEE_AMOUNT, '') = '' then null::number(18, 2)
        when REVENUE_MISCELLANEOUS_FEE_SIGN in ('0', '+', '')
            then (REVENUE_MISCELLANEOUS_FEE_AMOUNT::int * .01)::number(18, 2)
        else (REVENUE_MISCELLANEOUS_FEE_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                        as REVENUE_MISCELLANEOUS_FEE_AMOUNT
  , PRODUCT_LEVEL                                                                                                    as PRODUCT_LEVEL
  , CONCESSION_CODE                                                                                                  as CONCESSION_CODE
  , PURCHASE_TYPE_CODE                                                                                               as PURCHASE_TYPE_CODE
  , TRADE_DEFINITION_TYPE                                                                                            as TRADE_DEFINITION_TYPE
  , TRADE_DEFINITION_TRADE_ID                                                                                        as TRADE_DEFINITION_TRADE_ID
  , case
        when nvl(REVENUE_COMMISSION_AMOUNT, '') = '' then null::number(18, 2)
        when REVENUE_COMMISSION_SIGN in ('0', '+', '') then (REVENUE_COMMISSION_AMOUNT::int * .01)::number(18, 2)
        else (REVENUE_COMMISSION_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                               as REVENUE_COMMISSION_AMOUNT
  , case
        when nvl(REVENUE_CONCESSION_AMOUNT, '') = '' then null::number(18, 2)
        when REVENUE_CONCESSION_SIGN in ('0', '+', '') then (REVENUE_CONCESSION_AMOUNT::int * .01)::number(18, 2)
        else (REVENUE_CONCESSION_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                               as REVENUE_CONCESSION_AMOUNT
  , case
        when nvl(REVENUE_LOAD_AMOUNT, '') = '' then null::number(18, 2)
        when REVENUE_LOAD_SIGN in ('0', '+', '') then (REVENUE_LOAD_AMOUNT::int * .01)::number(18, 2)
        else (REVENUE_LOAD_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                                     as REVENUE_LOAD_AMOUNT
  , ORDER_REFERENCE_NUMBER                                                                                           as ORDER_REFERENCE_NUMBER
  , INPUT_COMMISSION_AMOUNT                                                                                          as INPUT_COMMISSION_AMOUNT
  , CONFIRM_LEGEND_CODE_7                                                                                            as CONFIRM_LEGEND_CODE_7
  , CONFIRM_LEGEND_CODE_8                                                                                            as CONFIRM_LEGEND_CODE_8
  , ORIGINAL_DESCRIPTION_1                                                                                           as ORIGINAL_DESCRIPTION_1
  , ORIGINAL_DESCRIPTION_2                                                                                           as ORIGINAL_DESCRIPTION_2
  , EXECUTION_TIME_2                                                                                                 as EXECUTION_TIME_2
  , REGISTERED_REP_PAY_TO_REP                                                                                        as REGISTERED_REP_PAY_TO_REP
  , case
        when nvl(CLEARING_CHARGE, '') = '' then null::number(18, 2)
        when CLEARING_CHARGE_SIGN in ('0', '+', '') then (CLEARING_CHARGE::int * .01)::number(18, 2)
        else (CLEARING_CHARGE::int * -.01)::number(18, 2) end::number(18, 2)                                         as CLEARING_CHARGE
  , case
        when nvl(EXECUTION_FEE, '') = '' then null::number(18, 2)
        when EXECUTION_FEE_SIGN in ('0', '+', '') then (EXECUTION_FEE::int * .01)::number(18, 2)
        else (EXECUTION_FEE::int * -.01)::number(18, 2) end::number(18, 2)                                           as EXECUTION_FEE
  , case
        when nvl(FOREIGN_SURCHARGE, '') = '' then null::number(18, 2)
        when FOREIGN_SURCHARGE_SIGN in ('0', '+', '') then (FOREIGN_SURCHARGE::int * .01)::number(18, 2)
        else (FOREIGN_SURCHARGE::int * -.01)::number(18, 2) end::number(18, 2)                                       as FOREIGN_SURCHARGE
  , SPAWNING_SYSTEM_CODE                                                                                             as SPAWNING_SYSTEM_CODE
  , CLEARING_PRODUCT_CODE                                                                                            as CLEARING_PRODUCT_CODE
  , CLEARING_PRODUCT_TYPE                                                                                            as CLEARING_PRODUCT_TYPE
  , MANAGED_ACCOUNT_SOLUTIONS_MAS_CUSTODY_INDICATOR                                                                  as MANAGED_ACCOUNT_SOLUTIONS_MAS_CUSTODY_INDICATOR
  , ISIN                                                                                                             as ISIN
  , SEDOL                                                                                                            as SEDOL
  , CURRENCY_CODE_1                                                                                                  as CURRENCY_CODE_1
  , CURRENCY_CODE_2                                                                                                  as CURRENCY_CODE_2
  , case
        when nvl(LOCAL_CURRENCY_FEES, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_FEES_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_FEES::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_FEES::int * -.0001)::number(18, 4) end::number(18, 4)                                   as LOCAL_CURRENCY_FEES
  , case
        when nvl(LOCAL_CURRENCY_COMMISSION, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_COMMISSION_SIGN in ('0', '+', '')
            then (LOCAL_CURRENCY_COMMISSION::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_COMMISSION::int * -.0001)::number(18, 4) end::number(18, 4)                             as LOCAL_CURRENCY_COMMISSION
  , case
        when nvl(LOCAL_CURRENCY_PRICE, '') = '' then null::number(18, 8)
        else LOCAL_CURRENCY_PRICE::int * .00000001 end::number(18, 8)                                                as LOCAL_CURRENCY_PRICE
  , case
        when nvl(LOCAL_CURRENCY_PRINCIPAL, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_PRINCIPAL_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_PRINCIPAL::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_PRINCIPAL::int * -.0001)::number(18, 4) end::number(18, 4)                              as LOCAL_CURRENCY_PRINCIPAL
  , case
        when nvl(LOCAL_CURRENCY_INTEREST, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_INTEREST_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_INTEREST::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_INTEREST::int * -.0001)::number(18, 4) end::number(18, 4)                               as LOCAL_CURRENCY_INTEREST
  , case
        when nvl(LOCAL_CURRENCY_CAPITALIZED_INTEREST, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_CAPITALIZED_INTEREST_SIGN in ('0', '+', '')
            then (LOCAL_CURRENCY_CAPITALIZED_INTEREST::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_CAPITALIZED_INTEREST::int * -.0001)::number(18, 4) end::number(18, 4)                   as LOCAL_CURRENCY_CAPITALIZED_INTEREST
  , case
        when nvl(REPORTING_CURRENCY_CONVERSION_PRICE, '') = '' then null::number(18, 8)
        else REPORTING_CURRENCY_CONVERSION_PRICE::int * .00000001 end::number(18, 8)                                 as REPORTING_CURRENCY_CONVERSION_PRICE
  , FX_TRADE_INDICATOR                                                                                               as FX_TRADE_INDICATOR
  , FX_TRADE_LINK                                                                                                    as FX_TRADE_LINK
  , SHADO_COUNTRY_CODE                                                                                               as SHADO_COUNTRY_CODE
  , case
        when nvl(LOCAL_CURRENCY_CONCESSION, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_CONCESSION_SIGN in ('0', '+', '')
            then (LOCAL_CURRENCY_CONCESSION::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_CONCESSION::int * -.0001)::number(18, 4) end::number(18, 4)                             as LOCAL_CURRENCY_CONCESSION
  , case
        when nvl(REPORTING_CURRENCY_CONVERSION_RATE, '') = '' then null::number(18, 8)
        else REPORTING_CURRENCY_CONVERSION_RATE::int * .00000001 end::number(18, 8)                                  as REPORTING_CURRENCY_CONVERSION_RATE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ ref('fidelity_' ~ src ~ '_history__vw_raw_trdrev_td') }}
{%- endmacro -%}