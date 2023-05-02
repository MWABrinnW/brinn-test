{%- macro fidelity_actvyd_activity(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , 'fidelity'                                                                                 as custodian
  , {{ "'" ~ src.identifier.split('_')[1].lower() ~ "'" }}                                     as firm_source
  , RECORD_NUMBER                                                                              as RECORD_NUMBER
  , BRANCH                                                                                     as BRANCH
  , ACCOUNT_NUMBER                                                                             as ACCOUNT_NUMBER
  , ACCOUNT_TYPE                                                                               as ACCOUNT_TYPE
  , CUSIP                                                                                      as CUSIP
  , KEY_CODE                                                                                   as KEY_CODE
  , TRANSACTION_TYPE_MNEMONIC                                                                  as TRANSACTION_TYPE_MNEMONIC
  , BKPG_REFERENCE_NUMBER                                                                      as BKPG_REFERENCE_NUMBER
  , case
        when nvl(RUN_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(RUN_DATE, 'YYYYMMDD') end::date                                           as RUN_DATE
  , case
        when nvl(ENTRY_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(ENTRY_DATE, 'YYYYMMDD') end::date                                         as ENTRY_DATE
  , OFFSET_ACCT_TYPE                                                                           as OFFSET_ACCT_TYPE
  , case
        when nvl(BOOKKEEPING_QUANTITY, '') = '' then null::number(18, 5)
        when BOOKKEEPING_QUANTITY_SIGN in ('0', '+', '') then (BOOKKEEPING_QUANTITY::int * .00001)::number(18, 5)
        else (BOOKKEEPING_QUANTITY::int * -.00001)::number(18, 5) end::number(18, 5)           as BOOKKEEPING_QUANTITY
  , case
        when nvl(BOOKKEEPING_AMOUNT, '') = '' then null::number(18, 2)
        when BOOKKEEPING_AMOUNT_SIGN in ('0', '+', '') then (BOOKKEEPING_AMOUNT::int * .01)::number(18, 2)
        else (BOOKKEEPING_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)                as BOOKKEEPING_AMOUNT
  , case
        when nvl(BOOKKEEPING_MARKET_VALUE, '') = '' then null::number(18, 2)
        when BOOKKEEPING_MARKET_VALUE_SIGN in ('0', '+', '') then (BOOKKEEPING_MARKET_VALUE::int * .01)::number(18, 2)
        else (BOOKKEEPING_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)          as BOOKKEEPING_MARKET_VALUE
  , NUMBER_OF_SECURITY_DESCRIPTION_LINES::int                                                  as NUMBER_OF_SECURITY_DESCRIPTION_LINES
  , BKPG_DESCRIPTION_LINE_1                                                                    as BKPG_DESCRIPTION_LINE_1
  , BKPG_DESCRIPTION_LINE_2                                                                    as BKPG_DESCRIPTION_LINE_2
  , BKPG_DESCRIPTION_LINE_3                                                                    as BKPG_DESCRIPTION_LINE_3
  , BKPG_DESCRIPTION_LINE_4                                                                    as BKPG_DESCRIPTION_LINE_4
  , BKPG_DESCRIPTION_LINE_5                                                                    as BKPG_DESCRIPTION_LINE_5
  , BKPG_DESCRIPTION_LINE_6                                                                    as BKPG_DESCRIPTION_LINE_6
  , BKPG_DESCRIPTION_LINE_7                                                                    as BKPG_DESCRIPTION_LINE_7
  , BKPG_DESCRIPTION_LINE_8                                                                    as BKPG_DESCRIPTION_LINE_8
  , BKPG_DESCRIPTION_LINE_9                                                                    as BKPG_DESCRIPTION_LINE_9
  , case
        when nvl(TRADE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(TRADE_DATE, 'YYYYMMDD') end::date                                         as TRADE_DATE
  , SECURITIES_INSTRUCTIONS                                                                    as SECURITIES_INSTRUCTIONS
  , TRANSFER_LEGEND_CODE                                                                       as TRANSFER_LEGEND_CODE
  , ALPHAPRICE_DOLLAR                                                                          as ALPHAPRICE_DOLLAR
  , ALPHAPRICE_SPACE                                                                           as ALPHAPRICE_SPACE
  , ALPHAPRICE_FRACTION                                                                        as ALPHAPRICE_FRACTION
  , case
        when nvl(ACCRUED_INTEREST, '') = '' then null::number(18, 2)
        when BOOKKEEPING_ACCRUED_INTEREST_SIGN in ('0', '+', '') then (ACCRUED_INTEREST::int * .01)::number(18, 2)
        else (ACCRUED_INTEREST::int * -.01)::number(18, 2) end::number(18, 2)                  as ACCRUED_INTEREST
  , case
        when nvl(COMMISSION, '') = '' then null::number(18, 2)
        when COMMISSION_SIGN in ('0', '+', '') then (COMMISSION::int * .01)::number(18, 2)
        else (COMMISSION::int * -.01)::number(18, 2) end::number(18, 2)                        as COMMISSION
  , case
        when nvl(CONCESSION, '') = '' then null::number(18, 2)
        when CONCESSION_SIGN in ('0', '+', '') then (CONCESSION::int * .01)::number(18, 2)
        else (CONCESSION::int * -.01)::number(18, 2) end::number(18, 2)                        as CONCESSION
  , BUY_SELL_CODE                                                                              as BUY_SELL_CODE
  , MARKET_CODE                                                                                as MARKET_CODE
  , BLOTTER_CODE                                                                               as BLOTTER_CODE
  , TRADE_TYPE                                                                                 as TRADE_TYPE
  , CANCEL_CODE                                                                                as CANCEL_CODE
  , BKPG_CORRECTION_CODE                                                                       as BKPG_CORRECTION_CODE
  , BATCH                                                                                      as BATCH
  , REGISTERED_REP_ENTER_REP                                                                   as REGISTERED_REP_ENTER_REP
  , SECURITY_TYPE                                                                              as SECURITY_TYPE
  , SECURITY_TYPE_MODIFIER                                                                     as SECURITY_TYPE_MODIFIER
  , SECURITY_TYPE_CALCULATION                                                                  as SECURITY_TYPE_CALCULATION
  , ORDER_TYPE                                                                                 as ORDER_TYPE
  , AGENCY_CODE                                                                                as AGENCY_CODE
  , REGISTERED_REP_OWNING_REP_RR                                                               as REGISTERED_REP_OWNING_REP_RR
  , REGISTERED_REP_EXEC_REP_RR2                                                                as REGISTERED_REP_EXEC_REP_RR2
  , MULTI_CURRENCY_INDICATOR                                                                   as MULTI_CURRENCY_INDICATOR
  , case
        when nvl(CONSOLIDATED_PRIME_BROKER_FEES, '') = '' then null::number(18, 2)
        else CONSOLIDATED_PRIME_BROKER_FEES::int * .01 end::number(18, 2)                      as CONSOLIDATED_PRIME_BROKER_FEES
  , OPTION_SYMBOL_ID                                                                           as OPTION_SYMBOL_ID
  , OPTION_CONTRACT_ID                                                                         as OPTION_CONTRACT_ID
  , case
        when nvl(OPTION_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(OPTION_EXPIRATION_DATE, 'YYMMDD') end::date                               as OPTION_EXPIRATION_DATE
  , OPTION_CALL_PUT_INDICATOR                                                                  as OPTION_CALL_PUT_INDICATOR
  , case
        when nvl(OPTION_STRIKE_PRICE, '') = '' then null::number(18, 3)
        else OPTION_STRIKE_PRICE::int * .001 end::number(18, 3)                                as OPTION_STRIKE_PRICE
  , case
        when nvl(PRINCIPAL, '') = '' then null::number(18, 2)
        when PRINCIPAL_SIGN in ('0', '+', '') then (PRINCIPAL::int * .01)::number(18, 2)
        else (PRINCIPAL::int * -.01)::number(18, 2) end::number(18, 2)                         as PRINCIPAL
  , case
        when nvl(PRICE, '') = '' then null::number(18, 9)
        when PRICE_SIGN in ('0', '+', '') then (PRICE::int * .000000001)::number(18, 9)
        else (PRICE::int * -.000000001)::number(18, 9) end::number(18, 9)                      as PRICE
  , case
        when nvl(PRORATED_COMMISSION, '') = '' then null::number(18, 2)
        when PRORATED_COMMISSION_SIGN in ('0', '+', '') then (PRORATED_COMMISSION::int * .01)::number(18, 2)
        else (PRORATED_COMMISSION::int * -.01)::number(18, 2) end::number(18, 2)               as PRORATED_COMMISSION
  , case
        when nvl(STATE_TAX, '') = '' then null::number(18, 2)
        when STATE_TAX_SIGN in ('0', '+', '') then (STATE_TAX::int * .01)::number(18, 2)
        else (STATE_TAX::int * -.01)::number(18, 2) end::number(18, 2)                         as STATE_TAX
  , case
        when nvl(TICKET_CHARGE, '') = '' then null::number(18, 2)
        when TICKET_CHARGE_SIGN in ('0', '+', '') then (TICKET_CHARGE::int * .01)::number(18, 2)
        else (TICKET_CHARGE::int * -.01)::number(18, 2) end::number(18, 2)                     as TICKET_CHARGE
  , case
        when nvl(OPTIONS_REGULATORY_FEE, '') = '' then null::number(18, 2)
        when OPTIONS_REGULATORY_FEE_SIGN in ('0', '+', '') then (OPTIONS_REGULATORY_FEE::int * .01)::number(18, 2)
        else (OPTIONS_REGULATORY_FEE::int * -.01)::number(18, 2) end::number(18, 2)            as OPTIONS_REGULATORY_FEE
  , case
        when nvl(FUND_LOAD_PERCENT, '') = '' then null::number(18, 2)
        else FUND_LOAD_PERCENT::int * .01 end::number(18, 2)                                   as FUND_LOAD_PERCENT
  , case
        when nvl(FUND_LOAD_OVERRIDE, '') = '' then null::number(18, 2)
        else FUND_LOAD_OVERRIDE::int * .01 end::number(18, 2)                                  as FUND_LOAD_OVERRIDE
  , case
        when nvl(SEC_FEE, '') = '' then null::number(18, 2)
        when SEC_FEE_SIGN in ('0', '+', '') then (SEC_FEE::int * .01)::number(18, 2)
        else (SEC_FEE::int * -.01)::number(18, 2) end::number(18, 2)                           as SEC_FEE
  , case
        when nvl(SERVICE_CHARGE_MISC_FEE, '') = '' then null::number(18, 2)
        when SERVICE_CHARGE_MISC_FEE_SIGN in ('0', '+', '') then (SERVICE_CHARGE_MISC_FEE::int * .01)::number(18, 2)
        else (SERVICE_CHARGE_MISC_FEE::int * -.01)::number(18, 2) end::number(18, 2)           as SERVICE_CHARGE_MISC_FEE
  , ADDITIONAL_FEE_CODE_1                                                                      as ADDITIONAL_FEE_CODE_1
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_1, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_1 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_1::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_1::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_1
  , ADDITIONAL_FEE_CODE_2                                                                      as ADDITIONAL_FEE_CODE_2
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_2, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_2 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_2::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_2::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_2
  , ADDITIONAL_FEE_CODE_3                                                                      as ADDITIONAL_FEE_CODE_3
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_3, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_3 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_3::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_3::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_3
  , ADDITIONAL_FEE_CODE_4                                                                      as ADDITIONAL_FEE_CODE_4
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_4, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_4 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_4::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_4::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_4
  , ADDITIONAL_FEE_CODE_5                                                                      as ADDITIONAL_FEE_CODE_5
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_5, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_5 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_5::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_5::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_5
  , ADDITIONAL_FEE_CODE_6                                                                      as ADDITIONAL_FEE_CODE_6
  , case
        when nvl(ADDITIONAL_FEE_AMOUNT_6, '') = '' then null::number(18, 2)
        when ADDITIONAL_FEE_AMOUNT_SIGN_6 in ('0', '+', '') then (ADDITIONAL_FEE_AMOUNT_6::int * .01)::number(18, 2)
        else (ADDITIONAL_FEE_AMOUNT_6::int * -.01)::number(18, 2) end::number(18, 2)           as ADDITIONAL_FEE_AMOUNT_6
  , MINOR_EXECUTING_BROKER                                                                     as MINOR_EXECUTING_BROKER
  , MINOR_CLEARING_BROKER                                                                      as MINOR_CLEARING_BROKER
  , MAJOR_EXECUTING_BROKER                                                                     as MAJOR_EXECUTING_BROKER
  , MAJOR_CLEARING_BROKER                                                                      as MAJOR_CLEARING_BROKER
  , CHECK_NUMBER                                                                               as CHECK_NUMBER
  , TRUST_ACCOUNT_TAX_CODE                                                                     as TRUST_ACCOUNT_TAX_CODE
  , TRUST_ACCOUNT_TRANSACTION_CATEGORY                                                         as TRUST_ACCOUNT_TRANSACTION_CATEGORY
  , TRUST_ACCOUNT_ADDITIONAL_DESCRIPTION                                                       as TRUST_ACCOUNT_ADDITIONAL_DESCRIPTION
  , case
        when nvl(BOOKKEEPING_QUANTITY_EXPANDED, '') = '' then null::number(18, 5)
        when BOOKKEEPING_QUANTITY_SIGN_EXPANDED in ('0', '+', '')
            then (BOOKKEEPING_QUANTITY_EXPANDED::int * .00001)::number(18, 5)
        else (BOOKKEEPING_QUANTITY_EXPANDED::int * -.00001)::number(18, 5) end::number(18, 5)  as BOOKKEEPING_QUANTITY_EXPANDED
  , case
        when nvl(BOOKKEEPING_AMOUNT_EXPANDED, '') = '' then null::number(18, 2)
        when BOOKKEEPING_AMOUNT_SIGN_EXPANDED in ('0', '+', '')
            then (BOOKKEEPING_AMOUNT_EXPANDED::int * .01)::number(18, 2)
        else (BOOKKEEPING_AMOUNT_EXPANDED::int * -.01)::number(18, 2) end::number(18, 2)       as BOOKKEEPING_AMOUNT_EXPANDED
  , case
        when nvl(BOOKKEEPING_MARKET_VALUE_EXPANDED, '') = '' then null::number(18, 2)
        when BOOKKEEPING_MARKET_VALUE_SIGN_EXPANDED in ('0', '+', '')
            then (BOOKKEEPING_MARKET_VALUE_EXPANDED::int * .01)::number(18, 2)
        else (BOOKKEEPING_MARKET_VALUE_EXPANDED::int * -.01)::number(18, 2) end::number(18, 2) as BOOKKEEPING_MARKET_VALUE_EXPANDED
  , case
        when nvl(ACCRUED_INTEREST_EXPANDED, '') = '' then null::number(18, 2)
        when BOOKKEEPING_ACCRUED_INTEREST_SIGN_EXPANDED in ('0', '+', '')
            then (ACCRUED_INTEREST_EXPANDED::int * .01)::number(18, 2)
        else (ACCRUED_INTEREST_EXPANDED::int * -.01)::number(18, 2) end::number(18, 2)         as ACCRUED_INTEREST_EXPANDED
  , case
        when nvl(COMMISSION_EXPANDED, '') = '' then null::number(18, 2)
        when COMMISSION_SIGN_EXPANDED in ('0', '+', '') then (COMMISSION_EXPANDED::int * .01)::number(18, 2)
        else (COMMISSION_EXPANDED::int * -.01)::number(18, 2) end::number(18, 2)               as COMMISSION_EXPANDED
  , ISIN                                                                                       as ISIN
  , SEDOL                                                                                      as SEDOL
  , CURRENCY_CODE_1                                                                            as CURRENCY_CODE_1
  , CURRENCY_CODE_2                                                                            as CURRENCY_CODE_2
  , case
        when nvl(LOCAL_CURRENCY_PRICE, '') = '' then null::number(18, 2)
        else LOCAL_CURRENCY_PRICE::int * .01 end::number(18, 2)                                as LOCAL_CURRENCY_PRICE
  , case
        when nvl(LOCAL_CURRENCY_FEES, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_FEES_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_FEES::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_FEES::int * -.0001)::number(18, 4) end::number(18, 4)             as LOCAL_CURRENCY_FEES
  , case
        when nvl(REPORTING_CURRENCY_CONVERSION_RATE, '') = '' then null::number(18, 2)
        else REPORTING_CURRENCY_CONVERSION_RATE::int * .01 end::number(18, 2)                  as REPORTING_CURRENCY_CONVERSION_RATE
  , SHADO_PARENT_NUMBER                                                                        as SHADO_PARENT_NUMBER
  , SHADO_CHILD_NUMBER                                                                         as SHADO_CHILD_NUMBER
  , case
        when nvl(REPORTING_CURRENCY_CONVERSION_PRICE, '') = '' then null::number(18, 2)
        else REPORTING_CURRENCY_CONVERSION_PRICE::int * .01 end::number(18, 2)                 as REPORTING_CURRENCY_CONVERSION_PRICE
  , FX_TRADE_INDICATOR                                                                         as FX_TRADE_INDICATOR
  , FX_TRADE_LINK                                                                              as FX_TRADE_LINK
  , SHADO_COUNTRY_CODE                                                                         as SHADO_COUNTRY_CODE
  , case
        when nvl(LOCAL_CURRENCY_PRINCIPAL, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_PRINCIPAL_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_PRINCIPAL::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_PRINCIPAL::int * -.0001)::number(18, 4) end::number(18, 4)        as LOCAL_CURRENCY_PRINCIPAL
  , case
        when nvl(LOCAL_CURRENCY_COMMISSION, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_COMMISSION_SIGN in ('0', '+', '')
            then (LOCAL_CURRENCY_COMMISSION::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_COMMISSION::int * -.0001)::number(18, 4) end::number(18, 4)       as LOCAL_CURRENCY_COMMISSION
  , case
        when nvl(LOCAL_CURRENCY_INTEREST, '') = '' then null::number(18, 4)
        when LOCAL_CURRENCY_INTEREST_SIGN in ('0', '+', '') then (LOCAL_CURRENCY_INTEREST::int * .0001)::number(18, 4)
        else (LOCAL_CURRENCY_INTEREST::int * -.0001)::number(18, 4) end::number(18, 4)         as LOCAL_CURRENCY_INTEREST
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}