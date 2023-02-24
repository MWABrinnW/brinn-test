{%- macro fidelity_raw_secmast_2f(src) -%}
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as DAILY_ACCRUAL_INDICATOR
  , nullif(trim(substring(content, 5, 1)), '')                                             as EXCHANGE_IN_INDICATOR
  , nullif(trim(substring(content, 6, 1)), '')                                             as EXCHANGE_OUT_INDICATOR
  , nullif(trim(substring(content, 7, 1)), '')                                             as OPEN_FOR_ADDITIONAL_PURCHASES
  , nullif(trim(substring(content, 8, 1)), '')                                             as OPEN_FOR_NEW_PURCHASES
  , nullif(trim(substring(content, 9, 1)), '')                                             as QUALIFIED_INVESTMENT_ADVISOR_NAV_ELIGIBLE_INDICATOR
  , nullif(trim(substring(content, 10, 8)), '')                                            as NTF_END_DATE
  , nullif(trim(substring(content, 18, 8)), '')                                            as NTF_START_DATE
  , nullif(trim(substring(content, 26, 1)), '')                                            as "12B_1_ELIGIBLE_INDICATOR"
  , nullif(trim(substring(content, 27, 8)), '')                                            as MAXIMUM_DEALER_CONCESSION
  , nullif(trim(substring(content, 35, 5)), '')                                            as REDEMPTION_FEE_DAYS
  , nullif(trim(substring(content, 40, 8)), '')                                            as REDEMPTION_FEE_EFFECTIVE_DATE
  , nullif(trim(substring(content, 48, 5)), '')                                            as REDEMPTION_FEE_PERCENT
  , nullif(trim(substring(content, 53, 8)), '')                                            as LAST_BUY_TIME
  , nullif(trim(substring(content, 61, 8)), '')                                            as LAST_EXCHANGE_TIME
  , nullif(trim(substring(content, 69, 8)), '')                                            as LAST_SELL_TIME
  , nullif(trim(substring(content, 77, 2)), '')                                            as SETTLEMENT_DAYS
  , nullif(trim(substring(content, 79, 1)), '')                                            as TOA_ELIGIBLE_INDICATOR
  , nullif(trim(substring(content, 80, 4)), '')                                            as LOAD_PERCENTAGE
  , nullif(trim(substring(content, 84, 1)), '')                                            as BSPS_CTN_FMR_FUNDS
  , nullif(trim(substring(content, 85, 1)), '')                                            as BSPS_CTN_FPCMS_IA_FOF
  , nullif(trim(substring(content, 86, 1)), '')                                            as BSPS_CTN_SAI_PAS
  , nullif(trim(substring(content, 87, 1)), '')                                            as BSPS_CTN_SAI_CGF_FUNDS
  , nullif(trim(substring(content, 88, 1)), '')                                            as BSPS_FFOS_FAMILY_OFFICE
  , nullif(trim(substring(content, 89, 1)), '')                                            as BSPS_IWS_BANK_EB_CUSTODY
  , nullif(trim(substring(content, 90, 1)), '')                                            as BSPS_IWS_BANK_TR_CUSTODY
  , nullif(trim(substring(content, 91, 1)), '')                                            as BSPS_IWS_BROKERAGEFLEX
  , nullif(trim(substring(content, 92, 1)), '')                                            as BSPS_IWS_BROKERAGELINK
  , nullif(trim(substring(content, 93, 1)), '')                                            as BSPS_IWS_PERSONAL_TRUST
  , nullif(trim(substring(content, 94, 1)), '')                                            as BSPS_IWS_RIA
  , nullif(trim(substring(content, 95, 1)), '')                                            as BSPS_IWS_TPA
  , nullif(trim(substring(content, 96, 1)), '')                                            as BSPS_NF_COMMISSION_BASED
  , nullif(trim(substring(content, 97, 1)), '')                                            as BSPS_NF_F2J_CLEARING
  , nullif(trim(substring(content, 98, 1)), '')                                            as BSPS_NF_FEE_BASED
  , nullif(trim(substring(content, 99, 1)), '')                                            as BSPS_PI_RETAIL
  , nullif(trim(substring(content, 100, 1)), '')                                           as BSPS_PI_SAI
  , nullif(trim(substring(content, 101, 1)), '')                                           as BSPS_PI_SDB
  , nullif(trim(substring(content, 103, 1)), '')                                           as NO_TRANSACTION_FEE_NTF_PRODUCT_CODE
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date, record_datetime::date as record_date, record_datetime::timestamp as record_datetime, source_file as source_file
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 3) = 'D2F'
{%- endmacro -%}