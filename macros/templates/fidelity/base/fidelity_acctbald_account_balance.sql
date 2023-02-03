{%- macro fidelity_acctbald_account_balance(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_NUMBER                                                                          as RECORD_NUMBER
  , BRANCH                                                                                 as BRANCH
  , ACCOUNT_NUMBER                                                                         as ACCOUNT_NUMBER
  , case
        when nvl(LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_UPDATE_DATE, 'YYMMDD') end::date                                 as LAST_UPDATE_DATE
  , case
        when nvl(NETWORTH, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_1 in ('0', '+', '') then (NETWORTH::int * .01)::number(18, 2)
        else (NETWORTH::int * -.01)::number(18, 2) end::number(18, 2)                      as NETWORTH
  , case
        when nvl(CASH_COLLECTED_BALANCE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_2 in ('0', '+', '') then (CASH_COLLECTED_BALANCE::int * .01)::number(18, 2)
        else (CASH_COLLECTED_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)        as CASH_COLLECTED_BALANCE
  , case
        when nvl(COLLECTED_BALANCE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_3 in ('0', '+', '') then (COLLECTED_BALANCE::int * .01)::number(18, 2)
        else (COLLECTED_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)             as COLLECTED_BALANCE
  , case
        when nvl(NET_TRADE_DATE_BALANCE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_4 in ('0', '+', '') then (NET_TRADE_DATE_BALANCE::int * .01)::number(18, 2)
        else (NET_TRADE_DATE_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)        as NET_TRADE_DATE_BALANCE
  , case
        when nvl(NETWORTH_MARKET_VALUE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_5 in ('0', '+', '') then (NETWORTH_MARKET_VALUE::int * .01)::number(18, 2)
        else (NETWORTH_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)         as NETWORTH_MARKET_VALUE
  , case
        when nvl(CASH_MONEY_MARKETS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_6 in ('0', '+', '') then (CASH_MONEY_MARKETS::int * .01)::number(18, 2)
        else (CASH_MONEY_MARKETS::int * -.01)::number(18, 2) end::number(18, 2)            as CASH_MONEY_MARKETS
  , case
        when nvl(OPTION_MARKET_VALUE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_7 in ('0', '+', '') then (OPTION_MARKET_VALUE::int * .01)::number(18, 2)
        else (OPTION_MARKET_VALUE::int * -.01)::number(18, 2) end::number(18, 2)           as OPTION_MARKET_VALUE
  , case
        when nvl(OPTION_IN_MONEY_AMT, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_8 in ('0', '+', '') then (OPTION_IN_MONEY_AMT::int * .01)::number(18, 2)
        else (OPTION_IN_MONEY_AMT::int * -.01)::number(18, 2) end::number(18, 2)           as OPTION_IN_MONEY_AMT
  , case
        when nvl(MEMO_ADJUSTMENTS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_9 in ('0', '+', '') then (MEMO_ADJUSTMENTS::int * .01)::number(18, 2)
        else (MEMO_ADJUSTMENTS::int * -.01)::number(18, 2) end::number(18, 2)              as MEMO_ADJUSTMENTS
  , case
        when nvl(AVAILABLE_TO_PURCHASE_MARGIN, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_10 in ('0', '+', '') then (AVAILABLE_TO_PURCHASE_MARGIN::int * .01)::number(18, 2)
        else (AVAILABLE_TO_PURCHASE_MARGIN::int * -.01)::number(18, 2) end::number(18, 2)  as AVAILABLE_TO_PURCHASE_MARGIN
  , case
        when nvl(BUYING_POWER_CORP_BONDS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_11 in ('0', '+', '') then (BUYING_POWER_CORP_BONDS::int * .01)::number(18, 2)
        else (BUYING_POWER_CORP_BONDS::int * -.01)::number(18, 2) end::number(18, 2)       as BUYING_POWER_CORP_BONDS
  , case
        when nvl(BUYING_POWER_MUNI_BONDS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_12 in ('0', '+', '') then (BUYING_POWER_MUNI_BONDS::int * .01)::number(18, 2)
        else (BUYING_POWER_MUNI_BONDS::int * -.01)::number(18, 2) end::number(18, 2)       as BUYING_POWER_MUNI_BONDS
  , case
        when nvl(BUYING_POWER_GOVT_BONDS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_13 in ('0', '+', '') then (BUYING_POWER_GOVT_BONDS::int * .01)::number(18, 2)
        else (BUYING_POWER_GOVT_BONDS::int * -.01)::number(18, 2) end::number(18, 2)       as BUYING_POWER_GOVT_BONDS
  , case
        when nvl(HOUSE_SURPLUS_CALL, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_14 in ('0', '+', '') then (HOUSE_SURPLUS_CALL::int * .01)::number(18, 2)
        else (HOUSE_SURPLUS_CALL::int * -.01)::number(18, 2) end::number(18, 2)            as HOUSE_SURPLUS_CALL
  , case
        when nvl(NYSE_SURPLUS_CALL, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_15 in ('0', '+', '') then (NYSE_SURPLUS_CALL::int * .01)::number(18, 2)
        else (NYSE_SURPLUS_CALL::int * -.01)::number(18, 2) end::number(18, 2)             as NYSE_SURPLUS_CALL
  , case
        when nvl(SMA_FED_CALL, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_16 in ('0', '+', '') then (SMA_FED_CALL::int * .01)::number(18, 2)
        else (SMA_FED_CALL::int * -.01)::number(18, 2) end::number(18, 2)                  as SMA_FED_CALL
  , case
        when nvl(MINIMUM_EQUITY_CALL, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_17 in ('0', '+', '') then (MINIMUM_EQUITY_CALL::int * .01)::number(18, 2)
        else (MINIMUM_EQUITY_CALL::int * -.01)::number(18, 2) end::number(18, 2)           as MINIMUM_EQUITY_CALL
  , case
        when nvl(TOTAL_CORE_MONEY_MARKETS, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_18 in ('0', '+', '') then (TOTAL_CORE_MONEY_MARKETS::int * .01)::number(18, 2)
        else (TOTAL_CORE_MONEY_MARKETS::int * -.01)::number(18, 2) end::number(18, 2)      as TOTAL_CORE_MONEY_MARKETS
  , case
        when nvl(MARGIN_EQUITY, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_19 in ('0', '+', '') then (MARGIN_EQUITY::int * .01)::number(18, 2)
        else (MARGIN_EQUITY::int * -.01)::number(18, 2) end::number(18, 2)                 as MARGIN_EQUITY
  , case
        when nvl(MARGIN_LIQUIDATING_EQUITY, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_20 in ('0', '+', '') then (MARGIN_LIQUIDATING_EQUITY::int * .01)::number(18, 2)
        else (MARGIN_LIQUIDATING_EQUITY::int * -.01)::number(18, 2) end::number(18, 2)     as MARGIN_LIQUIDATING_EQUITY
  , case
        when nvl(MARGIN_EQUITY_PERCENTAGE, '') = '' then null::number(18, 2)
        else MARGIN_EQUITY_PERCENTAGE::int * .01 end::number(18, 2)                        as MARGIN_EQUITY_PERCENTAGE
  , case
        when nvl(FED_CALL_REDUCTION, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_21 in ('0', '+', '') then (FED_CALL_REDUCTION::int * .01)::number(18, 2)
        else (FED_CALL_REDUCTION::int * -.01)::number(18, 2) end::number(18, 2)            as FED_CALL_REDUCTION
  , case
        when nvl(HOUSE_CALL_REDUCTION, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_22 in ('0', '+', '') then (HOUSE_CALL_REDUCTION::int * .01)::number(18, 2)
        else (HOUSE_CALL_REDUCTION::int * -.01)::number(18, 2) end::number(18, 2)          as HOUSE_CALL_REDUCTION
  , case
        when nvl(NYSE_CALL_REDUCTION, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_23 in ('0', '+', '') then (NYSE_CALL_REDUCTION::int * .01)::number(18, 2)
        else (NYSE_CALL_REDUCTION::int * -.01)::number(18, 2) end::number(18, 2)           as NYSE_CALL_REDUCTION
  , case
        when nvl(UNCOLLECTED_BALANCE, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_24 in ('0', '+', '') then (UNCOLLECTED_BALANCE::int * .01)::number(18, 2)
        else (UNCOLLECTED_BALANCE::int * -.01)::number(18, 2) end::number(18, 2)           as UNCOLLECTED_BALANCE
  , case
        when nvl(MINIMUM_EQUITY_CALL_REDUCTION, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_25 in ('0', '+', '') then (MINIMUM_EQUITY_CALL_REDUCTION::int * .01)::number(18, 2)
        else (MINIMUM_EQUITY_CALL_REDUCTION::int * -.01)::number(18, 2) end::number(18, 2) as MINIMUM_EQUITY_CALL_REDUCTION
  , TRANSFER_LEGEND_CODE                                                                   as TRANSFER_LEGEND_CODE
  , MARGIN_PAPERS_SWITCH                                                                   as MARGIN_PAPERS_SWITCH
  , POSITION_SWITCH                                                                        as POSITION_SWITCH
  , UNPRICED_POSITIONS_SWITCH                                                              as UNPRICED_POSITIONS_SWITCH
  , EMPLOYEE_ACCOUNT_SWITCH                                                                as EMPLOYEE_ACCOUNT_SWITCH
  , TYPE_OF_ACCOUNT_SWITCH                                                                 as TYPE_OF_ACCOUNT_SWITCH
  , SHORT_POSITION_SWITCH                                                                  as SHORT_POSITION_SWITCH
  , LONG_POSITION_SWITCH                                                                   as LONG_POSITION_SWITCH
  , MEMO_ENTRIES_SWITCH                                                                    as MEMO_ENTRIES_SWITCH
  , DAY_TRADES_SWITCH                                                                      as DAY_TRADES_SWITCH
  , POSSIBLE_LIQUIDATIONS_SWITCH                                                           as POSSIBLE_LIQUIDATIONS_SWITCH
  , MINIMUM_FEDCALL_TRANS_SWITCH                                                           as MINIMUM_FEDCALL_TRANS_SWITCH
  , ACCOUNT_TYPE_RECORD_COUNT                                                              as ACCOUNT_TYPE_RECORD_COUNT
  , SUPER_BRANCH                                                                           as SUPER_BRANCH
  , case
        when nvl(AVAILABLE_TO_PURCHASE_CASH, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_26 in ('0', '+', '') then (AVAILABLE_TO_PURCHASE_CASH::int * .01)::number(18, 2)
        else (AVAILABLE_TO_PURCHASE_CASH::int * -.01)::number(18, 2) end::number(18, 2)    as AVAILABLE_TO_PURCHASE_CASH
  , case
        when nvl(AVAILABLE_TO, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_27 in ('0', '+', '') then (AVAILABLE_TO::int * .01)::number(18, 2)
        else (AVAILABLE_TO::int * -.01)::number(18, 2) end::number(18, 2)                  as AVAILABLE_TO
  , case
        when nvl(AVAILABLE_TO_PURCHASE_NON_MGN, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_28 in ('0', '+', '') then (AVAILABLE_TO_PURCHASE_NON_MGN::int * .01)::number(18, 2)
        else (AVAILABLE_TO_PURCHASE_NON_MGN::int * -.01)::number(18, 2) end::number(18, 2) as AVAILABLE_TO_PURCHASE_NON_MGN
  , case
        when nvl(CUSTOMER_FACING_NETWORTH, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_29 in ('0', '+', '') then (CUSTOMER_FACING_NETWORTH::int * .01)::number(18, 2)
        else (CUSTOMER_FACING_NETWORTH::int * -.01)::number(18, 2) end::number(18, 2)      as CUSTOMER_FACING_NETWORTH
  , ACCOUNT_TYPE_1                                                                         as ACCOUNT_TYPE_1
  , case
        when nvl(MARKET_VALUE_1, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_30 in ('0', '+', '') then (MARKET_VALUE_1::int * .01)::number(18, 2)
        else (MARKET_VALUE_1::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_1
  , case
        when nvl(TRADE_DATE_BALANCE_1, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_31 in ('0', '+', '') then (TRADE_DATE_BALANCE_1::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_1::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_1
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_1, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_32 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_1::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_1::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_1
  , ACCOUNT_TYPE_2                                                                         as ACCOUNT_TYPE_2
  , case
        when nvl(MARKET_VALUE_2, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_33 in ('0', '+', '') then (MARKET_VALUE_2::int * .01)::number(18, 2)
        else (MARKET_VALUE_2::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_2
  , case
        when nvl(TRADE_DATE_BALANCE_2, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_34 in ('0', '+', '') then (TRADE_DATE_BALANCE_2::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_2::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_2
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_2, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_35 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_2::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_2::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_2
  , ACCOUNT_TYPE_3                                                                         as ACCOUNT_TYPE_3
  , case
        when nvl(MARKET_VALUE_3, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_36 in ('0', '+', '') then (MARKET_VALUE_3::int * .01)::number(18, 2)
        else (MARKET_VALUE_3::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_3
  , case
        when nvl(TRADE_DATE_BALANCE_3, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_37 in ('0', '+', '') then (TRADE_DATE_BALANCE_3::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_3::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_3
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_3, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_38 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_3::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_3::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_3
  , ACCOUNT_TYPE_4                                                                         as ACCOUNT_TYPE_4
  , case
        when nvl(MARKET_VALUE_4, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_39 in ('0', '+', '') then (MARKET_VALUE_4::int * .01)::number(18, 2)
        else (MARKET_VALUE_4::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_4
  , case
        when nvl(TRADE_DATE_BALANCE_4, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_40 in ('0', '+', '') then (TRADE_DATE_BALANCE_4::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_4::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_4
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_4, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_41 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_4::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_4::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_4
  , ACCOUNT_TYPE_5                                                                         as ACCOUNT_TYPE_5
  , case
        when nvl(MARKET_VALUE_5, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_42 in ('0', '+', '') then (MARKET_VALUE_5::int * .01)::number(18, 2)
        else (MARKET_VALUE_5::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_5
  , case
        when nvl(TRADE_DATE_BALANCE_5, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_43 in ('0', '+', '') then (TRADE_DATE_BALANCE_5::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_5::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_5
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_5, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_44 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_5::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_5::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_5
  , ACCOUNT_TYPE_6                                                                         as ACCOUNT_TYPE_6
  , case
        when nvl(MARKET_VALUE_6, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_45 in ('0', '+', '') then (MARKET_VALUE_6::int * .01)::number(18, 2)
        else (MARKET_VALUE_6::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_6
  , case
        when nvl(TRADE_DATE_BALANCE_6, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_46 in ('0', '+', '') then (TRADE_DATE_BALANCE_6::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_6::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_6
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_6, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_47 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_6::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_6::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_6
  , ACCOUNT_TYPE_7                                                                         as ACCOUNT_TYPE_7
  , case
        when nvl(MARKET_VALUE_7, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_48 in ('0', '+', '') then (MARKET_VALUE_7::int * .01)::number(18, 2)
        else (MARKET_VALUE_7::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_7
  , case
        when nvl(TRADE_DATE_BALANCE_7, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_49 in ('0', '+', '') then (TRADE_DATE_BALANCE_7::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_7::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_7
  , SETTLEMENT_DATE                                                                        as SETTLEMENT_DATE
  , ACCOUNT_TYPE_8                                                                         as ACCOUNT_TYPE_8
  , case
        when nvl(MARKET_VALUE_8, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_51 in ('0', '+', '') then (MARKET_VALUE_8::int * .01)::number(18, 2)
        else (MARKET_VALUE_8::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_8
  , case
        when nvl(TRADE_DATE_BALANCE_8, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_52 in ('0', '+', '') then (TRADE_DATE_BALANCE_8::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_8::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_8
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_7, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_53 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_7::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_7::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_7
  , ACCOUNT_TYPE_9                                                                         as ACCOUNT_TYPE_9
  , case
        when nvl(MARKET_VALUE_9, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_54 in ('0', '+', '') then (MARKET_VALUE_9::int * .01)::number(18, 2)
        else (MARKET_VALUE_9::int * -.01)::number(18, 2) end::number(18, 2)                as MARKET_VALUE_9
  , case
        when nvl(TRADE_DATE_BALANCE_9, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_55 in ('0', '+', '') then (TRADE_DATE_BALANCE_9::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_9::int * -.01)::number(18, 2) end::number(18, 2)          as TRADE_DATE_BALANCE_9
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_8, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_56 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_8::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_8::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_8
  , ACCOUNT_TYPE_10                                                                        as ACCOUNT_TYPE_10
  , case
        when nvl(MARKET_VALUE_10, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_57 in ('0', '+', '') then (MARKET_VALUE_10::int * .01)::number(18, 2)
        else (MARKET_VALUE_10::int * -.01)::number(18, 2) end::number(18, 2)               as MARKET_VALUE_10
  , case
        when nvl(TRADE_DATE_BALANCE_10, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_58 in ('0', '+', '') then (TRADE_DATE_BALANCE_10::int * .01)::number(18, 2)
        else (TRADE_DATE_BALANCE_10::int * -.01)::number(18, 2) end::number(18, 2)         as TRADE_DATE_BALANCE_10
  , case
        when nvl(SETTLEMENT_DATE_BALANCE_9, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_59 in ('0', '+', '') then (SETTLEMENT_DATE_BALANCE_9::int * .01)::number(18, 2)
        else (SETTLEMENT_DATE_BALANCE_9::int * -.01)::number(18, 2) end::number(18, 2)     as SETTLEMENT_DATE_BALANCE_9
  , PORTFOLIO_MARGIN_INDICATOR                                                             as PORTFOLIO_MARGIN_INDICATOR
  , MASTER_SECURITY_LENDING_AGREEMENT_MSLA_INDICATOR                                       as MASTER_SECURITY_LENDING_AGREEMENT_MSLA_INDICATOR
  , RELATIONSHIP_TYPE_CODE                                                                 as RELATIONSHIP_TYPE_CODE
  , MULTI_CURRENCY_ACCOUNT_INDICATOR                                                       as MULTI_CURRENCY_ACCOUNT_INDICATOR
  , TRUST_ACCOUNTING                                                                       as TRUST_ACCOUNTING
  , NON_PURPOSE_LOAN_INDICATOR                                                             as NON_PURPOSE_LOAN_INDICATOR
  , NET_CASH_SETTLEMENT_INDICATOR                                                          as NET_CASH_SETTLEMENT_INDICATOR
  , WHEN_ISSUED_INDICATOR                                                                  as WHEN_ISSUED_INDICATOR
  , ACCOUNT_TYPE_5_INDICATOR                                                               as ACCOUNT_TYPE_5_INDICATOR
  , case
        when nvl(AVAILABLE_TO_BORROW, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_60 in ('0', '+', '') then (AVAILABLE_TO_BORROW::int * .01)::number(18, 2)
        else (AVAILABLE_TO_BORROW::int * -.01)::number(18, 2) end::number(18, 2)           as AVAILABLE_TO_BORROW
  , case
        when nvl(CASH_AVAILABLE_TO_WITHDRAW, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_61 in ('0', '+', '') then (CASH_AVAILABLE_TO_WITHDRAW::int * .01)::number(18, 2)
        else (CASH_AVAILABLE_TO_WITHDRAW::int * -.01)::number(18, 2) end::number(18, 2)    as CASH_AVAILABLE_TO_WITHDRAW
  , case
        when nvl(SETTLED_CASH, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_62 in ('0', '+', '') then (SETTLED_CASH::int * .01)::number(18, 2)
        else (SETTLED_CASH::int * -.01)::number(18, 2) end::number(18, 2)                  as SETTLED_CASH
  , case
        when nvl(UNSETTLED_CASH_CREDIT, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_63 in ('0', '+', '') then (UNSETTLED_CASH_CREDIT::int * .01)::number(18, 2)
        else (UNSETTLED_CASH_CREDIT::int * -.01)::number(18, 2) end::number(18, 2)         as UNSETTLED_CASH_CREDIT
  , case
        when nvl(UNSETTLED_CASH_DEBIT, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_64 in ('0', '+', '') then (UNSETTLED_CASH_DEBIT::int * .01)::number(18, 2)
        else (UNSETTLED_CASH_DEBIT::int * -.01)::number(18, 2) end::number(18, 2)          as UNSETTLED_CASH_DEBIT
  , case
        when nvl(AVAILABLE_TO_PAY, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_65 in ('0', '+', '') then (AVAILABLE_TO_PAY::int * .01)::number(18, 2)
        else (AVAILABLE_TO_PAY::int * -.01)::number(18, 2) end::number(18, 2)              as AVAILABLE_TO_PAY
  , case
        when nvl(CORE_SWEEP_FUND, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_66 in ('0', '+', '') then (CORE_SWEEP_FUND::int * .01)::number(18, 2)
        else (CORE_SWEEP_FUND::int * -.01)::number(18, 2) end::number(18, 2)               as CORE_SWEEP_FUND
  , case
        when nvl(NON_CORE_MONEY_MARKET_AMOUNT, '') = '' then null::number(18, 2)
        when BALANCE_FIELD_SIGN_67 in ('0', '+', '') then (NON_CORE_MONEY_MARKET_AMOUNT::int * .01)::number(18, 2)
        else (NON_CORE_MONEY_MARKET_AMOUNT::int * -.01)::number(18, 2) end::number(18, 2)  as NON_CORE_MONEY_MARKET_AMOUNT
  , is_head
  , is_current
  , effective_date
  , _created_at
  , _source_file
from {{ src }}
{%- endmacro -%}