select
    'salesforce'::text(200)                                            as system_name
  , 'corbenic'::text(200)                                              as system_instance
  , concat(system_name, '__', system_instance)::text(200)              as system_key
  , 'mwa'::text(200)                                                   as firm_source
  , a.json:ID:: varchar(18)                                            as id
  , a.json:OWNER_ID:: varchar(18)                                      as owner_id
  , a.json:IS_DELETED:: boolean                                        as is_deleted
  , a.json:NAME:: varchar(240)                                         as name
  , a.json:RECORD_TYPE_ID:: varchar(18)                                as record_type_id
  , a.json:CREATED_DATE:: timestamp_tz(9)                              as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                                 as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamp_tz(9)                        as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                           as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamp_tz(9)                           as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                                   as last_activity_date
  , a.json:LAST_VIEWED_DATE:: timestamp_tz(9)                          as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamp_tz(9)                      as last_referenced_date
  , a.json:PRACTIFI_ACCOUNT_NUMBER_C:: varchar(150)                    as practifi_account_number_c
  , a.json:PRACTIFI_AS_AT_C:: date                                     as practifi_as_at_c
  , a.json:PRACTIFI_ASSET_VALUE_C:: number                             as practifi_asset_value_c
  , a.json:PRACTIFI_BATCH_C:: varchar(18)                              as practifi_batch_c
  , a.json:PRACTIFI_CATEGORY_C:: varchar(765)                          as practifi_category_c
  , a.json:PRACTIFI_CLIENT_C:: varchar(18)                             as practifi_client_c
  , a.json:PRACTIFI_CURRENT_VALUE_C:: number                           as practifi_current_value_c
  , a.json:PRACTIFI_DESCRIPTION_C:: varchar(765)                       as practifi_description_c
  , a.json:PRACTIFI_EXTERNAL_ID_1_C:: varchar(765)                     as practifi_external_id_1_c
  , a.json:PRACTIFI_EXTERNAL_ID_2_C:: varchar(765)                     as practifi_external_id_2_c
  , a.json:PRACTIFI_EXTERNAL_ID_3_C:: varchar(765)                     as practifi_external_id_3_c
  , a.json:PRACTIFI_EXTERNAL_ID_4_C:: varchar(765)                     as practifi_external_id_4_c
  , a.json:PRACTIFI_EXTERNAL_ID_C:: varchar(765)                       as practifi_external_id_c
  , a.json:PRACTIFI_HAS_HOLDINGS_C:: boolean                           as practifi_has_holdings_c
  , a.json:PRACTIFI_INITIAL_VALUE_C:: number                           as practifi_initial_value_c
  , a.json:PRACTIFI_LIABILITY_VALUE_C:: number                         as practifi_liability_value_c
  , a.json:PRACTIFI_NOTES_C:: varchar(98304)                           as practifi_notes_c
  , a.json:PRACTIFI_RELATED_DIVISION_C:: varchar(18)                   as practifi_related_division_c
  , a.json:PRACTIFI_SERVICE_C:: varchar(18)                            as practifi_service_c
  , a.json:PRACTIFI_SHARING_SCOPE_C:: varchar(765)                     as practifi_sharing_scope_c
  , a.json:PRACTIFI_SOURCE_C:: varchar(765)                            as practifi_source_c
  , a.json:PRACTIFI_STAGE_C:: varchar(765)                             as practifi_stage_c
  , a.json:PRACTIFI_UNDER_ADVICE_C:: boolean                           as practifi_under_advice_c
  , a.json:PRACTIFI_VALUE_C:: number                                   as practifi_value_c
  , a.json:PRACTIFI_HOLDINGS_VALUE_C:: number                          as practifi_holdings_value_c
  , a.json:PRACTIFI_NUMBER_OF_HOLDINGS_C:: float                       as practifi_number_of_holdings_c
  , a.json:PRACTIFI_REVENUE_C:: number                                 as practifi_revenue_c
  , a.json:PRACTIFI_FINANCIAL_PRODUCT_C:: varchar(18)                  as practifi_financial_product_c
  , a.json:PRACTIFI_SUPPRESS_AUTOMATIC_ROLE_CREATION_C:: boolean       as practifi_suppress_automatic_role_creation_c
  , a.json:PRACTIFI_INTEREST_RATE_C:: float                            as practifi_interest_rate_c
  , a.json:PRACTIFI_RELATED_ENTITY_C:: varchar(18)                     as practifi_related_entity_c
  , a.json:PRACTIFI_LENDER_C:: varchar(18)                             as practifi_lender_c
  , a.json:PRACTIFI_SET_AS_CREATED_DATE_C:: timestamp_tz(9)            as practifi_set_as_created_date_c
  , a.json:PRACTIFI_EXTERNAL_ID_5_C:: varchar(765)                     as practifi_external_id_5_c
  , a.json:PRACTIFI_INTEREST_TYPE_C:: varchar(765)                     as practifi_interest_type_c
  , a.json:PRACTIFI_LOAN_PERIOD_MONTHS_C:: float                       as practifi_loan_period_months_c
  , a.json:PRACTIFI_REPAYMENT_TYPE_C:: varchar(765)                    as practifi_repayment_type_c
  , a.json:PRACTIFI_DEFER_AUTOMATION_C:: boolean                       as practifi_defer_automation_c
  , a.json:PRACTIFI_ACCOUNT_CLOSE_DATE_C:: date                        as practifi_account_close_date_c
  , a.json:PRACTIFI_ACCOUNT_OPEN_DATE_C:: date                         as practifi_account_open_date_c
  , a.json:PRACTIFI_ANNUAL_REVENUE_C:: number                          as practifi_annual_revenue_c
  , a.json:PRACTIFI_DATE_CLOSED_C:: date                               as practifi_date_closed_c
  , a.json:PRACTIFI_DATE_OPENED_C:: date                               as practifi_date_opened_c
  , a.json:PRACTIFI_EMPLOYMENT_START_DATE_C:: date                     as practifi_employment_start_date_c
  , a.json:PRACTIFI_LAST_ROLLOVER_AMOUNT_C:: number                    as practifi_last_rollover_amount_c
  , a.json:PRACTIFI_LAST_ROLLOVER_DATE_C:: date                        as practifi_last_rollover_date_c
  , a.json:PRACTIFI_NUMBER_OF_ROLLOVERS_C:: float                      as practifi_number_of_rollovers_c
  , a.json:PRACTIFI_PARENT_FINANCIAL_PRODUCT_C:: varchar(18)           as practifi_parent_financial_product_c
  , a.json:PRACTIFI_PLATFORM_PROVIDER_NAME_C:: varchar(765)            as practifi_platform_provider_name_c
  , a.json:PRACTIFI_PROVIDER_NAME_C:: varchar(765)                     as practifi_provider_name_c
  , a.json:PRACTIFI_SALARY_EFFECTIVE_DATE_C:: date                     as practifi_salary_effective_date_c
  , a.json:PRACTIFI_SALARY_C:: number                                  as practifi_salary_c
  , a.json:PRACTIFI_TOTAL_ROLLOVER_AMOUNT_C:: number                   as practifi_total_rollover_amount_c
  , a.json:PRACTIFI_AUM_VALUATION_METHOD_C:: varchar(765)              as practifi_aum_valuation_method_c
  , a.json:PRACTIFI_BILLING_FREQUENCY_C:: varchar(765)                 as practifi_billing_frequency_c
  , a.json:PRACTIFI_BILLING_START_DATE_C:: date                        as practifi_billing_start_date_c
  , a.json:PRACTIFI_CONTRIBUTIONS_LAST_YEAR_ROLLING_C:: number         as practifi_contributions_last_year_rolling_c
  , a.json:PRACTIFI_CUSTODIAN_NAME_C:: varchar(765)                    as practifi_custodian_name_c
  , a.json:PRACTIFI_ENABLED_INTEGRATIONS_C:: varchar(765)              as practifi_enabled_integrations_c
  , a.json:PRACTIFI_EXCLUDE_FROM_BILLING_C:: boolean                   as practifi_exclude_from_billing_c
  , a.json:PRACTIFI_FEE_SCHEDULE_DESCRIPTION_C:: varchar(765)          as practifi_fee_schedule_description_c
  , a.json:PRACTIFI_PERFORMANCE_LAST_12_MONTHS_C:: float               as practifi_performance_last_12_months_c
  , a.json:PRACTIFI_PERFORMANCE_LAST_36_MONTHS_C:: float               as practifi_performance_last_36_months_c
  , a.json:PRACTIFI_PERFORMANCE_MTD_C:: float                          as practifi_performance_mtd_c
  , a.json:PRACTIFI_PERFORMANCE_QTD_C:: float                          as practifi_performance_qtd_c
  , a.json:PRACTIFI_PERFORMANCE_YTD_C:: float                          as practifi_performance_ytd_c
  , a.json:PRACTIFI_RMD_ACTIVE_C:: boolean                             as practifi_rmd_active_c
  , a.json:PRACTIFI_RMD_COMPLETED_DATE_LAST_YEAR_C:: date              as practifi_rmd_completed_date_last_year_c
  , a.json:PRACTIFI_RMD_COMPLETED_DATE_C:: date                        as practifi_rmd_completed_date_c
  , a.json:PRACTIFI_RMD_REMAINING_LAST_YEAR_C:: number                 as practifi_rmd_remaining_last_year_c
  , a.json:PRACTIFI_RMD_REMAINING_C:: number                           as practifi_rmd_remaining_c
  , a.json:PRACTIFI_REALIZED_GAIN_LAST_YEAR_C:: number                 as practifi_realized_gain_last_year_c
  , a.json:PRACTIFI_REALIZED_GAIN_YTD_C:: number                       as practifi_realized_gain_ytd_c
  , a.json:PRACTIFI_REQUIRED_MINIMUM_DISTRIBUTION_LAST_YEAR_C:: number as practifi_required_minimum_distribution_last_year_c
  , a.json:PRACTIFI_REQUIRED_MINIMUM_DISTRIBUTION_C:: number           as practifi_required_minimum_distribution_c
  , a.json:PRACTIFI_REVENUE_LAST_YEAR_ROLLING_C:: number               as practifi_revenue_last_year_rolling_c
  , a.json:PRACTIFI_SHARING_SCOPE_2_C:: varchar(765)                   as practifi_sharing_scope_2_c
  , a.json:PRACTIFI_SHARING_SCOPE_3_C:: varchar(765)                   as practifi_sharing_scope_3_c
  , a.json:PRACTIFI_SHARING_SCOPE_4_C:: varchar(765)                   as practifi_sharing_scope_4_c
  , a.json:PRACTIFI_SHARING_SCOPE_5_C:: varchar(765)                   as practifi_sharing_scope_5_c
  , a.json:PRACTIFI_TOTAL_RETURN_LAST_12_MONTHS_C:: number             as practifi_total_return_last_12_months_c
  , a.json:PRACTIFI_TOTAL_RETURN_LAST_36_MONTHS_C:: number             as practifi_total_return_last_36_months_c
  , a.json:PRACTIFI_TOTAL_RETURN_MTD_C:: number                        as practifi_total_return_mtd_c
  , a.json:PRACTIFI_TOTAL_RETURN_QTD_C:: number                        as practifi_total_return_qtd_c
  , a.json:PRACTIFI_TOTAL_RETURN_YTD_C:: number                        as practifi_total_return_ytd_c
  , a.json:PRACTIFI_UNREALIZED_GAIN_C:: number                         as practifi_unrealized_gain_c
  , a.json:PRACTIFI_WITHDRAWALS_YTD_C:: number                         as practifi_withdrawals_ytd_c
  , a.json:PRACTIFI_BENEFICIARY_1_C:: varchar(18)                      as practifi_beneficiary_1_c
  , a.json:PRACTIFI_BENEFICIARY_2_C:: varchar(18)                      as practifi_beneficiary_2_c
  , a.json:PRACTIFI_BENEFICIARY_3_C:: varchar(18)                      as practifi_beneficiary_3_c
  , a.json:PRACTIFI_BENEFICIARY_4_C:: varchar(18)                      as practifi_beneficiary_4_c
  , a.json:PRACTIFI_BENEFICIARY_5_C:: varchar(18)                      as practifi_beneficiary_5_c
  , a.json:PRACTIFI_KEY_PROCESS_C:: varchar(18)                        as practifi_key_process_c
  , a.json:PRACTIFI_OWNER_1_C:: varchar(18)                            as practifi_owner_1_c
  , a.json:PRACTIFI_OWNER_2_C:: varchar(18)                            as practifi_owner_2_c
  , a.json:PRACTIFI_OWNER_3_C:: varchar(18)                            as practifi_owner_3_c
  , a.json:PRACTIFI_TRUSTED_CONTACT_1_C:: varchar(18)                  as practifi_trusted_contact_1_c
  , a.json:PRACTIFI_TRUSTED_CONTACT_2_C:: varchar(18)                  as practifi_trusted_contact_2_c
  , a.json:PRACTIFI_BENEFICIARY_PERCENTAGES_EQUAL_100_C:: boolean      as practifi_beneficiary_percentages_equal_100_c
  , a.json:PRACTIFI_OWNERSHIP_PERCENTAGES_EQUAL_100_C:: boolean        as practifi_ownership_percentages_equal_100_c
  , a.json:PRACTIFI_BANK_NAME_C:: varchar(765)                         as practifi_bank_name_c
  , a.json:PRACTIFI_FUNDING_METHOD_C:: varchar(4099)                   as practifi_funding_method_c
  , a.json:PRACTIFI_INVESTMENT_OBJECTIVE_C:: varchar(765)              as practifi_investment_objective_c
  , a.json:PRACTIFI_LIQUID_NET_WORTH_C:: number                        as practifi_liquid_net_worth_c
  , a.json:PRACTIFI_LIQUIDITY_NEEDS_C:: varchar(765)                   as practifi_liquidity_needs_c
  , a.json:PRACTIFI_NET_WORTH_C:: number                               as practifi_net_worth_c
  , a.json:PRACTIFI_PURPOSE_OF_ACCOUNT_C:: varchar(765)                as practifi_purpose_of_account_c
  , a.json:PRACTIFI_REGISTRATION_TYPE_C:: varchar(765)                 as practifi_registration_type_c
  , a.json:PRACTIFI_RISK_TOLERANCE_C:: varchar(765)                    as practifi_risk_tolerance_c
  , a.json:PRACTIFI_ROUTING_NUMBER_C:: float                           as practifi_routing_number_c
  , a.json:PRACTIFI_SOURCE_ASSET_C:: varchar(18)                       as practifi_source_asset_c
  , a.json:PRACTIFI_SOURCE_OF_FUNDS_C:: varchar(4099)                  as practifi_source_of_funds_c
  , a.json:PRACTIFI_TIME_HORIZON_C:: varchar(765)                      as practifi_time_horizon_c
  , a.json:PRACTIFI_TRANSFER_AMOUNT_C:: number                         as practifi_transfer_amount_c
  , a.json:PRACTIFI_OBJECTIVE_VALUES_C:: boolean                       as practifi_objective_values_c
  , a.json:_FIVETRAN_DELETED:: boolean                                 as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED:: timestamp_tz(9)                          as _fivetran_synced

  , a.effective_at::timestamp                                          as effective_at
  , a._created_at::timestamp                                           as _created_at
  , {{ col_is_head(reference=source('salesforce_corbenic', 'practifi_asset_liability_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                               as is_latest
from {{ source('salesforce_corbenic', 'practifi_asset_liability_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_corbenic', 'practifi_asset_liability_c') }}
    group by 1, 2
)                                                                      b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at