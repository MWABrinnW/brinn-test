{%- macro fidelity_nabase_101_account(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , 'fidelity'                                                                  as custodian
  , {{ "'" ~ src ~ "'" }}                                                       as firm_source
  , RECORD_TYPE                                                                 as RECORD_TYPE
  , RECORD_NUMBER                                                               as RECORD_NUMBER
  , FIRM                                                                        as FIRM
  , BRANCH                                                                      as BRANCH
  , ACCOUNT_NUMBER                                                              as ACCOUNT_NUMBER
  , NUMBER_OF_CONFIRMS                                                          as NUMBER_OF_CONFIRMS
  , NUMBER_OF_STATEMENTS                                                        as NUMBER_OF_STATEMENTS
  , IRS_NO                                                                      as IRS_NO
  , IRS_CODE                                                                    as IRS_CODE
  , ZIP_CODE                                                                    as ZIP_CODE
  , STATE_COUNTRY_CODE                                                          as STATE_COUNTRY_CODE
  , SEPARATE_ACCOUNT_MANAGER_INDICATOR                                          as SEPARATE_ACCOUNT_MANAGER_INDICATOR
  , SHORT_NAME                                                                  as SHORT_NAME
  , TRANSFER_LEGEND_CODE                                                        as TRANSFER_LEGEND_CODE
  , MANAGED_ACCOUNT_CODE                                                        as MANAGED_ACCOUNT_CODE
  , LAST_UPDATE_CODE                                                            as LAST_UPDATE_CODE
  , case
        when nvl(LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_UPDATE_DATE, 'YYYYMMDD') end::date                    as LAST_UPDATE_DATE
  , REGISTERED_REP_OWNING_REP_RR                                                as REGISTERED_REP_OWNING_REP_RR
  , TRADING_AUTH_CODE_BNAM                                                      as TRADING_AUTH_CODE_BNAM
  , EMPLOYEE_CODE                                                               as EMPLOYEE_CODE
  , CITIZEN_CODE                                                                as CITIZEN_CODE
  , COUNTRY_OF_TAX_RESIDENCY                                                    as COUNTRY_OF_TAX_RESIDENCY
  , DO_NOT_PURGE_CODE                                                           as DO_NOT_PURGE_CODE
  , ACCOUNT_CLASSIFICATION                                                      as ACCOUNT_CLASSIFICATION
  , PROCEEDS_INSTRUCTIONS                                                       as PROCEEDS_INSTRUCTIONS
  , SECURITIES_INSTRUCTIONS                                                     as SECURITIES_INSTRUCTIONS
  , CASH_DIVIDEND_INSTRUCTIONS                                                  as CASH_DIVIDEND_INSTRUCTIONS
  , DIVIDEND_ROUNDOUT_INSTRUCTION_CODE                                          as DIVIDEND_ROUNDOUT_INSTRUCTION_CODE
  , NON_OBJECTING_BENEFICIAL_OWNER_CODE                                         as NON_OBJECTING_BENEFICIAL_OWNER_CODE
  , COMMISSION_CLASS                                                            as COMMISSION_CLASS
  , case
        when nvl(COMMISSION_DISCOUNT_PERCENT, '') = '' then null::number(18, 2)
        else COMMISSION_DISCOUNT_PERCENT::int * .01 end::number(18, 2)          as COMMISSION_DISCOUNT_PERCENT
  , COMMISSION_SCHEDULE                                                         as COMMISSION_SCHEDULE
  , PARENT_BRANCH                                                               as PARENT_BRANCH
  , PARENT_ACCOUNT                                                              as PARENT_ACCOUNT
  , AGENCY_CODE                                                                 as AGENCY_CODE
  , REGISTERED_REP_EXEC_REP_RR2                                                 as REGISTERED_REP_EXEC_REP_RR2
  , NAP_RAP_INDICATOR                                                           as NAP_RAP_INDICATOR
  , case
        when nvl(NAP_RAP_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NAP_RAP_DATE, 'YYYYMMDD') end::date                        as NAP_RAP_DATE
  , INSTITUTIONAL_DELIVERY_CODE                                                 as INSTITUTIONAL_DELIVERY_CODE
  , INSTITUTIONAL_DELIVERY_NUMBER                                               as INSTITUTIONAL_DELIVERY_NUMBER
  , AGENT_BANK_NUMBER                                                           as AGENT_BANK_NUMBER
  , case
        when nvl(ESTABLISH_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(ESTABLISH_DATE, 'YYYYMMDD') end::date                      as ESTABLISH_DATE
  , RESTRICTION_CODE_PARTIAL                                                    as RESTRICTION_CODE_PARTIAL
  , BYPASS_MISC_FEE_INDICATOR                                                   as BYPASS_MISC_FEE_INDICATOR
  , INVESTMENT_CLUB_AGREEMENT                                                   as INVESTMENT_CLUB_AGREEMENT
  , JOINT_ACCOUNT_AGREEMENT                                                     as JOINT_ACCOUNT_AGREEMENT
  , TRUST_SERVICE_PROVIDER_TLA                                                  as TRUST_SERVICE_PROVIDER_TLA
  , CORPORATE_AGREEMENT                                                         as CORPORATE_AGREEMENT
  , TRUST_ACCOUNTING                                                            as TRUST_ACCOUNTING
  , PARTNER_AGREEMENT                                                           as PARTNER_AGREEMENT
  , MARGIN_AGREEMENT                                                            as MARGIN_AGREEMENT
  , OPTION_STATUS                                                               as OPTION_STATUS
  , OPTION_AGREEMENT                                                            as OPTION_AGREEMENT
  , NON_PURPOSE_LOAN_AGREEMENT                                                  as NON_PURPOSE_LOAN_AGREEMENT
  , TRUST_AGREEMENT                                                             as TRUST_AGREEMENT
  , NEW_ACCOUNT_PAPERS                                                          as NEW_ACCOUNT_PAPERS
  , SPECIAL_PRODUCT_PAPERS                                                      as SPECIAL_PRODUCT_PAPERS
  , OMNIBUS_CODE                                                                as OMNIBUS_CODE
  , SEGREGATION_CODE                                                            as SEGREGATION_CODE
  , case
        when nvl(SPECIAL_MARGIN_RATE, '') = '' then null::number(18, 2)
        else SPECIAL_MARGIN_RATE::int * .01 end::number(18, 2)                  as SPECIAL_MARGIN_RATE
  , MONEY_MOVEMENT_AUTHORIZATION_LEVEL                                          as MONEY_MOVEMENT_AUTHORIZATION_LEVEL
  , MASTER_SECURITY_LENDING_AGREEMENT_MSLA_INDICATOR                            as MASTER_SECURITY_LENDING_AGREEMENT_MSLA_INDICATOR
  , CORPORATE_TAX_STATUS                                                        as CORPORATE_TAX_STATUS
  , COST_BASIS_DISPOSAL_METHOD_CODE                                             as COST_BASIS_DISPOSAL_METHOD_CODE
  , DVP_SUPPRESSION_INDICATOR                                                   as DVP_SUPPRESSION_INDICATOR
  , case
        when nvl(ABANDONED_PROPERTY_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(ABANDONED_PROPERTY_DATE, 'YYYYMMDD') end::date             as ABANDONED_PROPERTY_DATE
  , PREFERRED_CUSTOMER_CODE                                                     as PREFERRED_CUSTOMER_CODE
  , PREFERRED_ZIP_CODE                                                          as PREFERRED_ZIP_CODE
  , OASYS_ACCESS_CODE                                                           as OASYS_ACCESS_CODE
  , OASYS_INSTITUTION                                                           as OASYS_INSTITUTION
  , NUMBER_OF_ADDRESS_LINES                                                     as NUMBER_OF_ADDRESS_LINES
  , NAME_AND_ADDRESS_LINE_1                                                     as NAME_AND_ADDRESS_LINE_1
  , NAME_AND_ADDRESS_LINE_2                                                     as NAME_AND_ADDRESS_LINE_2
  , NAME_AND_ADDRESS_LINE_3                                                     as NAME_AND_ADDRESS_LINE_3
  , NAME_AND_ADDRESS_LINE_4                                                     as NAME_AND_ADDRESS_LINE_4
  , NAME_AND_ADDRESS_LINE_5                                                     as NAME_AND_ADDRESS_LINE_5
  , NAME_AND_ADDRESS_LINE_6                                                     as NAME_AND_ADDRESS_LINE_6
  , REGISTRATION_TYPE                                                           as REGISTRATION_TYPE
  , case
        when nvl(BIRTH_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(BIRTH_DATE, 'YYYYMMDD') end::date                          as BIRTH_DATE
  , PRODUCT_LEVEL                                                               as PRODUCT_LEVEL
  , case
        when nvl(BIRTH_DATE_SHADOW, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(BIRTH_DATE_SHADOW, 'YYYYMMDD') end::date                   as BIRTH_DATE_SHADOW
  , MULTI_CURRENCY_ACCOUNT                                                      as MULTI_CURRENCY_ACCOUNT
  , PORTFOLIO_MARGIN_INDICATOR                                                  as PORTFOLIO_MARGIN_INDICATOR
  , ADVISOR_REPORTING_INDICATOR                                                 as ADVISOR_REPORTING_INDICATOR
  , LATE_TRADE_INDICATOR                                                        as LATE_TRADE_INDICATOR
  , MARGIN_SWEEP_CODE                                                           as MARGIN_SWEEP_CODE
  , SETUP_FEE_INDICATOR                                                         as SETUP_FEE_INDICATOR
  , PRODUCT_LEVEL_SUBTYPE_CODE                                                  as PRODUCT_LEVEL_SUBTYPE_CODE
  , W_8_FORM_CODE                                                               as W_8_FORM_CODE
  , case
        when nvl(W_8_CERTIFICATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(W_8_CERTIFICATION_DATE, 'YYYYMMDD') end::date              as W_8_CERTIFICATION_DATE
  , ACCOUNT_SOURCE_CODE                                                         as ACCOUNT_SOURCE_CODE
  , BDA_PARENT_ACCOUNT_NUMBER                                                   as BDA_PARENT_ACCOUNT_NUMBER
  , NET_ASSET_VALUE_INDICATOR                                                   as NET_ASSET_VALUE_INDICATOR
  , PLAN_NAME_CODE                                                              as PLAN_NAME_CODE
  , TEAM_CODE                                                                   as TEAM_CODE
  , FIAG_ACCOUNT_INDICATOR                                                      as FIAG_ACCOUNT_INDICATOR
  , PROXY_VOTE_INDICATOR                                                        as PROXY_VOTE_INDICATOR
  , PRIME_BROKER_INDICATOR                                                      as PRIME_BROKER_INDICATOR
  , TRANSFER_AGENT_FEE_CODE                                                     as TRANSFER_AGENT_FEE_CODE
  , TRANSFER_AGENT_MANAGEMENT_FEE_CODE                                          as TRANSFER_AGENT_MANAGEMENT_FEE_CODE
  , ACCOUNT_REGULATORY_CODE                                                     as ACCOUNT_REGULATORY_CODE
  , EXCHANGE_INDICATOR                                                          as EXCHANGE_INDICATOR
  , CASH_MANAGEMENT_FEE_SCHEDULE_CODE                                           as CASH_MANAGEMENT_FEE_SCHEDULE_CODE
  , MULTIPLE_MARGIN_INDICATOR                                                   as MULTIPLE_MARGIN_INDICATOR
  , ASSET_DISTRIBUTION_ACCOUNT_CODE                                             as ASSET_DISTRIBUTION_ACCOUNT_CODE
  , CONFIRM_PRINT_CODE                                                          as CONFIRM_PRINT_CODE
  , FAMILY_OFFICE_TYPE_CODE                                                     as FAMILY_OFFICE_TYPE_CODE
  , SHADOSUITE_DVP_CODE                                                         as SHADOSUITE_DVP_CODE
  , VENDOR_CODE                                                                 as VENDOR_CODE
  , CHARGEBACK_TYPE_CODE                                                        as CHARGEBACK_TYPE_CODE
  , CASH_MOVEMENT_TYPE_CODE                                                     as CASH_MOVEMENT_TYPE_CODE
  , FUTURES_STATUS_CODE                                                         as FUTURES_STATUS_CODE
  , BROKER_DEALER_SOLD_CODE                                                     as BROKER_DEALER_SOLD_CODE
  , FEE_AUTHORIZATION_CODE                                                      as FEE_AUTHORIZATION_CODE
  , MUTUAL_FUND_FEE_REBATE_CODE                                                 as MUTUAL_FUND_FEE_REBATE_CODE
  , SPECIAL_ACCOUNT_USAGE_CODE                                                  as SPECIAL_ACCOUNT_USAGE_CODE
  , TRADE_AWAY_ELIGIBLE_CODE                                                    as TRADE_AWAY_ELIGIBLE_CODE
  , COVERDELL_SPECIAL_NEEDS_INDICATOR                                           as COVERDELL_SPECIAL_NEEDS_INDICATOR
  , MULTIPLE_MARGIN_MODEL_CODE                                                  as MULTIPLE_MARGIN_MODEL_CODE
  , MUTUAL_FUND_INVESTMENT_IRA_INDICATOR                                        as MUTUAL_FUND_INVESTMENT_IRA_INDICATOR
  , MONEY_MARKET_ACCOUNT_DESIGNATION                                            as MONEY_MARKET_ACCOUNT_DESIGNATION
  , PRODUCT_CLASS                                                               as PRODUCT_CLASS
  , PLATFORM_SOURCE                                                             as PLATFORM_SOURCE
  , FIDUCIARY_APPROACH_CODE                                                     as FIDUCIARY_APPROACH_CODE
  , case
        when nvl(FIDUCIARY_APPROACH_LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FIDUCIARY_APPROACH_LAST_UPDATE_DATE, 'YYYYMMDD') end::date as FIDUCIARY_APPROACH_LAST_UPDATE_DATE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ ref('fidelity_' ~ src ~ '_history__vw_raw_nabase_101_account') }}
{%- endmacro -%}