{%- macro fidelity_secmast_20(src) -%}
select
    RECORD_TYPE                                                           as RECORD_TYPE
  , RECORD_NUMBER                                                         as RECORD_NUMBER
  , SECURITY_TYPE                                                         as SECURITY_TYPE
  , DAILY_ACCRUAL_INDICATOR                                               as DAILY_ACCRUAL_INDICATOR
  , EXCHANGE_IN_INDICATOR                                                 as EXCHANGE_IN_INDICATOR
  , EXCHANGE_OUT_INDICATOR                                                as EXCHANGE_OUT_INDICATOR
  , OPEN_FOR_ADDITIONAL_PURCHASES                                         as OPEN_FOR_ADDITIONAL_PURCHASES
  , OPEN_FOR_NEW_PURCHASES                                                as OPEN_FOR_NEW_PURCHASES
  , QUALIFIED_INVESTMENT_ADVISOR_NAV_ELIGIBLE_INDICATOR                   as QUALIFIED_INVESTMENT_ADVISOR_NAV_ELIGIBLE_INDICATOR
  , case
        when nvl(NTF_END_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NTF_END_DATE, 'YYYYMMDD') end::date                  as NTF_END_DATE
  , case
        when nvl(NTF_START_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(NTF_START_DATE, 'YYYYMMDD') end::date                as NTF_START_DATE
  , "12B_1_ELIGIBLE_INDICATOR"                                            as "12B_1_ELIGIBLE_INDICATOR"
  , case
        when nvl(MAXIMUM_DEALER_CONCESSION, '') = '' then null::number(18, 5)
        else MAXIMUM_DEALER_CONCESSION::int * .00001 end::number(18, 5)   as MAXIMUM_DEALER_CONCESSION
  , REDEMPTION_FEE_DAYS                                                   as REDEMPTION_FEE_DAYS
  , case
        when nvl(REDEMPTION_FEE_EFFECTIVE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(REDEMPTION_FEE_EFFECTIVE_DATE, 'YYYYMMDD') end::date as REDEMPTION_FEE_EFFECTIVE_DATE
  , case
        when nvl(REDEMPTION_FEE_PERCENT, '') = '' then null::number(18, 2)
        else REDEMPTION_FEE_PERCENT::int * .01 end::number(18, 2)         as REDEMPTION_FEE_PERCENT
  , LAST_BUY_TIME                                                         as LAST_BUY_TIME
  , LAST_EXCHANGE_TIME                                                    as LAST_EXCHANGE_TIME
  , LAST_SELL_TIME                                                        as LAST_SELL_TIME
  , SETTLEMENT_DAYS                                                       as SETTLEMENT_DAYS
  , TOA_ELIGIBLE_INDICATOR                                                as TOA_ELIGIBLE_INDICATOR
  , case
        when nvl(LOAD_PERCENTAGE, '') = '' then null::number(18, 2)
        else LOAD_PERCENTAGE::int * .01 end::number(18, 2)                as LOAD_PERCENTAGE
  , BSPS_CTN_FMR_FUNDS                                                    as BSPS_CTN_FMR_FUNDS
  , BSPS_CTN_FPCMS_IA_FOF                                                 as BSPS_CTN_FPCMS_IA_FOF
  , BSPS_CTN_SAI_PAS                                                      as BSPS_CTN_SAI_PAS
  , BSPS_CTN_SAI_CGF_FUNDS                                                as BSPS_CTN_SAI_CGF_FUNDS
  , BSPS_FFOS_FAMILY_OFFICE                                               as BSPS_FFOS_FAMILY_OFFICE
  , BSPS_IWS_BANK_EB_CUSTODY                                              as BSPS_IWS_BANK_EB_CUSTODY
  , BSPS_IWS_BANK_TR_CUSTODY                                              as BSPS_IWS_BANK_TR_CUSTODY
  , BSPS_IWS_BROKERAGEFLEX                                                as BSPS_IWS_BROKERAGEFLEX
  , BSPS_IWS_BROKERAGELINK                                                as BSPS_IWS_BROKERAGELINK
  , BSPS_IWS_PERSONAL_TRUST                                               as BSPS_IWS_PERSONAL_TRUST
  , BSPS_IWS_RIA                                                          as BSPS_IWS_RIA
  , BSPS_IWS_TPA                                                          as BSPS_IWS_TPA
  , BSPS_NF_COMMISSION_BASED                                              as BSPS_NF_COMMISSION_BASED
  , BSPS_NF_F2J_CLEARING                                                  as BSPS_NF_F2J_CLEARING
  , BSPS_NF_FEE_BASED                                                     as BSPS_NF_FEE_BASED
  , BSPS_PI_RETAIL                                                        as BSPS_PI_RETAIL
  , BSPS_PI_SAI                                                           as BSPS_PI_SAI
  , BSPS_PI_SDB                                                           as BSPS_PI_SDB
  , NON_PAYING_FUND_EXCLUSION_INDICATOR                                   as NON_PAYING_FUND_EXCLUSION_INDICATOR
  , NO_TRANSACTION_FEE_NTF_PRODUCT_CODE                                   as NO_TRANSACTION_FEE_NTF_PRODUCT_CODE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}