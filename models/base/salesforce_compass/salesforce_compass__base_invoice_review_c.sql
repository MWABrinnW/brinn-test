select
    'salesforce'::text(200)                                           as system_name
    , 'compass'::text(200)                                            as system_instance
    , concat(system_name , '__' , system_instance)::text(200)         as system_key
    , 'mwa'::text(200)                                                as firm_source
    , json:ID::varchar(18)                                            as id
    , json:IS_DELETED::boolean                                        as is_deleted
    , json:NAME::varchar(240)                                         as name
    , json:RECORD_TYPE_ID::varchar(18)                                as record_type_id
    , json:CREATED_DATE::timestamptz                                  as created_date
    , json:CREATED_BY_ID::varchar(18)                                 as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                            as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                           as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                               as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                                   as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz                              as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                          as last_referenced_date
    , json:APX_RECONCILIATION_C::boolean                              as apx_reconciliation_c
    , json:ADJUSTMENT_CREDIT_REMAINING_C::number(18 , 2)              as adjustment_credit_remaining_c
    , json:ADJUSTMENTS_FEE_C::number(18 , 2)                          as adjustments_fee_c
    , json:ADMIN_FEE_TOTAL_C::number(18 , 2)                          as admin_fee_total_c
    , json:ADVISOR_APPROVED_DATE_C::date                              as advisor_approved_date_c
    , json:ADVISOR_COMMENTS_C::varchar(765)                           as advisor_comments_c
    , json:APPROVED_BY_ADVISOR_C::varchar(150)                        as approved_by_advisor_c
    , json:VIEW_TYPE_HH_PLUS_CLIENT_C::varchar(18)                    as view_type_hh_plus_client_c
    , json:BC_ADJUSTMENTS_FEE_C::number(18 , 2)                       as bc_adjustments_fee_c
    , json:BC_ADJUSTMENTS_STORED_C::number(18 , 2)                    as bc_adjustments_stored_c
    , json:BC_BILLABLE_VALUE_STORED_C::number(18 , 2)                 as bc_billable_value_stored_c
    , json:BC_BILLING_STYLE_STORED_C::varchar(21)                     as bc_billing_style_stored_c
    , json:BC_FEE_SCHEDULE_STORED_C::varchar(600)                     as bc_fee_schedule_stored_c
    , json:DATE_FINALIZED_C::date                                     as date_finalized_c
    , json:BC_GROSS_FEE_STORED_C::number(18 , 2)                      as bc_gross_fee_stored_c
    , json:BILLABLE_VALUE_C::number(18 , 2)                           as billable_value_c
    , json:TEAM_MEMBER_ASSIGNED_C::varchar(18)                        as team_member_assigned_c
    , json:BILLING_CALCULATION_STATUS_C::varchar(765)                 as billing_calculation_status_c
    , json:BILLING_ERROR_TIMESTAMP_C::timestamptz                     as billing_error_timestamp_c
    , json:BILLING_EXCEPTION_COMPLETED_C::boolean                     as billing_exception_completed_c
    , json:BILLING_METHOD_OLD_C::varchar(765)                         as billing_method_old_c
    , json:BILLING_REJECT_NOTES_C::varchar(600)                       as billing_reject_notes_c
    , json:DATE_TO_PULL_FEE_C::date                                   as date_to_pull_fee_c
    , json:BILLING_STYLE_C::varchar(765)                              as billing_style_c
    , json:BRANCH_2_C::varchar(150)                                   as branch_2_c
    , json:BILLING_ACCOUNT_OUTSTANDING_FEES_NEW_C::number(18 , 2)     as billing_account_outstanding_fees_new_c
    , json:CALCULATION_AS_OF_DATE_C::date                             as calculation_as_of_date_c
    , json:CALCULATION_FINALIZED_TIMESTAMP_C::timestamptz             as calculation_finalized_timestamp_c
    , json:COLLECTION_DATE_C::date                                    as collection_date_c
    , json:COLLECTION_NOTES_C::varchar(600)                           as collection_notes_c
    , json:COLLECTION_SHEET_NAME_C::varchar(120)                      as collection_sheet_name_c
    , json:COMPANY_FAMILY_C::varchar(18)                              as company_family_c
    , json:WHO_WORKED_REJECT_C::varchar(765)                          as who_worked_reject_c
    , json:FEE_ESTIMATE_C::number(18 , 2)                             as fee_estimate_c
    , json:FEE_EXCLUDED_ASSETS_C::number(18 , 2)                      as fee_excluded_assets_c
    , json:FEE_REBATES_C::number(18 , 2)                              as fee_rebates_c
    , json:FEE_SCHEDULE_C::varchar(600)                               as fee_schedule_c
    , json:FEE_TYPE_C::varchar(765)                                   as fee_type_c
    , json:FINALIZED_FEE_STATUS_C::varchar(765)                       as finalized_fee_status_c
    , json:FIRST_LEVEL_APPROVAL_DATE_C::timestamptz                   as first_level_approval_date_c
    , json:FIRST_LEVEL_APPROVER_C::varchar(150)                       as first_level_approver_c
    , json:GROSS_FEE_C::number(18 , 2)                                as gross_fee_c
    , json:INSUFFICIENT_FUNDS_WORKFLOW_COUNT_C::double                as insufficient_funds_workflow_count_c
    , json:PLAN_C::varchar(18)                                        as plan_c
    , json:DATE_REJECT_RESOLVED_C::date                               as date_reject_resolved_c
    , json:FEE_FREQUENCY_C::varchar(765)                              as fee_frequency_c
    , json:VALUATION_METHOD_C::varchar(765)                           as valuation_method_c
    , json:BILLING_ACCOUNT_NUMBER_AUDIT_TRACKING_C::varchar(300)      as billing_account_number_audit_tracking_c
    , json:READY_FOR_COLLECTIONS_AUDIT_TRACKING_C::boolean            as ready_for_collections_audit_tracking_c
    , json:NON_WAS_REFERRAL_FEE_C::number(18 , 2)                     as non_was_referral_fee_c
    , json:SERVICE_RENDERED_C::varchar(18)                            as service_rendered_c
    , json:SOURCE_INVOICE_IDENTIFIER_C::varchar(90)                   as source_invoice_identifier_c
    , json:CALCULATION_SYSTEM_C::varchar(765)                         as calculation_system_c
    , json:INVOICE_DATE_C::date                                       as invoice_date_c
    , json:INVOICE_LINK_C::varchar(765)                               as invoice_link_c
    , json:MANAGEMENT_STYLE_C::varchar(240)                           as management_style_c
    , json:MANUAL_REVIEW_DATE_C::timestamptz                          as manual_review_date_c
    , json:MANUAL_REVIEWER_C::varchar(150)                            as manual_reviewer_c
    , json:MISCELLANEOUS_ADJUSTMENT_REASON_C::varchar(765)            as miscellaneous_adjustment_reason_c
    , json:MISCELLANEOUS_ADJUSTMENT_C::number(18 , 2)                 as miscellaneous_adjustment_c
    , json:NTF_1_C::double                                            as ntf_1_c
    , json:NTF_2_C::double                                            as ntf_2_c
    , json:NTF_3_C::double                                            as ntf_3_c
    , json:NTF_FEE_C::number(18 , 2)                                  as ntf_fee_c
    , json:NET_CONTRIBUTIONS_FEE_C::number(18 , 2)                    as net_contributions_fee_c
    , json:OPERATIONS_APPROVAL_DATE_C::date                           as operations_approval_date_c
    , json:OPERATIONS_COMMENTS_C::varchar(765)                        as operations_comments_c
    , json:ORION_BILL_ID_C::varchar(21)                               as orion_bill_id_c
    , json:OVERIDE_BILLING_CUSTODIAN_C::varchar(765)                  as overide_billing_custodian_c
    , json:PAYOUT_STATUS_C::varchar(765)                              as payout_status_c
    , json:PAYOUT_TIMESTAMP_C::timestamptz                            as payout_timestamp_c
    , json:QPR_LINKING_C::varchar(18)                                 as qpr_linking_c
    , json:QUARTERBACK_2_C::varchar(90)                               as quarterback_2_c
    , json:REJECT_CATEGORY_C::varchar(765)                            as reject_category_c
    , json:REJECTED_COUNT_C::double                                   as rejected_count_c
    , json:REJECTED_DATE_C::timestamptz                               as rejected_date_c
    , json:STATUS_C::varchar(765)                                     as status_c
    , json:THIRD_PARTY_CALCULATION_C::boolean                         as third_party_calculation_c
    , json:TOTAL_ACCOUNT_VALUE_C::number(18 , 2)                      as total_account_value_c
    , json:WAS_FEE_C::number(18 , 2)                                  as was_fee_c
    , json:WRITE_OFF_FEE_C::number(18 , 2)                            as write_off_fee_c
    , json:X_40_ACT_FEE_C::number(18 , 2)                             as x_40_act_fee_c
    , json:BILLING_ACCOUNT_C::varchar(18)                             as billing_account_c
    , json:ACCOUNT_GENERATING_FEE_C::varchar(18)                      as account_generating_fee_c
    , json:OLD_NAME_C::varchar(90)                                    as old_name_c
    , json:ESTATE_ITEM_C::varchar(18)                                 as estate_item_c
    , json:AR_AP_ITEM_C::varchar(18)                                  as ar_ap_item_c
    , json:DATE_LAST_INVOICE_SENT_C::date                             as date_last_invoice_sent_c
    , json:_FIVETRAN_SYNCED::timestamptz                              as _fivetran_synced
    , json:FINANCIAL_ACCOUNT_HOUSEHOLD_ID_DEL_C::varchar(3900)        as financial_account_household_id_del_c
    , json:FEE_RATE_C::double                                         as fee_rate_c
    , json:REVENUE_AS_OF_DATE_C::date                                 as revenue_as_of_date_c
    , json:CLIENT_PREVIOUS_QTR_FEE_C::number(18 , 2)                  as client_previous_qtr_fee_c
    , json:REGISTRATION_SUMMARY_C::varchar(3900)                      as registration_summary_c
    , json:INVOICE_HYPERLINK_C::varchar(3900)                         as invoice_hyperlink_c
    , json:READY_FOR_COLLECTIONS_C::boolean                           as ready_for_collections_c
    , json:DAYS_SINCE_REJECTED_C::double                              as days_since_rejected_c
    , json:CLIENT_UNIQUE_IDENTIFIER_C::varchar(3900)                  as client_unique_identifier_c
    , json:ADVISOR_APPROVED_STATUS_C::double                          as advisor_approved_status_c
    , json:CASH_DEFICIT_AMOUNT_C::number(18 , 2)                      as cash_deficit_amount_c
    , json:CONCATENATE_2_C::varchar(3900)                             as concatenate_2_c
    , json:BILLING_ACCOUNT_NUMBER_C::varchar(3900)                    as billing_account_number_c
    , json:WAS_PERCENTAGE_C::double                                   as was_percentage_c
    , json:ORION_ACCOUNT_ID_C::varchar(3900)                          as orion_account_id_c
    , json:BC_BILLING_STYLE_C::varchar(3900)                          as bc_billing_style_c
    , json:BILLING_METHOD_C::varchar(3900)                            as billing_method_c
    , json:ACCOUNT_CLOSE_DATE_C::date                                 as account_close_date_c
    , json:CLIENT_NAME_C::varchar(3900)                               as client_name_c
    , json:ACCOUNT_TYPE_C::varchar(3900)                              as account_type_c
    , json:CASH_DEFICIT_C::boolean                                    as cash_deficit_c
    , json:CLIENT_AGREEMENT_VERSION_C::varchar(3900)                  as client_agreement_version_c
    , json:CLIENT_CURRENT_QTR_FEE_C::number(18 , 2)                   as client_current_qtr_fee_c
    , json:INVOICE_ON_QPR_C::boolean                                  as invoice_on_qpr_c
    , json:BILLING_ACCOUNT_HOUSEHOLD_ID_DEL_C::varchar(3900)          as billing_account_household_id_del_c
    , json:DISCOUNT_AMOUNT_C::number(18 , 2)                          as discount_amount_c
    , json:AGGREGATED_IN_TIER_C::boolean                              as aggregated_in_tier_c
    , json:SUBADVISOR_PAYOUT_AMOUNT_C::number(18 , 2)                 as subadvisor_payout_amount_c
    , json:REFERRAL_FEE_PAID_C::number(18 , 2)                        as referral_fee_paid_c
    , json:CLIENT_FEE_CHANGE_AMT_C::number(18 , 2)                    as client_fee_change_amt_c
    , json:RECON_DATE_C::date                                         as recon_date_c
    , json:ADJUSTMENTS_CROSS_CHECK_C::number(18 , 2)                  as adjustments_cross_check_c
    , json:RUN_RATE_REVENUE_C::number(18 , 2)                         as run_rate_revenue_c
    , json:FINAL_FEE_CHANGE_PERC_C::double                            as final_fee_change_perc_c
    , json:NET_FEE_C::number(18 , 2)                                  as net_fee_c
    , json:QUARTERBACK_C::varchar(3900)                               as quarterback_c
    , json:ORION_HOUSE_ID_C::varchar(3900)                            as orion_house_id_c
    , json:FEE_ACCOUNT_C::varchar(3900)                               as fee_account_c
    , json:CLIENT_FEE_CHANGE_PERC_C::double                           as client_fee_change_perc_c
    , json:STATUS_SUMMARY_C::varchar(3900)                            as status_summary_c
    , json:BILLING_ACCOUNT_FORMATTED_C::varchar(3900)                 as billing_account_formatted_c
    , json:DAYS_OUTSTANDING_C::double                                 as days_outstanding_c
    , json:BILLING_ACCOUNT_TAX_STATUS_C::varchar(3900)                as billing_account_tax_status_c
    , json:ACCOUNT_CURRENT_QTR_FEE_C::number(18 , 2)                  as account_current_qtr_fee_c
    , json:BILLING_ERROR_TIMESTAMP_ELAPSED_C::double                  as billing_error_timestamp_elapsed_c
    , json:REFERRAL_FEE_C::number(18 , 2)                             as referral_fee_c
    , json:WAS_CATEGORY_C::varchar(3900)                              as was_category_c
    , json:QPR_STATUS_C::varchar(3900)                                as qpr_status_c
    , json:REFERRAL_FEE_ESTIMATE_C::number(18 , 2)                    as referral_fee_estimate_c
    , json:SUBADVISOR_C::varchar(3900)                                as subadvisor_c
    , json:DAYS_IN_QTR_PRIOR_TO_INVOICE_C::double                     as days_in_qtr_prior_to_invoice_c
    , json:IS_QUALIFIED_C::boolean                                    as is_qualified_c
    , json:BC_GROSS_FEE_C::number(18 , 2)                             as bc_gross_fee_c
    , json:BILLING_EXCEPTION_DETAILS_C::varchar(3900)                 as billing_exception_details_c
    , json:CONCATENATE_3_C::varchar(3900)                             as concatenate_3_c
    , json:ADMIN_FEE_C::number(18)                                    as admin_fee_c
    , json:GROSS_REVENUE_NO_ADJUSTMENTS_C::number(18 , 2)             as gross_revenue_no_adjustments_c
    , json:FIRST_LEVEL_SUMMARY_C::varchar(3900)                       as first_level_summary_c
    , json:AVG_ANNUAL_GROSS_FEE_RATE_C::double                        as avg_annual_gross_fee_rate_c
    , json:ACCOUNT_NUMBER_C::varchar(3900)                            as account_number_c
    , json:REGISTRATION_NAME_C::varchar(3900)                         as registration_name_c
    , json:PREVIOUS_QTR_FEE_C::number(18 , 2)                         as previous_qtr_fee_c
    , json:QUARTER_END_CLIENT_RECON_C::date                           as quarter_end_client_recon_c
    , json:MODEL_ON_ACCOUNT_C::varchar(3900)                          as model_on_account_c
    , json:BILLING_EXCEPTION_C::boolean                               as billing_exception_c
    , json:BILLING_ACCOUNT_OUTSTANDING_FEES_C::number(18 , 2)         as billing_account_outstanding_fees_c
    , json:BILLING_ACCOUNT_TYPE_C::varchar(3900)                      as billing_account_type_c
    , json:FEE_TYPE_SUMMARY_C::varchar(3900)                          as fee_type_summary_c
    , json:CUSTODIAN_C::varchar(3900)                                 as custodian_c
    , json:BILLING_EXCEPTION_CATEGORY_C::varchar(3900)                as billing_exception_category_c
    , json:BILLING_ACCOUNT_CASH_C::number(18 , 2)                     as billing_account_cash_c
    , json:DISCOUNT_RATE_C::double                                    as discount_rate_c
    , json:BILLING_CUSTODIAN_C::varchar(3900)                         as billing_custodian_c
    , json:SUBADVISOR_PAYOUT_RATE_C::double                           as subadvisor_payout_rate_c
    , json:COLLECTION_MONTH_C::double                                 as collection_month_c
    , json:START_DATE_C::date                                         as start_date_c
    , json:SHORT_NAME_C::varchar(3900)                                as short_name_c
    , json:REVENUE_QUARTER_C::varchar(3900)                           as revenue_quarter_c
    , json:FINAL_FEE_CHANGE_AMT_C::number(18)                         as final_fee_change_amt_c
    , json:AUM_CLASSIFICATION_C::varchar(3900)                        as aum_classification_c
    , json:GROSS_REVENUE_C::number(18 , 2)                            as gross_revenue_c
    , json:INVOICE_QUARTER_C::varchar(3900)                           as invoice_quarter_c
    , json:MSEC_COMMISSIONS_LAST_12_MONTHS_C::number(18 , 2)          as msec_commissions_last_12_months_c
    , json:HOUSEHOLD_TYPE_C::varchar(3900)                            as household_type_c
    , json:TAX_STATUS_C::varchar(3900)                                as tax_status_c
    , json:BC_BILLABLE_VALUE_C::number(18 , 2)                        as bc_billable_value_c
    , json:COLLECTION_WEEK_C::double                                  as collection_week_c
    , json:BRANCH_C::varchar(3900)                                    as branch_c
    , json:MAXIMUM_LEVEL_ALLOWED_C::number(18 , 2)                    as maximum_level_allowed_c
    , json:AVG_ANNUAL_NET_FEE_RATE_C::double                          as avg_annual_net_fee_rate_c
    , json:EMAIL_TO_C::varchar(3900)                                  as email_to_c
    , json:FILE_AS_C::varchar(3900)                                   as file_as_c
    , json:BILLING_ACCOUNT_APPROVED_HOUSEHOLD_ID_DEL_C::varchar(3900) as billing_account_approved_household_id_del_c
    , json:COLLECTION_QUARTER_C::varchar(3900)                        as collection_quarter_c
    , json:DAYS_IN_INVOICE_QTR_C::double                              as days_in_invoice_qtr_c
    , json:PAYMENT_METHOD_FEE_C::number(18 , 2)                       as payment_method_fee_c
    , json:_FIVETRAN_DELETED::boolean                                 as _fivetran_deleted

    , effective_at::timestamp                                         as effective_at
    , _created_at::timestamp                                          as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'invoice_review_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                               as is_latest
from {{ source('salesforce_compass', 'invoice_review_c') }}
