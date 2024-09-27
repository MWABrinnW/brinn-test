select
    'salesforce'::text(200)                                        as system_name
    , 'compass'::text(200)                                         as system_instance
    , concat(system_name , '__' , system_instance)::text(200)      as system_key
    , 'mwa'::text(200)                                             as firm_source
    , json:ID::varchar(18)                                         as id
    , json:OWNER_ID::varchar(18)                                   as owner_id
    , json:IS_DELETED::boolean                                     as is_deleted
    , json:NAME::varchar(240)                                      as name
    , json:RECORD_TYPE_ID::varchar(18)                             as record_type_id
    , json:CREATED_DATE::timestamptz                               as created_date
    , json:CREATED_BY_ID::varchar(18)                              as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                         as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                        as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                            as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                                as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz                           as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                       as last_referenced_date
    , json:ACCOUNT_EXECUITIVE_C::varchar(18)                       as account_execuitive_c
    , json:ACCOUNT_C::varchar(18)                                  as account_c
    , json:ACTIVE_PARTICIPANTS_C::double                           as active_participants_c
    , json:ADMINISTRATOR_BENCHMARKING_REVIEW_C::varchar(765)       as administrator_benchmarking_review_c
    , json:ADOPTION_AGREEMENT_RECEIVED_C::boolean                  as adoption_agreement_received_c
    , json:ADVISORY_OR_BROKERAGE_C::varchar(765)                   as advisory_or_brokerage_c
    , json:ALLOCATION_FREQUENCY_C::varchar(765)                    as allocation_frequency_c
    , json:AMENDMENT_EFFECTIVE_DATE_C::date                        as amendment_effective_date_c
    , json:AMENDMENTS_RECEIVED_C::boolean                          as amendments_received_c
    , json:ANALYST_C::varchar(18)                                  as analyst_c
    , json:ANNUAL_PARTICIPANT_RETIREMENT_REPORT_C::varchar(765)    as annual_participant_retirement_report_c
    , json:ASSIGNED_TIER_C::varchar(765)                           as assigned_tier_c
    , json:AUTO_ENROLLMENT_PCT_C::double                           as auto_enrollment_pct_c
    , json:AUTO_ENROLLMENT_C::boolean                              as auto_enrollment_c
    , json:BOR_DATE_C::date                                        as bor_date_c
    , json:BOR_C::varchar(765)                                     as bor_c
    , json:BEHAVIORIAL_FINANCE_REVIEW_C::varchar(765)              as behaviorial_finance_review_c
    , json:CLIENT_TYPE_C::varchar(4099)                            as client_type_c
    , json:COMPANY_MATCH_TYPE_C::varchar(765)                      as company_match_type_c
    , json:COMPANY_MATCH_C::boolean                                as company_match_c
    , json:COMPANY_NON_ELECTIVE_C::boolean                         as company_non_elective_c
    , json:COMPOSITE_PLAN_RETURN_C::number(18 , 2)                 as composite_plan_return_c
    , json:CONFIRMED_ASSETS_C::number(18 , 2)                      as confirmed_assets_c
    , json:CONSULTANT_C::varchar(18)                               as consultant_c
    , json:CONTACT_C::varchar(18)                                  as contact_c
    , json:CONTRACT_NUMBER_C::varchar(120)                         as contract_number_c
    , json:COPY_OF_INVESTMENT_POLICY_STATEMENT_C::varchar(765)     as copy_of_investment_policy_statement_c
    , json:CREATED_BY_NAME_C::varchar(300)                         as created_by_name_c
    , json:DATE_CLIENT_PROFILE_OBTAINED_C::date                    as date_client_profile_obtained_c
    , json:DATE_FIDUCIARY_DOC_PACK_PROVIDED_C::date                as date_fiduciary_doc_pack_provided_c
    , json:DATE_IAA_SUBMITTED_C::date                              as date_iaa_submitted_c
    , json:DATE_IMA_OBTAINED_C::date                               as date_ima_obtained_c
    , json:DATE_IPS_REVISED_C::date                                as date_ips_revised_c
    , json:DATE_LAST_SP_CHECKLIST_CONTRACT_REVIEW_C::date          as date_last_sp_checklist_contract_review_c
    , json:DATE_NEW_ACCOUNT_PAPERWORK_ISSUED_C::date               as date_new_account_paperwork_issued_c
    , json:DATE_NEW_ACCOUNT_SETUP_C::date                          as date_new_account_setup_c
    , json:DATE_NEW_ACCT_PAPERWORK_OBTAINED_C::date                as date_new_acct_paperwork_obtained_c
    , json:DATE_SCANNED_IN_C::date                                 as date_scanned_in_c
    , json:DATE_SIGNED_PAPERWORK_FAXED_C::date                     as date_signed_paperwork_faxed_c
    , json:DATE_TOA_COMPLETED_C::date                              as date_toa_completed_c
    , json:DATE_TOA_INTIATED_C::date                               as date_toa_intiated_c
    , json:DATE_TOA_OBTAINED_C::date                               as date_toa_obtained_c
    , json:DATE_OF_LAST_ADMIN_BENCHMARKING_REVIEW_C::date          as date_of_last_admin_benchmarking_review_c
    , json:DATE_OF_LAST_FEE_REVIEW_C::date                         as date_of_last_fee_review_c
    , json:DATE_OF_LAST_FIDUCIARY_TRAINING_C::date                 as date_of_last_fiduciary_training_c
    , json:DATE_OF_LAST_GOALS_AND_OBJECTIVES_C::date               as date_of_last_goals_and_objectives_c
    , json:DATE_OF_LAST_INDUSTRY_REPORTS_C::date                   as date_of_last_industry_reports_c
    , json:DATE_OF_LAST_LEGISLATIVE_UPDATE_C::date                 as date_of_last_legislative_update_c
    , json:DATE_OF_LAST_MODEL_CHANGES_C::date                      as date_of_last_model_changes_c
    , json:DATE_OF_LAST_PARTICIPANT_EDUCATION_C::date              as date_of_last_participant_education_c
    , json:DATE_OF_LAST_RFP_RFI_SEARCH_C::date                     as date_of_last_rfp_rfi_search_c
    , json:DATE_OF_LAST_RK_PLAN_REVIEW_C::date                     as date_of_last_rk_plan_review_c
    , json:DATE_OF_LAST_RK_REVIEW_C::date                          as date_of_last_rk_review_c
    , json:DATE_OF_LAST_REVIEW_C::date                             as date_of_last_review_c
    , json:DATE_OF_VERBAL_INTENT_C::date                           as date_of_verbal_intent_c
    , json:DOCUMENT_1_LINK_C::varchar(765)                         as document_1_link_c
    , json:DOCUMENT_2_LINK_C::varchar(765)                         as document_2_link_c
    , json:DOCUMENT_3_LINK_C::varchar(765)                         as document_3_link_c
    , json:DOCUMENT_4_LINK_C::varchar(765)                         as document_4_link_c
    , json:DOCUMENT_5_LINK_C::varchar(765)                         as document_5_link_c
    , json:DOCUMENT_EFFECTIVE_DATE_C::date                         as document_effective_date_c
    , json:EDUCATION_SPECIALIST_C::varchar(18)                     as education_specialist_c
    , json:ELIGIBILITY_PROVISIONS_SERVICE_C::varchar(765)          as eligibility_provisions_service_c
    , json:ELIGIBILITY_PROVISIONS_C::varchar(765)                  as eligibility_provisions_c
    , json:EMPLOYEE_WELLNESS_SURVEY_C::varchar(765)                as employee_wellness_survey_c
    , json:ENTRY_DATES_C::varchar(765)                             as entry_dates_c
    , json:FEE_ANALYSIS_SCHEDULE_C::varchar(765)                   as fee_analysis_schedule_c
    , json:FEE_ANALYSIS_C::varchar(765)                            as fee_analysis_c
    , json:FEE_SCHEDULE_C::varchar(18)                             as fee_schedule_c
    , json:FIDUCIARY_DOCUMENT_PACK_C::varchar(765)                 as fiduciary_document_pack_c
    , json:FIDUCIARY_RELATIONSHIP_C::varchar(765)                  as fiduciary_relationship_c
    , json:FIDUCIARY_TRAINING_SCHEDULE_C::varchar(765)             as fiduciary_training_schedule_c
    , json:FINANCIAL_HARDSHIP_C::boolean                           as financial_hardship_c
    , json:FIRM_PLAN_ID_C::varchar(765)                            as firm_plan_id_c
    , json:FIRM_PLAN_STATUS_C::varchar(765)                        as firm_plan_status_c
    , json:FIRM_REFRESH_DATE_TIME_C::timestamptz                   as firm_refresh_date_time_c
    , json:FIRST_PAYROLL_SUBMISSION_COMPLETED_C::date              as first_payroll_submission_completed_c
    , json:GOALS_AND_OBJECTIVES_C::varchar(765)                    as goals_and_objectives_c
    , json:HOUSEHOLD_C::varchar(18)                                as household_c
    , json:HOW_MANY_ACCOUNTS_OF_EACH_TYPE_C::varchar(765)          as how_many_accounts_of_each_type_c
    , json:IAA_VERSION_C::varchar(765)                             as iaa_version_c
    , json:IMA_FEE_C::double                                       as ima_fee_c
    , json:IMPORT_ID_C::varchar(90)                                as import_id_c
    , json:IN_SERVICE_WITHDRAW_C::boolean                          as in_service_withdraw_c
    , json:INDUSTRY_NAME_C::varchar(765)                           as industry_name_c
    , json:INDUSTRY_REPORTS_C::varchar(765)                        as industry_reports_c
    , json:INVESTMENT_MENU_C::varchar(765)                         as investment_menu_c
    , json:LAST_MODIFIED_BY_NAME_C::varchar(300)                   as last_modified_by_name_c
    , json:LEAD_ORIGINATOR_C::varchar(300)                         as lead_originator_c
    , json:LEGISLATIVE_UPDATE_C::varchar(765)                      as legislative_update_c
    , json:LOANS_C::boolean                                        as loans_c
    , json:MRA_INVESTMENT_REVIEW_SCHEDULE_C::varchar(98304)        as mra_investment_review_schedule_c
    , json:MATCH_PROVISIONS_C::varchar(765)                        as match_provisions_c
    , json:MATCHING_FORMULA_C::varchar(300)                        as matching_formula_c
    , json:MODEL_PORTFOLIO_C::varchar(765)                         as model_portfolio_c
    , json:MODELS_PER_ACCOUNT_C::varchar(765)                      as models_per_account_c
    , json:NON_ELECTIVE_FORMULA_C::varchar(300)                    as non_elective_formula_c
    , json:NUMBER_OF_FUNDS_C::double                               as number_of_funds_c
    , json:NUMBER_OF_OUTSTANDING_LOANS_C::double                   as number_of_outstanding_loans_c
    , json:OPPORTUNITY_C::varchar(18)                              as opportunity_c
    , json:OTHER_ELIGIBILITY_AGE_C::varchar(150)                   as other_eligibility_age_c
    , json:OTHER_ELIGIBILITY_SERVICE_C::varchar(240)               as other_eligibility_service_c
    , json:OTHER_VESTING_SCHEDULE_C::varchar(360)                  as other_vesting_schedule_c
    , json:OUTSTANDING_LOAN_AMOUNT_C::number(18 , 2)               as outstanding_loan_amount_c
    , json:OWNER_NAME_C::varchar(300)                              as owner_name_c
    , json:PARTICIPANT_EDUCATION_PLAN_C::varchar(765)              as participant_education_plan_c
    , json:PARTICIPANTS_ACTUAL_C::double                           as participants_actual_c
    , json:PARTICIPANTS_ELIGIBLE_C::double                         as participants_eligible_c
    , json:PARTICIPANTS_WITH_THREE_PLUS_FUNDS_C::double            as participants_with_three_plus_funds_c
    , json:PARTICIPATIONS_TERMED_C::double                         as participations_termed_c
    , json:PLAN_ASSETS_AS_OF_DATE_C::date                          as plan_assets_as_of_date_c
    , json:PLAN_ASSETS_C::number(18 , 2)                           as plan_assets_c
    , json:PLAN_DEFERRAL_RATE_C::double                            as plan_deferral_rate_c
    , json:PLAN_ENTRY_DATES_C::varchar(765)                        as plan_entry_dates_c
    , json:PLAN_IMPLEMENTATION_COMPLETED_C::date                   as plan_implementation_completed_c
    , json:PLAN_PARTICIPATION_RATE_C::double                       as plan_participation_rate_c
    , json:PLAN_TAX_ID_C::varchar(765)                             as plan_tax_id_c
    , json:PLAN_TYPE_C::varchar(765)                               as plan_type_c
    , json:PLAN_YEAR_END_C::varchar(765)                           as plan_year_end_c
    , json:PLATFORM_C::varchar(765)                                as platform_c
    , json:PRIMARY_CONTACT_C::varchar(18)                          as primary_contact_c
    , json:PRODUCT_TYPE_C::varchar(765)                            as product_type_c
    , json:PROVIDER_NAME_C::varchar(765)                           as provider_name_c
    , json:PROVIDER_PRODUCT_NAME_C::varchar(765)                   as provider_product_name_c
    , json:QDIA_FUND_C::varchar(765)                               as qdia_fund_c
    , json:QUARTERBACK_NAME_C::varchar(300)                        as quarterback_name_c
    , json:QUARTERBACK_C::varchar(18)                              as quarterback_c
    , json:RFP_RFI_SEARCH_C::varchar(765)                          as rfp_rfi_search_c
    , json:RIA_FIRM_NAME_C::varchar(765)                           as ria_firm_name_c
    , json:RK_PLAN_REVIEW_C::varchar(765)                          as rk_plan_review_c
    , json:RK_REVIEW_SCHEDULE_C::varchar(765)                      as rk_review_schedule_c
    , json:REASON_FOR_DELAY_C::varchar(765)                        as reason_for_delay_c
    , json:RECORD_KEEPER_PLAN_NUMBER_C::varchar(765)               as record_keeper_plan_number_c
    , json:RECORDKEEPER_PRODUCT_NAME_C::varchar(765)               as recordkeeper_product_name_c
    , json:RECORDKEEPER_C::varchar(18)                             as recordkeeper_c
    , json:REPORT_EMAIL_ADDRESS_C::varchar(765)                    as report_email_address_c
    , json:REPORT_SCHEDULE_C::varchar(4099)                        as report_schedule_c
    , json:REVIEW_FREQUENCY_C::varchar(765)                        as review_frequency_c
    , json:ROTH_401_K_C::boolean                                   as roth_401_k_c
    , json:SFDC_PROJECT_END_DATE_C::date                           as sfdc_project_end_date_c
    , json:SFDC_PROJECT_MANAGER_C::varchar(18)                     as sfdc_project_manager_c
    , json:SFDC_PROJECT_STAGE_C::varchar(765)                      as sfdc_project_stage_c
    , json:SFDC_PROJECT_START_DATE_C::date                         as sfdc_project_start_date_c
    , json:SFDC_PROJECT_STATUS_C::varchar(765)                     as sfdc_project_status_c
    , json:SFDC_STATUS_DESCRIPTION_C::varchar(765)                 as sfdc_status_description_c
    , json:SPD_EFFECTIVE_DATE_C::date                              as spd_effective_date_c
    , json:SPD_RECEIVED_C::boolean                                 as spd_received_c
    , json:SP_CHECKLIST_CONTRACT_REVIEW_C::varchar(765)            as sp_checklist_contract_review_c
    , json:SAFE_HARBOR_INDICATOR_C::boolean                        as safe_harbor_indicator_c
    , json:SOURCE_OF_FUNDS_C::varchar(765)                         as source_of_funds_c
    , json:TPA_OBTAINED_C::date                                    as tpa_obtained_c
    , json:TPA_C::varchar(18)                                      as tpa_c
    , json:TEMPORARY_ACCOUNT_NUMBER_C::varchar(300)                as temporary_account_number_c
    , json:TIER_C::varchar(765)                                    as tier_c
    , json:TOTAL_CONTRIBUTION_AMOUNT_C::number(18 , 2)             as total_contribution_amount_c
    , json:TOTAL_DISTRIBUTION_AMOUNT_C::number(18 , 2)             as total_distribution_amount_c
    , json:TOTAL_MARKET_VALUE_C::number(18 , 2)                    as total_market_value_c
    , json:TOTAL_PLAN_NET_AMOUNT_C::number(18 , 2)                 as total_plan_net_amount_c
    , json:TRANSFER_FREQUENCY_C::varchar(765)                      as transfer_frequency_c
    , json:TRANSFER_OF_ASSETS_COMPLETED_C::date                    as transfer_of_assets_completed_c
    , json:TYPES_OF_ACCOUNTS_C::varchar(765)                       as types_of_accounts_c
    , json:UNINVESTED_CASH_C::number(18 , 2)                       as uninvested_cash_c
    , json:VENDOR_REVIEW_SCHEDULE_C::varchar(98304)                as vendor_review_schedule_c
    , json:VESTING_SCHEDULE_C::varchar(765)                        as vesting_schedule_c
    , json:X_401_K_SIZE_C::number(18)                              as x_401_k_size_c
    , json:E_MONEY_C::varchar(765)                                 as e_money_c
    , json:OR_DOLLAR_AMOUNT_C::varchar(765)                        as or_dollar_amount_c
    , json:ACCOUNT_IDORION_C::varchar(24)                          as account_idorion_c
    , json:BILLING_METHOD_C::varchar(765)                          as billing_method_c
    , json:BILLING_FREQUENCY_C::varchar(765)                       as billing_frequency_c
    , json:DATE_FEE_FORMS_SUBMITTED_TO_RECORDKEEPER_C::date        as date_fee_forms_submitted_to_recordkeeper_c
    , json:CURRENT_FEE_AT_RECORDKEEPER_C::double                   as current_fee_at_recordkeeper_c
    , json:OPERATIONS_NOTES_C::varchar(765)                        as operations_notes_c
    , json:DATE_OF_LAST_FEE_REVIEW_CONFIRMED_C::date               as date_of_last_fee_review_confirmed_c
    , json:CUSTODIAN_C::varchar(18)                                as custodian_c
    , json:ACCOUNTING_TRACKING_NUMBER_C::varchar(150)              as accounting_tracking_number_c
    , json:START_DATE_C::date                                      as start_date_c
    , json:CLOSE_DATE_C::date                                      as close_date_c
    , json:_FIVETRAN_SYNCED::timestamptz                           as _fivetran_synced
    , json:AUM_CLASSIFICATION_C::varchar(765)                      as aum_classification_c
    , json:ACTUARY_C::varchar(765)                                 as actuary_c
    , json:THIRD_PARTY_ADMINISTRATOR_TPA_C::varchar(765)           as third_party_administrator_tpa_c
    , json:AUDITOR_C::varchar(765)                                 as auditor_c
    , json:REVIEW_SCHEDULE_C::varchar(4099)                        as review_schedule_c
    , json:HSA_PROVIDER_C::varchar(765)                            as hsa_provider_c
    , json:IN_PLAN_ROTH_CONVERSION_C::boolean                      as in_plan_roth_conversion_c
    , json:RK_RFP_RFI_C::varchar(765)                              as rk_rfp_rfi_c
    , json:FINANCIAL_WELLNESS_C::varchar(765)                      as financial_wellness_c
    , json:MARINER_MANAGED_ACCOUNTS_C::boolean                     as mariner_managed_accounts_c
    , json:EDUCATION_MEETING_FREQUENCY_C::varchar(765)             as education_meeting_frequency_c
    , json:EDUCATION_MEETING_TYPE_C::varchar(765)                  as education_meeting_type_c
    , json:EDUCATION_RPS_PERSONNEL_C::varchar(18)                  as education_rps_personnel_c
    , json:AUTO_INCREASE_PCT_C::double                             as auto_increase_pct_c
    , json:ADVISOR_RFP_RFI_SEARCH_C::varchar(765)                  as advisor_rfp_rfi_search_c
    , json:HSA_C::boolean                                          as hsa_c
    , json:DATE_OF_LAST_RK_RFP_RFI_C::date                         as date_of_last_rk_rfp_rfi_c
    , json:STUDENT_LOAN_REPAYMENT_C::boolean                       as student_loan_repayment_c
    , json:AUTO_INCREASE_C::boolean                                as auto_increase_c
    , json:AFTER_TAX_C::boolean                                    as after_tax_c
    , json:TDF_SERIES_C::varchar(765)                              as tdf_series_c
    , json:DATE_OF_LAST_ADVISOR_RFP_RFI_SEARCH_C::date             as date_of_last_advisor_rfp_rfi_search_c
    , json:PARTNER_FIRM_C::varchar(3900)                           as partner_firm_c
    , json:ACCOUNT_TIER_C::varchar(3900)                           as account_tier_c
    , json:DAYS_SINCE_FEE_UPDATED_AT_RECORDKEEPER_C::double        as days_since_fee_updated_at_recordkeeper_c
    , json:SFDC_PROJECT_DURATION_C::double                         as sfdc_project_duration_c
    , json:PLAN_ID_18_C::varchar(3900)                             as plan_id_18_c
    , json:RATE_BASED_ON_MOST_RECENT_ASSETS_C::double              as rate_based_on_most_recent_assets_c
    , json:DAYS_UNTIL_IPS_EXPIRES_C::double                        as days_until_ips_expires_c
    , json:SFDC_DAYS_REMAINING_C::double                           as sfdc_days_remaining_c
    , json:DAYS_UNTIL_NEW_IPS_DUE_C::double                        as days_until_new_ips_due_c
    , json:X_5_TH_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_5_th_tier_dollars_threshold_c
    , json:FLAT_FEE_TYPE_C::varchar(765)                           as flat_fee_type_c
    , json:FLAT_PERCENT_FEE_C::double                              as flat_percent_fee_c
    , json:X_3_RD_TIER_PERCENT_C::double                           as x_3_rd_tier_percent_c
    , json:FEE_TYPE_C::varchar(765)                                as fee_type_c
    , json:FLAT_ANNUAL_FEE_C::number(18 , 2)                       as flat_annual_fee_c
    , json:ADVISORY_FEE_SCHEDULE_C::varchar(3900)                  as advisory_fee_schedule_c
    , json:X_4_TH_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_4_th_tier_dollars_threshold_c
    , json:X_1_ST_TIER_PERCENT_C::double                           as x_1_st_tier_percent_c
    , json:X_2_ND_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_2_nd_tier_dollars_threshold_c
    , json:X_1_ST_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_1_st_tier_dollars_threshold_c
    , json:X_4_TH_TIER_PERCENT_C::double                           as x_4_th_tier_percent_c
    , json:X_5_TH_TIER_PERCENT_C::double                           as x_5_th_tier_percent_c
    , json:NUMBER_OF_FEE_TIERS_C::varchar(765)                     as number_of_fee_tiers_c
    , json:X_3_RD_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_3_rd_tier_dollars_threshold_c
    , json:X_2_ND_TIER_PERCENT_C::double                           as x_2_nd_tier_percent_c
    , json:MH_LOCATION_C::varchar(18)                              as mh_location_c
    , json:X_3_RD_MARINER_MANAGED_TIER_THRESHOLD_C::number(18 , 2) as x_3_rd_mariner_managed_tier_threshold_c
    , json:MSEC_REGISTRATION_C::boolean                            as msec_registration_c
    , json:VENROLLMENT_VIDEO_C::boolean                            as venrollment_video_c
    , json:X_1_ST_MARINER_MANAGED_TIER_C::double                   as x_1_st_mariner_managed_tier_c
    , json:X_4_TH_MARINER_MANAGED_TIER_C::double                   as x_4_th_mariner_managed_tier_c
    , json:BILL_ON_BALANCE_C::varchar(765)                         as bill_on_balance_c
    , json:X_4_TH_MARINER_MANAGED_TIER_THRESHOLD_C::number(18 , 2) as x_4_th_mariner_managed_tier_threshold_c
    , json:AMA_BALANCE_C::number(18 , 2)                           as ama_balance_c
    , json:X_6_TH_TIER_PERCENT_C::double                           as x_6_th_tier_percent_c
    , json:MARINER_MANAGED_NUMBER_OF_FEE_TIERS_C::varchar(765)     as mariner_managed_number_of_fee_tiers_c
    , json:TRUST_COMPANY_C::varchar(765)                           as trust_company_c
    , json:SERVICE_MODEL_C::varchar(765)                           as service_model_c
    , json:X_6_TH_TIER_DOLLARS_THRESHOLD_C::number(18 , 2)         as x_6_th_tier_dollars_threshold_c
    , json:X_1_ST_MARINER_MANAGED_TIER_THRESHOLD_C::number(18 , 2) as x_1_st_mariner_managed_tier_threshold_c
    , json:X_2_ND_MARINER_MANAGED_TIER_C::double                   as x_2_nd_mariner_managed_tier_c
    , json:APPROXIMATE_ANNUAL_CONTRIBUTION_C::varchar(765)         as approximate_annual_contribution_c
    , json:X_2_ND_MARINER_MANAGED_TIER_THRESHOLD_C::number(18 , 2) as x_2_nd_mariner_managed_tier_threshold_c
    , json:FIXED_ICR_C::double                                     as fixed_icr_c
    , json:INTEREST_CREDITING_RATE_STRATEGY_C::varchar(765)        as interest_crediting_rate_strategy_c
    , json:X_3_RD_MARINER_MANAGED_TIER_C::double                   as x_3_rd_mariner_managed_tier_c
    , json:TRANSFERRED_BALANCE_C::varchar(765)                     as transferred_balance_c
    , json:GENERAL_NOTES_C::varchar(765)                           as general_notes_c
    , json:BILLING_NOTES_C::varchar(765)                           as billing_notes_c
    , json:QUARTER_END_NOTES_C::varchar(765)                       as quarter_end_notes_c
    , json:PRIMARY_INTRODUCER_C::varchar(18)                       as primary_introducer_c
    , json:MARINER_MANAGED_FLAT_ANNUAL_FEE_C::number(18 , 2)       as mariner_managed_flat_annual_fee_c
    , json:MARINER_MANAGED_FLAT_FEE_TYPE_C::varchar(765)           as mariner_managed_flat_fee_type_c
    , json:MARINER_MANAGED_FLAT_PERCENT_FEE_C::double              as mariner_managed_flat_percent_fee_c
    , json:MARINER_MANAGED_FEE_TYPE_C::varchar(765)                as mariner_managed_fee_type_c
    , json:_FIVETRAN_DELETED::boolean                              as _fivetran_deleted

    , effective_at::timestamp                                      as effective_at
    , _created_at::timestamp                                       as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'plan_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                            as is_latest
from {{ source('salesforce_compass', 'plan_c') }}
