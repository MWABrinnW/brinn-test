{% set src = source('sugarcrm_woodbridge', 'opportunity') %}

select
    json:"ACCOUNT_ID"::text                                                   as account_id
    , json:"AMOUNT"::int                                                      as amount
    , json:"AMOUNT_USDOLLAR"::int                                             as amount_us_dollar
    , json:"ASSIGNED_USER_ID"::text                                           as assigned_user_id
    , json:"ASSIGNED_USER_NAME"::text                                         as assigned_username
    , json:"BASE_RATE"::int                                                   as base_rate
    , json:"BEST_CASE"::int                                                   as best_case
    , json:"CLOSED_REVENUE_LINE_ITEMS"::int                                   as closed_revenue_line_items
    , json:"CLOSED_WON_REVENUE_LINE_ITEMS"::int                               as closed_won_revenue_line_items
    , json:"COMMIT_STAGE"::text                                               as commit_stage
    , json:"CREATED_BY_ID"::text                                              as created_by_id
    , json:"CREATED_BY_NAME"::text                                            as created_by_name
    , json:"CURRENCY_ID"::text                                                as currency_id
    , json:"CURRENCY_NAME"::text                                              as currency_name
    , json:"CURRENCY_SYMBOL"::text                                            as currency_symbol
    , json:"CUSTOM_ACCOUNT_NAME"::text                                        as custom_account_name
    , json:"CUSTOM_ACTUAL_REFERRAL_FEES_C"::int                               as custom_actual_referral_fees_c
    , json:"CUSTOM_AGE_C"::int                                                as custom_age_c
    , json:"CUSTOM_AMOUNT_C"::int                                             as custom_amount_c
    , json:"CUSTOM_BD_TARGET_OPPORTUNITIESBD_TARGET_IDA"::text                as custom_bd_target_opportunities_bd_target_ida
    , json:"CUSTOM_BD_TARGET_OPPORTUNITIES_NAME"::text                        as custom_bd_target_opportunities_name
    , json:"CUSTOM_BEST_EFFORTS_C"::text                                      as custom_best_efforts_c
    , json:"CUSTOM_BILLING_STATE_C"::text                                     as custom_billing_state_c
    , json:"CUSTOM_CARVE_OUTS_DROPDOWN_C"::text                               as custom_carve_outs_drop_down_c
    , try_to_boolean(
        json:"CUSTOM_CARVE_OUTS_SEE_CLIENT_AGREEMENT_C"::text
    )::int                                                                    as custom_carve_out_s_see_client_agreement_c
    , json:"CUSTOM_CHANGE_TTM_EBITDA_C"::int                                  as custom_change_ttm_ebitda_c
    , json:"CUSTOM_CLOSING_FEE_FORMULA_C"::text                               as custom_closing_fee_formula_c
    , json:"CUSTOM_CONTACTS_OPPORTUNITIES_C_1_CONTACTS_IDA"::text             as custom_contacts_opportunities_c1_contacts_ida
    , json:"CUSTOM_CONTACTS_OPPORTUNITIES_C_1_NAME"::text                     as custom_contacts_opportunities_c1_name
    , json:"CUSTOM_CONTACT_ID_C"::text                                        as custom_contact_id_c
    , try_to_boolean(
        json:"CUSTOM_CONTRACT_DATA_COMPLETE_C"::text
    )::int                                                                    as custom_contract_data_complete_c
    , json:"CUSTOM_CONTRACT_EXPIRE_C"::date                                   as custom_contract_expire_c
    , json:"CUSTOM_CONTRACT_TERMINATION_DATE_C"::date                         as custom_contract_termination_date_c
    , json:"CUSTOM_CONTRACT_TYPE_C"::text                                     as custom_contract_type_c
    , json:"CUSTOM_CONTRIBUTORS_C"::variant                                   as custom_contributors_c
    , json:"CUSTOM_COUNTRY_C"::text                                           as custom_country_c
    , json:"CUSTOM_CURRENT_FORECAST_EBITDA_C"::int                            as custom_current_forecast_ebitda_c
    , json:"CUSTOM_CURRENT_FORECAST_REVENUE_C"::int                           as custom_current_forecast_revenue_c
    , json:"CUSTOM_DATE_MARINER_QUALIFIED_C"::date                            as custom_date_mariner_qualified_c
    , json:"CUSTOM_ENGAGEMENT_FEE_1_C"::int                                   as custom_engagement_fee_1_c
    , json:"CUSTOM_EXPECTED_FEE_C"::int                                       as custom_expected_fee_c
    , json:"CUSTOM_EXPECTED_REFERRAL_FEES_C"::int                             as custom_expected_referral_fees_c
    , json:"CUSTOM_FISCALQUARTER_C"::int                                      as custom_fiscal_quarter_c
    , json:"CUSTOM_FISCALYEAR_C"::int                                         as custom_fiscal_year_c
    , json:"CUSTOM_FISCAL_C"::text                                            as custom_fiscal_c
    , json:"CUSTOM_FORECASTCATEGORYNAME_C"::text                              as custom_forecast_category_name_c
    , json:"CUSTOM_FORECASTCATEGORY_C"::text                                  as custom_forecast_category_c
    , json:"CUSTOM_GUIDE_TO_MARK_AS_CLIENT_C"::text                           as custom_guide_to_mark_as_client_c
    , try_to_boolean(
        json:"CUSTOM_HASOPENACTIVITY_C"::text
    )::int                                                                    as custom_has_open_activity_c
    , try_to_boolean(json:"CUSTOM_HASOVERDUETASK_C"::text)::int               as custom_has_overdue_task_c
    , try_to_boolean(
        json:"CUSTOM_INCLUDES_ALL_KNOWN_ADDBACKS_C"::text
    )::int                                                                    as custom_includes_all_known_add_backs_c
    , json:"CUSTOM_INDEMNIFICATION_C"::text                                   as custom_indemnification_c
    , json:"CUSTOM_INDEMNIFICATION_WI_WGS_C"::text                            as custom_indemnification_wi_wgs_c
    , try_to_boolean(
        json:"CUSTOM_INITIAL_PAYMENT_MADE_C"::text
    )::int                                                                    as custom_initial_payment_made_c
    , json:"CUSTOM_LASTACTIVITYDATE_C"::date                                  as custom_last_activity_date_c
    , json:"CUSTOM_LASTSTAGECHANGEDATE_C"::text                               as custom_last_stage_change_date_c
    , json:"CUSTOM_LY_TTM_EBITDA_C"::int                                      as custom_ly_ttm_ebitda_c
    , json:"CUSTOM_LY_T_3_M_EBITDA_C"::int                                    as custom_ly_t3m_ebitda_c
    , json:"CUSTOM_MARINER_CHANNEL_C"::text                                   as custom_mariner_channel_c
    , json:"CUSTOM_MARINER_SOURCE_C"::text                                    as custom_mariner_source_c
    , json:"CUSTOM_MINIMUM_VALUE_EXPECTATIONS_C"::int                         as custom_minimum_value_expectations_c
    , json:"CUSTOM_MONTH_10_C"::int                                           as custom_month_10_c
    , json:"CUSTOM_MONTH_11_C"::int                                           as custom_month_11_c
    , json:"CUSTOM_MONTH_12_C"::int                                           as custom_month_12_c
    , json:"CUSTOM_MONTH_13_C"::int                                           as custom_month_13_c
    , json:"CUSTOM_MONTH_14_C"::int                                           as custom_month_14_c
    , json:"CUSTOM_MONTH_15_C"::int                                           as custom_month_15_c
    , json:"CUSTOM_MONTH_1_MOST_RECENT_C"::int                                as custom_month_1_most_recent_c
    , json:"CUSTOM_MONTH_2_C"::int                                            as custom_month_2_c
    , json:"CUSTOM_MONTH_3_C"::int                                            as custom_month_3_c
    , json:"CUSTOM_MONTH_4_C"::int                                            as custom_month_4_c
    , json:"CUSTOM_MONTH_5_C"::int                                            as custom_month_5_c
    , json:"CUSTOM_MONTH_6_C"::int                                            as custom_month_6_c
    , json:"CUSTOM_MONTH_7_C"::int                                            as custom_month_7_c
    , json:"CUSTOM_MONTH_8_C"::int                                            as custom_month_8_c
    , json:"CUSTOM_MONTH_9_C"::int                                            as custom_month_9_c
    , json:"CUSTOM_MWA_REFERRAL_TYPE_C"::variant                              as custom_mwa_referral_type_c
    , try_to_boolean(json:"CUSTOM_MY_FAVORITE"::text)::int                    as custom_my_favorite
    , json:"CUSTOM_NEED_LEGAL_PITCH_C"::text                                  as custom_need_legal_pitch_c
    , json:"CUSTOM_NEED_WEALTH_MGMT_PITCH_C"::text                            as custom_need_wealth_mgmt_pitch_c
    , json:"CUSTOM_NEXT_STEP_DATE_C"::date                                    as custom_next_step_date_c
    , json:"CUSTOM_OF_OWNERS_C"::text                                         as custom_of_owners_c
    , json:"CUSTOM_OWNERSHIP_NAMES_PERCENTAGES_C"::text                       as custom_ownership_names_percentages_c
    , json:"CUSTOM_OWNERSHIP_TYPE_C"::text                                    as custom_ownership_type_c
    , try_to_boolean(json:"CUSTOM_PAID_IN_FULL_C"::text)::int                 as custom_paid_in_full_c
    , json:"CUSTOM_PAYMENT_SCHEDULE_C"::text                                  as custom_payment_schedule_c
    , json:"CUSTOM_PERCENT_CHANGE_TTM_EBITDA_C"::int                          as custom_percent_change_ttm_ebitda_c
    , json:"CUSTOM_PERCENT_CHANGE_T_3_M_EBITDA_C"::float                      as custom_percent_change_t3m_ebitda_c
    , json:"CUSTOM_PITCHBOOK_ASSIGNED_TO_C"::text                             as custom_pitch_book_assigned_to_c
    , json:"CUSTOM_PITCHBOOK_COMPLETED_DATE_C"::date                          as custom_pitch_book_completed_date_c
    , json:"CUSTOM_POTENTIAL_LIQUIDITY_OPPS_C"::int                           as custom_potential_liquidity_opps_c
    , json:"CUSTOM_PROBABILITY_1_C"::int                                      as custom_probability_1c
    , json:"CUSTOM_PROJECT_BASED_C"::text                                     as custom_project_based_c
    , json:"CUSTOM_PUSHCOUNT_C"::int                                          as custom_push_count_c
    , json:"CUSTOM_REASON_LOST_C"::text                                       as custom_reason_lost_c
    , json:"CUSTOM_REASON_UNSIGNED_C"::text                                   as custom_reason_unsigned_c
    , json:"CUSTOM_REFERRAL_FEE_PERCENTAGE_C"::int                            as custom_referral_fee_percentage_c
    , json:"CUSTOM_REFERRED_TO_MWA_OPPS_C"::text                              as custom_referred_to_mwa_opps_c
    , json:"CUSTOM_REPORT_CREATE_DATE_C"::date                                as custom_report_create_date_c
    , json:"CUSTOM_REPORT_EXPECTED_CLOSE_DATE_C"::date                        as custom_report_expected_close_date_c
    , json:"CUSTOM_REQUESTS_CONCERNS_C"::variant                              as custom_requests_concerns_c
    , json:"CUSTOM_REQUESTS_CONCERNS_INFO_C"::text                            as custom_requests_concerns_info_c
    , json:"CUSTOM_SCRM_CAMPAIGNS_OPPORTUNITIES_1_NAME"::text                 as custom_scrm_campaigns_opportunities_1_name
    , json:"CUSTOM_SCRM_CAMPAIGNS_OPPORTUNITIES_1_SCRM_CAMPAIGNS_IDA"::text
        as custom_scrm_campaigns_opportunities_1_scrm_campaigns_ida
    , json:"CUSTOM_SCRM_CAMPAIGNS_OPPORTUNITIES_C_1_NAME"::text               as custom_scrm_campaigns_opportunities_c1_name
    , json:"CUSTOM_SCRM_CAMPAIGNS_OPPORTUNITIES_C_1_SCRM_CAMPAIGNS_IDA"::text
        as custom_scrm_campaigns_opportunities_c1_scrm_campaigns_ida
    , json:"CUSTOM_SF_AMOUNT_C"::int                                          as custom_sf_amount_c
    , json:"CUSTOM_SF_CLOSE_DATE_C"::date                                     as custom_sf_close_date_c
    , json:"CUSTOM_SF_CREATED_AT_C"::text                                     as custom_sf_created_at_c
    , json:"CUSTOM_SF_CREATED_BY_C"::text                                     as custom_sf_created_by_c
    , json:"CUSTOM_SF_LAST_MODIFIED_AT_C"::text                               as custom_sf_last_modified_at_c
    , json:"CUSTOM_SF_LAST_MODIFIED_BY_C"::text                               as custom_sf_last_modified_by_c
    , json:"CUSTOM_SF_OBJECT_TYPE_C"::text                                    as custom_sf_object_type_c
    , json:"CUSTOM_SF_STAGE_NAME_C"::text                                     as custom_sf_stage_name_c
    , json:"CUSTOM_STATED_EBITDA_C"::int                                      as custom_stated_ebitda_c
    , json:"CUSTOM_STATED_REVENUE_C"::int                                     as custom_stated_revenue_c
    , json:"CUSTOM_TAIL_1_C"::int                                             as custom_tail_1_c
    , json:"CUSTOM_TERM_C"::text                                              as custom_term_c
    , json:"CUSTOM_TOUCH_POINT_C"::text                                       as custom_touchpoint_c
    , json:"CUSTOM_TTM_CHECK_C"::text                                         as custom_ttm_check_c
    , json:"CUSTOM_TTM_CHECK_EXP_CLOSE_DATE_C"::text                          as custom_ttm_check_exp_close_date_c
    , json:"CUSTOM_TTM_CHECK_WEBINAR_DATE_C"::text                            as custom_ttm_check_webinar_date_c
    , json:"CUSTOM_TTM_EBITDA_C"::int                                         as custom_ttm_ebitda_c
    , json:"CUSTOM_TTM_REVENUE_C"::int                                        as custom_ttm_revenue_c
    , json:"CUSTOM_TTM_YTD_UPDATED_THROUGH_C"::date                           as custom_ttm_ytd_updated_through_c
    , json:"CUSTOM_T_3_M_EBITDA_C"::int                                       as custom_t3m_ebitda_c
    , json:"CUSTOM_UCF_LAST_PROCESSED_DATE_C"::text                           as custom_ucf_last_processed_date_c
    , json:"CUSTOM_USER_ID_C"::text                                           as custom_userid_c
    , try_to_boolean(json:"CUSTOM_VALUATION_C"::text)::int                    as custom_valuation_c
    , json:"CUSTOM_VALUATION_FEE_C"::int                                      as custom_valuation_fee_c
    , json:"CUSTOM_VALUE_EXPECTATION_EXPLANATION_C"::text                     as custom_value_expectation_explanation_c
    , try_to_boolean(json:"CUSTOM_WEBINAR_COMPLETED_C"::text)::int            as custom_webinar_completed_c
    , json:"CUSTOM_WEBINAR_DATE_C"::date                                      as custom_webinar_date_c
    , json:"CUSTOM_WEBINAR_DATE_COPY_FOR_DB_C"::date                          as custom_webinar_date_copy_for_db_c
    , try_to_boolean(json:"CUSTOM_WG_SECURITIES_C"::text)::int                as custom_wg_securities_c
    , try_to_boolean(json:"CUSTOM_WRITE_OFF_C"::text)::int                    as custom_write_off_c
    , json:"CUSTOM_YTD_EBITDA_C"::int                                         as custom_ytd_ebitda_c
    , json:"DATE_CLOSED"::date                                                as date_closed
    , json:"DATE_CLOSED_TIMESTAMP"::int                                       as date_closed_timestamp
    , json:"DATE_ENTERED"::text                                               as date_entered
    , json:"DATE_MODIFIED"::text                                              as date_modified
    , try_to_boolean(json:"DELETED"::text)::int                               as deleted
    , json:"DENORM_ACCOUNT_NAME"::text                                        as de_norm_account_name
    , json:"DESCRIPTION"::text                                                as description
    , try_to_boolean(json:"FOLLOWING"::text)::int                             as is_following
    , json:"FORECASTED_LIKELY"::int                                           as forecasted_likely
    , json:"GEOCODE_STATUS"::text                                             as geocode_status
    , json:"ID"::text                                                         as id
    , json:"INCLUDED_REVENUE_LINE_ITEMS"::int                                 as included_revenue_line_items
    , try_to_boolean(json:"IS_ESCALATED"::text)::int                          as is_escalated
    , json:"LEAD_SOURCE"::text                                                as lead_source
    , json:"LOCKED_FIELDS"::variant                                           as locked_fields
    , json:"LOST"::int                                                        as lost
    , try_to_boolean(json:"MKTO_SYNC"::text)::int                             as mkto_sync
    , json:"MODIFIED_BY_NAME"::text                                           as modified_by_name
    , json:"MODIFIED_USER_ID"::text                                           as modified_userid
    , json:"NAME"::text                                                       as name
    , json:"NEXT_STEP"::text                                                  as next_step
    , json:"OPPORTUNITY_TYPE"::text                                           as opportunity_type
    , try_to_boolean(json:"PERFORM_SUGAR_ACTION"::text)::int                  as perform_sugar_action
    , json:"PROBABILITY"::int                                                 as probability
    , try_to_boolean(json:"RENEWAL"::text)::int                               as renewal
    , json:"SALES_STAGE"::text                                                as sales_stage
    , json:"SALES_STATUS"::text                                               as sales_status
    , json:"SERVICE_OPEN_FLEX_DURATION_RLIS"::int                             as service_open_flex_duration_rlis
    , json:"SERVICE_OPEN_REVENUE_LINE_ITEMS"::int                             as service_open_revenue_line_items
    , json:"SYNC_KEY"::text                                                   as sync_key
    , json:"TAGS"::variant                                                    as tags
    , json:"TOTAL_REVENUE_LINE_ITEMS"::int                                    as total_revenue_line_items
    , json:"WORST_CASE"::int                                                  as worst_case
    , try_to_boolean(json:"_FIVETRAN_DELETED"::text)::int                     as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text                                           as fivetran_synced
    , json:"_hash"::text                                                      as hash
    , try_to_boolean(json:"create"::text)::int                                as is_create
    , json:"fields"::variant                                                  as fields
    , try_to_boolean(json:"license"::text)::int                               as license
    , try_to_boolean(json:"write"::text)::int                                 as write
    , json:"None"::text                                                       as none_col

    , effective_at::timestamp                                                 as effective_at
    , _created_at::timestamp                                                  as _created_at
    , {{ col_is_head(reference=src
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ src }}
