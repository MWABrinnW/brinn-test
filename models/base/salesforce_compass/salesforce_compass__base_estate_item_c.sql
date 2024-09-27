select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:RECORD_TYPE_ID::varchar(18)                        as record_type_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                           as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:AUM_CLASSIFICATION_CONFIRMED_BY_C::varchar(765)    as aum_classification_confirmed_by_c
    , json:AUM_CLASSIFICATION_NOTES_C::varchar(765)           as aum_classification_notes_c
    , json:AUM_CLASSIFICATION_C::varchar(765)                 as aum_classification_c
    , json:ACCOUNT_DESCRIPTION_C::varchar(765)                as account_description_c
    , json:ACCOUNT_IDORION_C::varchar(24)                     as account_idorion_c
    , json:ACCOUNT_OPERATIONAL_TAGS_C::varchar(4099)          as account_operational_tags_c
    , json:ACCOUNT_TYPE_C::varchar(765)                       as account_type_c
    , json:BAA_TYPE_C::varchar(765)                           as baa_type_c
    , json:CASH_BALANCE_C::number(18 , 2)                     as cash_balance_c
    , json:COMMENTS_C::varchar(98304)                         as comments_c
    , json:COMMITTED_AMOUNT_C::number(18 , 2)                 as committed_amount_c
    , json:CURRENT_VALUE_C::number(18 , 2)                    as current_value_c
    , json:IDENTIFIER_C::varchar(240)                         as identifier_c
    , json:INS_ADDITIONAL_COVERAGE_C::number(18)              as ins_additional_coverage_c
    , json:INS_ANNUAL_PREMIUM_C::number(18 , 2)               as ins_annual_premium_c
    , json:INS_COVERAGE_AMOUNT_C::number(18)                  as ins_coverage_amount_c
    , json:MARINER_ID_C::varchar(90)                          as mariner_id_c
    , json:VARIOUS_TAGS_C::varchar(4099)                      as various_tags_c
    , json:SUBADVISOR_DATE_OPENED_C::date                     as subadvisor_date_opened_c
    , json:MODEL_ON_ACCOUNT_C::varchar(18)                    as model_on_account_c
    , json:DATE_REVIEWED_C::date                              as date_reviewed_c
    , json:DATE_REVISED_C::date                               as date_revised_c
    , json:INS_EXPIRATION_DATE_C::date                        as ins_expiration_date_c
    , json:INVESTMENT_FEE_PERCENT_C::double                   as investment_fee_percent_c
    , json:LIABILITY_INTEREST_RATE_C::double                  as liability_interest_rate_c
    , json:QUICK_COMMENT_C::varchar(765)                      as quick_comment_c
    , json:SUBADVISOR_DATE_CLOSED_C::date                     as subadvisor_date_closed_c
    , json:REGISTRATION_TYPE_C::varchar(18)                   as registration_type_c
    , json:STATUS_C::varchar(765)                             as status_c
    , json:TRADE_RESTRICTION_C::varchar(1500)                 as trade_restriction_c
    , json:CLOSING_DATE_C::date                               as closing_date_c
    , json:OPENING_DATE_C::date                               as opening_date_c
    , json:PAYMENT_MODE_C::varchar(765)                       as payment_mode_c
    , json:PERF_10_YR_C::double                               as perf_10_yr_c
    , json:PERF_1_D_C::double                                 as perf_1_d_c
    , json:PERF_1_YR_C::double                                as perf_1_yr_c
    , json:PERF_3_YR_C::double                                as perf_3_yr_c
    , json:PERF_5_YR_C::double                                as perf_5_yr_c
    , json:PERF_AS_OF_DATE_C::date                            as perf_as_of_date_c
    , json:PERF_INCEPTION_C::double                           as perf_inception_c
    , json:PERF_MTD_C::double                                 as perf_mtd_c
    , json:PERF_QTD_C::double                                 as perf_qtd_c
    , json:PERF_YTD_C::double                                 as perf_ytd_c
    , json:POLICY_TYPE_C::varchar(765)                        as policy_type_c
    , json:ESTATE_ITEM_TYPE_C::varchar(765)                   as estate_item_type_c
    , json:NET_CASH_VALUE_C::number(18 , 2)                   as net_cash_value_c
    , json:NET_CASH_VALUE_DATE_C::date                        as net_cash_value_date_c
    , json:DATA_SOURCE_OVERRIDE_C::varchar(150)               as data_source_override_c
    , json:CURRENT_HISTORICAL_RECORD_C::varchar(18)           as current_historical_record_c
    , json:CUSTODIAN_C::varchar(18)                           as custodian_c
    , json:DEBT_BALANCE_C::number(18)                         as debt_balance_c
    , json:OPPORTUNITY_C::varchar(18)                         as opportunity_c
    , json:ONLY_IN_SALESFORCE_C::boolean                      as only_in_salesforce_c
    , json:BOOPERATIONAL_TAGS_C::varchar(4099)                as booperational_tags_c
    , json:BOSTALE_DATE_C::date                               as bostale_date_c
    , json:CUSTODIAN_AS_OF_DATE_C::date                       as custodian_as_of_date_c
    , json:AS_OF_DATE_C::date                                 as as_of_date_c
    , json:CUSTODIAN_RESTRICTION_NOTES_C::varchar(225)        as custodian_restriction_notes_c
    , json:CLOSING_CHECK_YTDNET_C_W_C::number(18 , 2)         as closing_check_ytdnet_c_w_c
    , json:SUBADVISOR_ID_C::varchar(240)                      as subadvisor_id_c
    , json:PAPERWORK_TYPE_ON_FILE_C::varchar(765)             as paperwork_type_on_file_c
    , json:STALE_DATE_CLIENT_C::date                          as stale_date_client_c
    , json:STALE_ACCOUNT_NOTES_C::varchar(765)                as stale_account_notes_c
    , json:STALE_DATA_TYPE_C::varchar(765)                    as stale_data_type_c
    , json:ADMIN_FEE_C::number(10)                            as admin_fee_c
    , json:BILL_CALCULATED_IN_SALESFORCE_C::boolean           as bill_calculated_in_salesforce_c
    , json:BILLABLE_MARKET_VALUE_C::number(18 , 2)            as billable_market_value_c
    , json:BILLING_ACCOUNT_NUMBER_C::varchar(300)             as billing_account_number_c
    , json:FIDELITY_PURGE_ACCOUNT_C::boolean                  as fidelity_purge_account_c
    , json:BILLING_EXCEPTION_CATEGORY_C::varchar(765)         as billing_exception_category_c
    , json:BILLING_EXCEPTION_DETAILS_C::varchar(765)          as billing_exception_details_c
    , json:BILLING_METHOD_C::varchar(765)                     as billing_method_c
    , json:BILLING_STYLE_C::varchar(765)                      as billing_style_c
    , json:DISCOUNT_RATE_C::double                            as discount_rate_c
    , json:AGGREGATED_IN_TIER_C::boolean                      as aggregated_in_tier_c
    , json:MH_BILLING_CALCULATION_C::varchar(18)              as mh_billing_calculation_c
    , json:BILLING_ACCOUNT_OUTSTANDING_FEES_C::number(18 , 2) as billing_account_outstanding_fees_c
    , json:BLOCK_ON_ACCOUNT_C::boolean                        as block_on_account_c
    , json:CAPITAL_GAINS_REINVESTED_C::boolean                as capital_gains_reinvested_c
    , json:COMPENSATION_ACCOUNT_C::boolean                    as compensation_account_c
    , json:DELINK_FROM_CUSTODIAN_C::boolean                   as delink_from_custodian_c
    , json:FIXED_INCOME_HOLDINGS_C::boolean                   as fixed_income_holdings_c
    , json:MARGIN_C::boolean                                  as margin_c
    , json:NON_DISCRETIONARY_ACCOUNT_C::boolean               as non_discretionary_account_c
    , json:ORION_RESTRICTION_CHECK_C::boolean                 as orion_restriction_check_c
    , json:PRIME_BROKER_ENABLED_C::boolean                    as prime_broker_enabled_c
    , json:SMA_C::boolean                                     as sma_c
    , json:SMA_ASSET_NAME_C::varchar(300)                     as sma_asset_name_c
    , json:TAMARAC_REBAL_ACCOUNT_C::boolean                   as tamarac_rebal_account_c
    , json:RECON_NOTES_C::varchar(765)                        as recon_notes_c
    , json:OPERATIONS_NOTES_C::varchar(765)                   as operations_notes_c
    , json:RESTRICTION_NOTES_C::varchar(765)                  as restriction_notes_c
    , json:RESTRICTION_NOTES_2_C::varchar(765)                as restriction_notes_2_c
    , json:COMPLIANCE_REVIEW_NOTES_C::varchar(765)            as compliance_review_notes_c
    , json:I_REBAL_HOUSEHOLD_C::boolean                       as i_rebal_household_c
    , json:IS_MANAGED_C::boolean                              as is_managed_c
    , json:FINANCING_COMPANY_C::varchar(18)                   as financing_company_c
    , json:LINKED_INDIVIDUAL_FIXED_INCOME_C::boolean          as linked_individual_fixed_income_c
    , json:RECON_DATE_C::date                                 as recon_date_c
    , json:MATURITY_RESTRICTION_C::varchar(765)               as maturity_restriction_c
    , json:INVESTMENT_STATUS_NOTES_C::varchar(765)            as investment_status_notes_c
    , json:RATING_RESTRICTION_C::varchar(765)                 as rating_restriction_c
    , json:OTHER_RESTRICTION_C::varchar(765)                  as other_restriction_c
    , json:DISTRIBUTION_TYPE_C::varchar(765)                  as distribution_type_c
    , json:DISTRIBUTION_AMOUNT_C::number(18)                  as distribution_amount_c
    , json:DISTRIBUTION_FREQUENCY_C::varchar(60)              as distribution_frequency_c
    , json:DURATION_C::double                                 as duration_c
    , json:SWAP_C::boolean                                    as swap_c
    , json:SWAP_CUSIPS_C::varchar(300)                        as swap_cusips_c
    , json:SWAP_NOTES_C::varchar(765)                         as swap_notes_c
    , json:POSITION_SIZE_C::varchar(300)                      as position_size_c
    , json:REPLENISH_MINIMUM_CASH_C::boolean                  as replenish_minimum_cash_c
    , json:TAX_STATUS_C::varchar(765)                         as tax_status_c
    , json:MINIMUM_CASH_C::varchar(54)                        as minimum_cash_c
    , json:BILLING_EXCEPTION_C::boolean                       as billing_exception_c
    , json:STATE_1_C::varchar(765)                            as state_1_c
    , json:STATE_2_C::varchar(765)                            as state_2_c
    , json:AM_RESTRICTIONS_C::varchar(4099)                   as am_restrictions_c
    , json:SUBADVISOR_C::varchar(18)                          as subadvisor_c
    , json:FUND_FAMILY_C::varchar(765)                        as fund_family_c
    , json:DATA_SOURCE_C::varchar(765)                        as data_source_c
    , json:RECONCILIATION_FREQUENCY_C::varchar(765)           as reconciliation_frequency_c
    , json:RECON_ASSIGNMENT_C::varchar(18)                    as recon_assignment_c
    , json:ERISA_C::varchar(765)                              as erisa_c
    , json:ERISA_CONFIRMATION_C::varchar(750)                 as erisa_confirmation_c
    , json:ERISA_AFFILIATED_INVESTMENTS_C::varchar(765)       as erisa_affiliated_investments_c
    , json:YEAR_TO_DATE_CONTRIBUTIONS_C::number(18 , 2)       as year_to_date_contributions_c
    , json:YEAR_TO_DATE_DISTRIBUTIONS_C::number(18 , 2)       as year_to_date_distributions_c
    , json:QTD_NET_CONTRIBUTIONS_BILLABLE_C::number(18 , 2)   as qtd_net_contributions_billable_c
    , json:SUBADVISOR_RATE_OVERRIDE_C::double                 as subadvisor_rate_override_c
    , json:EMAIL_TO_C::varchar(765)                           as email_to_c
    , json:ADVISOR_APPROVED_STATUS_C::double                  as advisor_approved_status_c
    , json:BILLING_ACCOUNT_C::varchar(18)                     as billing_account_c
    , json:HOUSEHOLD_C::varchar(18)                           as household_c
    , json:FEE_SCHEDULE_C::varchar(18)                        as fee_schedule_c
    , json:ECLIPSE_ENABLED_C::boolean                         as eclipse_enabled_c
    , json:ACKNOWLEDGMENT_LETTER_ON_FILE_C::boolean           as acknowledgment_letter_on_file_c
    , json:DOWNLOAD_SOURCE_C::varchar(765)                    as download_source_c
    , json:ACCOUNT_IDMSEC_C::varchar(24)                      as account_idmsec_c
    , json:MSEC_COMMISSIONS_LIFE_TO_DATE_C::number(18 , 2)    as msec_commissions_life_to_date_c
    , json:INORGANIC_FUNDS_C::boolean                         as inorganic_funds_c
    , json:INORGANIC_REVENUE_CUR_QTR_C::number(18 , 2)        as inorganic_revenue_cur_qtr_c
    , json:INORGANIC_REVENUE_PREV_QTR_C::number(18 , 2)       as inorganic_revenue_prev_qtr_c
    , json:INORGANIC_VALUE_C::number(18 , 2)                  as inorganic_value_c
    , json:OPTION_MULTI_MARGIN_C::boolean                     as option_multi_margin_c
    , json:OPTIONS_INVESTMENT_GUIDELINES_C::varchar(4099)     as options_investment_guidelines_c
    , json:OPTIONS_LEVEL_C::varchar(765)                      as options_level_c
    , json:OPTIONS_RIDER_C::varchar(765)                      as options_rider_c
    , json:CALCULATION_SYSTEM_C::varchar(765)                 as calculation_system_c
    , json:SHARE_WITH_C::varchar(765)                         as share_with_c
    , json:FIXED_INCOME_CASH_AVAILABLE_C::double              as fixed_income_cash_available_c
    , json:SYS_MIGRATION_SOURCE_C::varchar(4099)              as sys_migration_source_c
    , json:SYS_MIGRATION_ID_C::varchar(765)                   as sys_migration_id_c
    , json:EQUITY_C::double                                   as equity_c
    , json:EQUITY_GOAL_C::varchar(765)                        as equity_goal_c
    , json:FIXED_INCOME_C::double                             as fixed_income_c
    , json:YTD_REALIZED_GAIN_LOSS_C::number(18 , 2)           as ytd_realized_gain_loss_c
    , json:TRADING_ID_C::varchar(192)                         as trading_id_c
    , json:FIXED_ALTS_C::double                               as fixed_alts_c
    , json:PREF_C::double                                     as pref_c
    , json:LARGE_CAP_C::double                                as large_cap_c
    , json:SMID_C::double                                     as smid_c
    , json:INTL_EQUITY_C::double                              as intl_equity_c
    , json:MLP_REITS_C::double                                as mlp_reits_c
    , json:FIRM_TRADING_C::boolean                            as firm_trading_c
    , json:OTHER_C::double                                    as other_c
    , json:TRADING_SYSTEM_C::varchar(765)                     as trading_system_c
    , json:BROKER_DEALER_ACCOUNT_C::boolean                   as broker_dealer_account_c
    , json:ELIMINATION_PERIOD_C::double                       as elimination_period_c
    , json:MONTHLY_MAXIMUM_C::number(18 , 2)                  as monthly_maximum_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:MOXY_INTRA_DAY_IMPORT_C::boolean                   as moxy_intra_day_import_c
    , json:BILLING_CALCULATION_SYSTEM_C::varchar(765)         as billing_calculation_system_c
    , json:STALE_DATE_AGING_C::double                         as stale_date_aging_c
    , json:RECON_DATE_CALC_C::date                            as recon_date_calc_c
    , json:PARTNER_FIRM_C::varchar(3900)                      as partner_firm_c
    , json:YEAR_TO_DATE_NET_CONTRIBUTIONS_C::number(18 , 2)   as year_to_date_net_contributions_c
    , json:CURRENT_CASH_PCT_C::double                         as current_cash_pct_c
    , json:RECONCILIATION_COUNT_C::double                     as reconciliation_count_c
    , json:NON_DISC_MIX_C::varchar(3900)                      as non_disc_mix_c
    , json:INCLUDED_FOR_AFIS_C::boolean                       as included_for_afis_c
    , json:CURRENT_COMMITED_VALUE_C::number(18 , 2)           as current_commited_value_c
    , json:ESTATE_ITEM_ID_18_C::varchar(3900)                 as estate_item_id_18_c
    , json:RECONCILIATION_VALUATION_DATE_ROLLUP_C::date       as reconciliation_valuation_date_rollup_c
    , json:RECONCILIATION_DATE_ROLLUP_C::date                 as reconciliation_date_rollup_c
    , json:CURRENT_HISTORICAL_STATUS_C::varchar(3900)         as current_historical_status_c
    , json:B_D_MIX_C::varchar(3900)                           as b_d_mix_c
    , json:SYS_IS_MSECACCOUNT_C::boolean                      as sys_is_msecaccount_c
    , json:VALID_PAPERWORK_C::boolean                         as valid_paperwork_c
    , json:CASH_PERCENT_C::double                             as cash_percent_c
    , json:CURRENT_HISTORICAL_VALUATION_DATE_C::date          as current_historical_valuation_date_c
    , json:STALE_DATE_CLIENT_AGING_C::double                  as stale_date_client_aging_c
    , json:LOCATION_C::varchar(3900)                          as location_c
    , json:MSECOPT_IN_C::boolean                              as msecopt_in_c
    , json:ESTATE_ITEM_NAME_DATA_TABLE_EDIT_C::varchar(240)   as estate_item_name_data_table_edit_c
    , json:NEW_UPDATE_C::boolean                              as new_update_c
    , json:NEW_UPDATE_FORMULA_C::boolean                      as new_update_formula_c
    , json:ROLLOVER_EFFECTIVE_DATE_C::date                    as rollover_effective_date_c
    , json:ROLLOVER_PAPERWORK_C::varchar(18)                  as rollover_paperwork_c
    , json:ROLLOVER_INVOLVEMENT_C::varchar(765)               as rollover_involvement_c
    , json:ROLLOVER_TYPE_C::varchar(4099)                     as rollover_type_c
    , json:ROLLOVER_C::boolean                                as rollover_c
    , json:ANNUITY_MATURITY_DATE_C::date                      as annuity_maturity_date_c
    , json:TAX_PAYMENT_AUTHORIZATION_FORM_C::boolean          as tax_payment_authorization_form_c
    , json:TDA_LEGACY_ACCOUNT_C::varchar(200)                 as tda_legacy_account_c
    , json:TDA_LEGACY_ACCOUNT_NUMBER_C::varchar(200)          as tda_legacy_account_number_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'estate_item_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'estate_item_c') }}
