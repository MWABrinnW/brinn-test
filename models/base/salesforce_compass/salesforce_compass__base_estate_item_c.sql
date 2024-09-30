select
    'salesforce'::text(200)                                   as system_name
  , 'compass'::text(200)                                      as system_instance
  , concat(system_name, '__', system_instance)::text(200)     as system_key
  , 'mwa'::text(200)                                          as firm_source
  , a.json:ID:: varchar(18)                                   as id
  , a.json:OWNER_ID:: varchar(18)                             as owner_id
  , a.json:IS_DELETED:: boolean                               as is_deleted
  , a.json:NAME:: varchar(240)                                as name
  , a.json:RECORD_TYPE_ID:: varchar(18)                       as record_type_id
  , a.json:CREATED_DATE:: timestamptz                         as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                        as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamptz                   as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                  as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamptz                      as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                          as last_activity_date
  , a.json:LAST_VIEWED_DATE:: timestamptz                     as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamptz                 as last_referenced_date
  , a.json:AUM_CLASSIFICATION_CONFIRMED_BY_C:: varchar(765)   as aum_classification_confirmed_by_c
  , a.json:AUM_CLASSIFICATION_NOTES_C:: varchar(765)          as aum_classification_notes_c
  , a.json:AUM_CLASSIFICATION_C:: varchar(765)                as aum_classification_c
  , a.json:ACCOUNT_DESCRIPTION_C:: varchar(765)               as account_description_c
  , a.json:ACCOUNT_IDORION_C:: varchar(24)                    as account_idorion_c
  , a.json:ACCOUNT_OPERATIONAL_TAGS_C:: varchar(4099)         as account_operational_tags_c
  , a.json:ACCOUNT_TYPE_C:: varchar(765)                      as account_type_c
  , a.json:BAA_TYPE_C:: varchar(765)                          as baa_type_c
  , a.json:CASH_BALANCE_C:: number(18, 2)                     as cash_balance_c
  , a.json:COMMENTS_C:: varchar(98304)                        as comments_c
  , a.json:COMMITTED_AMOUNT_C:: number(18, 2)                 as committed_amount_c
  , a.json:CURRENT_VALUE_C:: number(18, 2)                    as current_value_c
  , a.json:IDENTIFIER_C:: varchar(240)                        as identifier_c
  , a.json:INS_ADDITIONAL_COVERAGE_C:: number(18)             as ins_additional_coverage_c
  , a.json:INS_ANNUAL_PREMIUM_C:: number(18, 2)               as ins_annual_premium_c
  , a.json:INS_COVERAGE_AMOUNT_C:: number(18)                 as ins_coverage_amount_c
  , a.json:MARINER_ID_C:: varchar(90)                         as mariner_id_c
  , a.json:VARIOUS_TAGS_C:: varchar(4099)                     as various_tags_c
  , a.json:SUBADVISOR_DATE_OPENED_C:: date                    as subadvisor_date_opened_c
  , a.json:MODEL_ON_ACCOUNT_C:: varchar(18)                   as model_on_account_c
  , a.json:DATE_REVIEWED_C:: date                             as date_reviewed_c
  , a.json:DATE_REVISED_C:: date                              as date_revised_c
  , a.json:INS_EXPIRATION_DATE_C:: date                       as ins_expiration_date_c
  , a.json:INVESTMENT_FEE_PERCENT_C:: double                  as investment_fee_percent_c
  , a.json:LIABILITY_INTEREST_RATE_C:: double                 as liability_interest_rate_c
  , a.json:QUICK_COMMENT_C:: varchar(765)                     as quick_comment_c
  , a.json:SUBADVISOR_DATE_CLOSED_C:: date                    as subadvisor_date_closed_c
  , a.json:REGISTRATION_TYPE_C:: varchar(18)                  as registration_type_c
  , a.json:STATUS_C:: varchar(765)                            as status_c
  , a.json:TRADE_RESTRICTION_C:: varchar(1500)                as trade_restriction_c
  , a.json:CLOSING_DATE_C:: date                              as closing_date_c
  , a.json:OPENING_DATE_C:: date                              as opening_date_c
  , a.json:PAYMENT_MODE_C:: varchar(765)                      as payment_mode_c
  , a.json:PERF_10_YR_C:: double                              as perf_10_yr_c
  , a.json:PERF_1_D_C:: double                                as perf_1_d_c
  , a.json:PERF_1_YR_C:: double                               as perf_1_yr_c
  , a.json:PERF_3_YR_C:: double                               as perf_3_yr_c
  , a.json:PERF_5_YR_C:: double                               as perf_5_yr_c
  , a.json:PERF_AS_OF_DATE_C:: date                           as perf_as_of_date_c
  , a.json:PERF_INCEPTION_C:: double                          as perf_inception_c
  , a.json:PERF_MTD_C:: double                                as perf_mtd_c
  , a.json:PERF_QTD_C:: double                                as perf_qtd_c
  , a.json:PERF_YTD_C:: double                                as perf_ytd_c
  , a.json:POLICY_TYPE_C:: varchar(765)                       as policy_type_c
  , a.json:ESTATE_ITEM_TYPE_C:: varchar(765)                  as estate_item_type_c
  , a.json:NET_CASH_VALUE_C:: number(18, 2)                   as net_cash_value_c
  , a.json:NET_CASH_VALUE_DATE_C:: date                       as net_cash_value_date_c
  , a.json:DATA_SOURCE_OVERRIDE_C:: varchar(150)              as data_source_override_c
  , a.json:CURRENT_HISTORICAL_RECORD_C:: varchar(18)          as current_historical_record_c
  , a.json:CUSTODIAN_C:: varchar(18)                          as custodian_c
  , a.json:DEBT_BALANCE_C:: number(18)                        as debt_balance_c
  , a.json:OPPORTUNITY_C:: varchar(18)                        as opportunity_c
  , a.json:ONLY_IN_SALESFORCE_C:: boolean                     as only_in_salesforce_c
  , a.json:BOOPERATIONAL_TAGS_C:: varchar(4099)               as booperational_tags_c
  , a.json:BOSTALE_DATE_C:: date                              as bostale_date_c
  , a.json:CUSTODIAN_AS_OF_DATE_C:: date                      as custodian_as_of_date_c
  , a.json:AS_OF_DATE_C:: date                                as as_of_date_c
  , a.json:CUSTODIAN_RESTRICTION_NOTES_C:: varchar(225)       as custodian_restriction_notes_c
  , a.json:CLOSING_CHECK_YTDNET_C_W_C:: number(18, 2)         as closing_check_ytdnet_c_w_c
  , a.json:SUBADVISOR_ID_C:: varchar(240)                     as subadvisor_id_c
  , a.json:PAPERWORK_TYPE_ON_FILE_C:: varchar(765)            as paperwork_type_on_file_c
  , a.json:STALE_DATE_CLIENT_C:: date                         as stale_date_client_c
  , a.json:STALE_ACCOUNT_NOTES_C:: varchar(765)               as stale_account_notes_c
  , a.json:STALE_DATA_TYPE_C:: varchar(765)                   as stale_data_type_c
  , a.json:ADMIN_FEE_C:: number(10)                           as admin_fee_c
  , a.json:BILL_CALCULATED_IN_SALESFORCE_C:: boolean          as bill_calculated_in_salesforce_c
  , a.json:BILLABLE_MARKET_VALUE_C:: number(18, 2)            as billable_market_value_c
  , a.json:BILLING_ACCOUNT_NUMBER_C:: varchar(300)            as billing_account_number_c
  , a.json:FIDELITY_PURGE_ACCOUNT_C:: boolean                 as fidelity_purge_account_c
  , a.json:BILLING_EXCEPTION_CATEGORY_C:: varchar(765)        as billing_exception_category_c
  , a.json:BILLING_EXCEPTION_DETAILS_C:: varchar(765)         as billing_exception_details_c
  , a.json:BILLING_METHOD_C:: varchar(765)                    as billing_method_c
  , a.json:BILLING_STYLE_C:: varchar(765)                     as billing_style_c
  , a.json:DISCOUNT_RATE_C:: double                           as discount_rate_c
  , a.json:AGGREGATED_IN_TIER_C:: boolean                     as aggregated_in_tier_c
  , a.json:MH_BILLING_CALCULATION_C:: varchar(18)             as mh_billing_calculation_c
  , a.json:BILLING_ACCOUNT_OUTSTANDING_FEES_C:: number(18, 2) as billing_account_outstanding_fees_c
  , a.json:BLOCK_ON_ACCOUNT_C:: boolean                       as block_on_account_c
  , a.json:CAPITAL_GAINS_REINVESTED_C:: boolean               as capital_gains_reinvested_c
  , a.json:COMPENSATION_ACCOUNT_C:: boolean                   as compensation_account_c
  , a.json:DELINK_FROM_CUSTODIAN_C:: boolean                  as delink_from_custodian_c
  , a.json:FIXED_INCOME_HOLDINGS_C:: boolean                  as fixed_income_holdings_c
  , a.json:MARGIN_C:: boolean                                 as margin_c
  , a.json:NON_DISCRETIONARY_ACCOUNT_C:: boolean              as non_discretionary_account_c
  , a.json:ORION_RESTRICTION_CHECK_C:: boolean                as orion_restriction_check_c
  , a.json:PRIME_BROKER_ENABLED_C:: boolean                   as prime_broker_enabled_c
  , a.json:SMA_C:: boolean                                    as sma_c
  , a.json:SMA_ASSET_NAME_C:: varchar(300)                    as sma_asset_name_c
  , a.json:TAMARAC_REBAL_ACCOUNT_C:: boolean                  as tamarac_rebal_account_c
  , a.json:RECON_NOTES_C:: varchar(765)                       as recon_notes_c
  , a.json:OPERATIONS_NOTES_C:: varchar(765)                  as operations_notes_c
  , a.json:RESTRICTION_NOTES_C:: varchar(765)                 as restriction_notes_c
  , a.json:RESTRICTION_NOTES_2_C:: varchar(765)               as restriction_notes_2_c
  , a.json:COMPLIANCE_REVIEW_NOTES_C:: varchar(765)           as compliance_review_notes_c
  , a.json:I_REBAL_HOUSEHOLD_C:: boolean                      as i_rebal_household_c
  , a.json:IS_MANAGED_C:: boolean                             as is_managed_c
  , a.json:FINANCING_COMPANY_C:: varchar(18)                  as financing_company_c
  , a.json:LINKED_INDIVIDUAL_FIXED_INCOME_C:: boolean         as linked_individual_fixed_income_c
  , a.json:RECON_DATE_C:: date                                as recon_date_c
  , a.json:MATURITY_RESTRICTION_C:: varchar(765)              as maturity_restriction_c
  , a.json:INVESTMENT_STATUS_NOTES_C:: varchar(765)           as investment_status_notes_c
  , a.json:RATING_RESTRICTION_C:: varchar(765)                as rating_restriction_c
  , a.json:OTHER_RESTRICTION_C:: varchar(765)                 as other_restriction_c
  , a.json:DISTRIBUTION_TYPE_C:: varchar(765)                 as distribution_type_c
  , a.json:DISTRIBUTION_AMOUNT_C:: number(18)                 as distribution_amount_c
  , a.json:DISTRIBUTION_FREQUENCY_C:: varchar(60)             as distribution_frequency_c
  , a.json:DURATION_C:: double                                as duration_c
  , a.json:SWAP_C:: boolean                                   as swap_c
  , a.json:SWAP_CUSIPS_C:: varchar(300)                       as swap_cusips_c
  , a.json:SWAP_NOTES_C:: varchar(765)                        as swap_notes_c
  , a.json:POSITION_SIZE_C:: varchar(300)                     as position_size_c
  , a.json:REPLENISH_MINIMUM_CASH_C:: boolean                 as replenish_minimum_cash_c
  , a.json:TAX_STATUS_C:: varchar(765)                        as tax_status_c
  , a.json:MINIMUM_CASH_C:: varchar(54)                       as minimum_cash_c
  , a.json:BILLING_EXCEPTION_C:: boolean                      as billing_exception_c
  , a.json:STATE_1_C:: varchar(765)                           as state_1_c
  , a.json:STATE_2_C:: varchar(765)                           as state_2_c
  , a.json:AM_RESTRICTIONS_C:: varchar(4099)                  as am_restrictions_c
  , a.json:SUBADVISOR_C:: varchar(18)                         as subadvisor_c
  , a.json:FUND_FAMILY_C:: varchar(765)                       as fund_family_c
  , a.json:DATA_SOURCE_C:: varchar(765)                       as data_source_c
  , a.json:RECONCILIATION_FREQUENCY_C:: varchar(765)          as reconciliation_frequency_c
  , a.json:RECON_ASSIGNMENT_C:: varchar(18)                   as recon_assignment_c
  , a.json:ERISA_C:: varchar(765)                             as erisa_c
  , a.json:ERISA_CONFIRMATION_C:: varchar(750)                as erisa_confirmation_c
  , a.json:ERISA_AFFILIATED_INVESTMENTS_C:: varchar(765)      as erisa_affiliated_investments_c
  , a.json:YEAR_TO_DATE_CONTRIBUTIONS_C:: number(18, 2)       as year_to_date_contributions_c
  , a.json:YEAR_TO_DATE_DISTRIBUTIONS_C:: number(18, 2)       as year_to_date_distributions_c
  , a.json:QTD_NET_CONTRIBUTIONS_BILLABLE_C:: number(18, 2)   as qtd_net_contributions_billable_c
  , a.json:SUBADVISOR_RATE_OVERRIDE_C:: double                as subadvisor_rate_override_c
  , a.json:EMAIL_TO_C:: varchar(765)                          as email_to_c
  , a.json:ADVISOR_APPROVED_STATUS_C:: double                 as advisor_approved_status_c
  , a.json:BILLING_ACCOUNT_C:: varchar(18)                    as billing_account_c
  , a.json:HOUSEHOLD_C:: varchar(18)                          as household_c
  , a.json:FEE_SCHEDULE_C:: varchar(18)                       as fee_schedule_c
  , a.json:ECLIPSE_ENABLED_C:: boolean                        as eclipse_enabled_c
  , a.json:ACKNOWLEDGMENT_LETTER_ON_FILE_C:: boolean          as acknowledgment_letter_on_file_c
  , a.json:DOWNLOAD_SOURCE_C:: varchar(765)                   as download_source_c
  , a.json:ACCOUNT_IDMSEC_C:: varchar(24)                     as account_idmsec_c
  , a.json:MSEC_COMMISSIONS_LIFE_TO_DATE_C:: number(18, 2)    as msec_commissions_life_to_date_c
  , a.json:INORGANIC_FUNDS_C:: boolean                        as inorganic_funds_c
  , a.json:INORGANIC_REVENUE_CUR_QTR_C:: number(18, 2)        as inorganic_revenue_cur_qtr_c
  , a.json:INORGANIC_REVENUE_PREV_QTR_C:: number(18, 2)       as inorganic_revenue_prev_qtr_c
  , a.json:INORGANIC_VALUE_C:: number(18, 2)                  as inorganic_value_c
  , a.json:OPTION_MULTI_MARGIN_C:: boolean                    as option_multi_margin_c
  , a.json:OPTIONS_INVESTMENT_GUIDELINES_C:: varchar(4099)    as options_investment_guidelines_c
  , a.json:OPTIONS_LEVEL_C:: varchar(765)                     as options_level_c
  , a.json:OPTIONS_RIDER_C:: varchar(765)                     as options_rider_c
  , a.json:CALCULATION_SYSTEM_C:: varchar(765)                as calculation_system_c
  , a.json:SHARE_WITH_C:: varchar(765)                        as share_with_c
  , a.json:FIXED_INCOME_CASH_AVAILABLE_C:: double             as fixed_income_cash_available_c
  , a.json:SYS_MIGRATION_SOURCE_C:: varchar(4099)             as sys_migration_source_c
  , a.json:SYS_MIGRATION_ID_C:: varchar(765)                  as sys_migration_id_c
  , a.json:EQUITY_C:: double                                  as equity_c
  , a.json:EQUITY_GOAL_C:: varchar(765)                       as equity_goal_c
  , a.json:FIXED_INCOME_C:: double                            as fixed_income_c
  , a.json:YTD_REALIZED_GAIN_LOSS_C:: number(18, 2)           as ytd_realized_gain_loss_c
  , a.json:TRADING_ID_C:: varchar(192)                        as trading_id_c
  , a.json:FIXED_ALTS_C:: double                              as fixed_alts_c
  , a.json:PREF_C:: double                                    as pref_c
  , a.json:LARGE_CAP_C:: double                               as large_cap_c
  , a.json:SMID_C:: double                                    as smid_c
  , a.json:INTL_EQUITY_C:: double                             as intl_equity_c
  , a.json:MLP_REITS_C:: double                               as mlp_reits_c
  , a.json:FIRM_TRADING_C:: boolean                           as firm_trading_c
  , a.json:OTHER_C:: double                                   as other_c
  , a.json:TRADING_SYSTEM_C:: varchar(765)                    as trading_system_c
  , a.json:BROKER_DEALER_ACCOUNT_C:: boolean                  as broker_dealer_account_c
  , a.json:ELIMINATION_PERIOD_C:: double                      as elimination_period_c
  , a.json:MONTHLY_MAXIMUM_C:: number(18, 2)                  as monthly_maximum_c
  , a.json:_FIVETRAN_SYNCED:: timestamptz                     as _fivetran_synced
  , a.json:MOXY_INTRA_DAY_IMPORT_C:: boolean                  as moxy_intra_day_import_c
  , a.json:BILLING_CALCULATION_SYSTEM_C:: varchar(765)        as billing_calculation_system_c
  , a.json:STALE_DATE_AGING_C:: double                        as stale_date_aging_c
  , a.json:RECON_DATE_CALC_C:: date                           as recon_date_calc_c
  , a.json:PARTNER_FIRM_C:: varchar(3900)                     as partner_firm_c
  , a.json:YEAR_TO_DATE_NET_CONTRIBUTIONS_C:: number(18, 2)   as year_to_date_net_contributions_c
  , a.json:CURRENT_CASH_PCT_C:: double                        as current_cash_pct_c
  , a.json:RECONCILIATION_COUNT_C:: double                    as reconciliation_count_c
  , a.json:NON_DISC_MIX_C:: varchar(3900)                     as non_disc_mix_c
  , a.json:INCLUDED_FOR_AFIS_C:: boolean                      as included_for_afis_c
  , a.json:CURRENT_COMMITED_VALUE_C:: number(18, 2)           as current_commited_value_c
  , a.json:ESTATE_ITEM_ID_18_C:: varchar(3900)                as estate_item_id_18_c
  , a.json:RECONCILIATION_VALUATION_DATE_ROLLUP_C:: date      as reconciliation_valuation_date_rollup_c
  , a.json:RECONCILIATION_DATE_ROLLUP_C:: date                as reconciliation_date_rollup_c
  , a.json:CURRENT_HISTORICAL_STATUS_C:: varchar(3900)        as current_historical_status_c
  , a.json:B_D_MIX_C:: varchar(3900)                          as b_d_mix_c
  , a.json:SYS_IS_MSECACCOUNT_C:: boolean                     as sys_is_msecaccount_c
  , a.json:VALID_PAPERWORK_C:: boolean                        as valid_paperwork_c
  , a.json:CASH_PERCENT_C:: double                            as cash_percent_c
  , a.json:CURRENT_HISTORICAL_VALUATION_DATE_C:: date         as current_historical_valuation_date_c
  , a.json:STALE_DATE_CLIENT_AGING_C:: double                 as stale_date_client_aging_c
  , a.json:LOCATION_C:: varchar(3900)                         as location_c
  , a.json:MSECOPT_IN_C:: boolean                             as msecopt_in_c
  , a.json:ESTATE_ITEM_NAME_DATA_TABLE_EDIT_C:: varchar(240)  as estate_item_name_data_table_edit_c
  , a.json:NEW_UPDATE_C:: boolean                             as new_update_c
  , a.json:NEW_UPDATE_FORMULA_C:: boolean                     as new_update_formula_c
  , a.json:ROLLOVER_EFFECTIVE_DATE_C:: date                   as rollover_effective_date_c
  , a.json:ROLLOVER_PAPERWORK_C:: varchar(18)                 as rollover_paperwork_c
  , a.json:ROLLOVER_INVOLVEMENT_C:: varchar(765)              as rollover_involvement_c
  , a.json:ROLLOVER_TYPE_C:: varchar(4099)                    as rollover_type_c
  , a.json:ROLLOVER_C:: boolean                               as rollover_c
  , a.json:ANNUITY_MATURITY_DATE_C:: date                     as annuity_maturity_date_c
  , a.json:TAX_PAYMENT_AUTHORIZATION_FORM_C:: boolean         as tax_payment_authorization_form_c
  , a.json:TDA_LEGACY_ACCOUNT_C::varchar(200)                 as tda_legacy_account_c
  , a.json:TDA_LEGACY_ACCOUNT_NUMBER_C::varchar(200)          as tda_legacy_account_number_c
  , a.json:_FIVETRAN_DELETED:: boolean                        as _fivetran_deleted

  , a.effective_at::timestamp                                 as effective_at
  , a._created_at::timestamp                                  as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'estate_item_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                      as is_latest
from {{ source('salesforce_compass', 'estate_item_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'estate_item_c') }}
    group by 1, 2
)                                                        b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
