select
    'salesforce'::text(200)                                                       as system_name
    , 'corbenic'::text(200)                                                       as system_instance
    , concat(system_name , '__' , system_instance)::text(200)                     as system_key
    , 'mwa'::text(200)                                                            as firm_source
    , a.json:ID::varchar(18)                                                      as id
    , a.json:IS_DELETED::boolean                                                  as is_deleted
    , a.json:MASTER_RECORD_ID::varchar(18)                                        as master_record_id
    , a.json:NAME::varchar(765)                                                   as name
    , a.json:TYPE::varchar(765)                                                   as type
    , a.json:RECORD_TYPE_ID::varchar(18)                                          as record_type_id
    , a.json:PARENT_ID::varchar(18)                                               as parent_id
    , a.json:BILLING_STREET::varchar(765)                                         as billing_street
    , a.json:BILLING_CITY::varchar(120)                                           as billing_city
    , a.json:BILLING_STATE::varchar(240)                                          as billing_state
    , a.json:BILLING_POSTAL_CODE::varchar(60)                                     as billing_postal_code
    , a.json:BILLING_COUNTRY::varchar(240)                                        as billing_country
    , a.json:BILLING_LATITUDE::double                                             as billing_latitude
    , a.json:BILLING_LONGITUDE::double                                            as billing_longitude
    , a.json:BILLING_GEOCODE_ACCURACY::varchar(120)                               as billing_geocode_accuracy
    , a.json:SHIPPING_STREET::varchar(765)                                        as shipping_street
    , a.json:SHIPPING_CITY::varchar(120)                                          as shipping_city
    , a.json:SHIPPING_STATE::varchar(240)                                         as shipping_state
    , a.json:SHIPPING_POSTAL_CODE::varchar(60)                                    as shipping_postal_code
    , a.json:SHIPPING_COUNTRY::varchar(240)                                       as shipping_country
    , a.json:SHIPPING_LATITUDE::double                                            as shipping_latitude
    , a.json:SHIPPING_LONGITUDE::double                                           as shipping_longitude
    , a.json:SHIPPING_GEOCODE_ACCURACY::varchar(120)                              as shipping_geocode_accuracy
    , a.json:PHONE::varchar(120)                                                  as phone
    , a.json:ACCOUNT_NUMBER::varchar(120)                                         as account_number_formatted
    , upper(ltrim(replace(a.json:ACCOUNT_NUMBER::varchar(120) , '-' , '') , '0')) as account_number
    , a.json:WEBSITE::varchar(765)                                                as website
    , a.json:PHOTO_URL::varchar(765)                                              as photo_url
    , a.json:INDUSTRY::varchar(765)                                               as industry
    , a.json:ANNUAL_REVENUE::number(18)                                           as annual_revenue
    , a.json:NUMBER_OF_EMPLOYEES::number                                          as number_of_employees
    , a.json:DESCRIPTION::varchar(96000)                                          as description
    , a.json:RATING::varchar(765)                                                 as rating
    , a.json:SITE::varchar(240)                                                   as site
    , a.json:OWNER_ID::varchar(18)                                                as owner_id
    , a.json:CREATED_DATE::timestamptz                                            as created_date
    , a.json:CREATED_BY_ID::varchar(18)                                           as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                                      as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                                     as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                                         as system_modstamp
    , a.json:LAST_ACTIVITY_DATE::date                                             as last_activity_date
    , a.json:LAST_VIEWED_DATE::timestamptz                                        as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                                    as last_referenced_date
    , a.json:JIGSAW_COMPANY_ID::varchar(60)                                       as jigsaw_company_id
    , a.json:ACCOUNT_SOURCE::varchar(765)                                         as account_source
    , a.json:ANNUAL_HOUSEHOLD_INCOME_C::number(18)                                as annual_household_income_c
    , a.json:CLASSIFICATION_C::varchar(765)                                       as classification_c
    , a.json:CLIENT_CATEGORY_C::varchar(765)                                      as client_category_c
    , a.json:CLIENT_OPERATIONAL_TAGS_C::varchar(4099)                             as client_operational_tags_c
    , a.json:FILE_AS_C::varchar(360)                                              as file_as_c
    , a.json:INFORMAL_SALUTATION_C::varchar(240)                                  as informal_salutation_c
    , a.json:KEY_TAGS_C::varchar(4099)                                            as key_tags_c
    , a.json:LAST_CLIENT_MEETING_C::date                                          as last_client_meeting_c
    , a.json:MTG_MEETING_FREQUENCY_C::varchar(765)                                as mtg_meeting_frequency_c
    , a.json:MTG_SCHEDULED_NEXT_MEETING_DATE_C::timestamptz                       as mtg_scheduled_next_meeting_date_c
    , a.json:MAILING_STREET_ADDRESS_3_C::varchar(240)                             as mailing_street_address_3_c
    , a.json:MAILING_CITY_C::varchar(150)                                         as mailing_city_c
    , a.json:MAILING_LABEL_NAME_C::varchar(300)                                   as mailing_label_name_c
    , a.json:MAILING_POSTAL_CODE_C::varchar(30)                                   as mailing_postal_code_c
    , a.json:MAILING_STATE_C::varchar(6)                                          as mailing_state_c
    , a.json:MAILING_STREET_ADDRESS_2_C::varchar(240)                             as mailing_street_address_2_c
    , a.json:MAILING_STREET_ADDRESS_C::varchar(240)                               as mailing_street_address_c
    , a.json:NET_DOCS_SECURITY_TEMPLATE_C::varchar(18)                            as net_docs_security_template_c
    , a.json:ORIGINAL_OPPORTUNITY_C::varchar(18)                                  as original_opportunity_c
    , a.json:ORION_HOUSE_ID_C::varchar(90)                                        as orion_house_id_c
    , a.json:OTHER_CITY_C::varchar(150)                                           as other_city_c
    , a.json:OTHER_POSTAL_CODE_C::varchar(30)                                     as other_postal_code_c
    , a.json:OTHER_STATE_C::varchar(6)                                            as other_state_c
    , a.json:OTHER_STREET_ADDRESS_2_C::varchar(150)                               as other_street_address_2_c
    , a.json:OTHER_STREET_ADDRESS_C::varchar(150)                                 as other_street_address_c
    , a.json:REFERRAL_PARTNER_DEL_C::boolean                                      as referral_partner_del_c
    , a.json:RELATIONSHIP_LEVEL_C::varchar(765)                                   as relationship_level_c
    , a.json:RISK_OBJECTIVE_C::varchar(765)                                       as risk_objective_c
    , a.json:SALUTATION_ORION_C::varchar(150)                                     as salutation_orion_c
    , a.json:SHORT_NAME_C::varchar(150)                                           as short_name_c
    , a.json:SPECIAL_REPORTING_C::varchar(765)                                    as special_reporting_c
    , a.json:TAX_BRACKET_C::double                                                as tax_bracket_c
    , a.json:TEMPORARY_INTRODUCER_2_PAYOUT_RATE_O_DEL_C::double                   as temporary_introducer_2_payout_rate_o_del_c
    , a.json:TRANSFERRED_FROM_C::varchar(765)                                     as transferred_from_c
    , a.json:UNIQUE_IDENTIFIER_C::varchar(90)                                     as unique_identifier_c
    , a.json:BRANCH_C::varchar(765)                                               as branch_c
    , a.json:HOLDING_COMPANY_C::varchar(18)                                       as holding_company_c
    , a.json:BUSINESS_LINE_C::varchar(765)                                        as business_line_c
    , a.json:NET_WORTH_WITHOUT_RESIDENCE_C::number(18)                            as net_worth_without_residence_c
    , a.json:PARTNER_FIRM_C::varchar(18)                                          as partner_firm_c
    , a.json:NDWEALTH_CAB_GUID_C::varchar(150)                                    as ndwealth_cab_guid_c
    , a.json:LEAD_SOURCE_C::varchar(765)                                          as lead_source_c
    , a.json:LEGAL_FIRM_C::varchar(18)                                            as legal_firm_c
    , a.json:STATEMENT_MAILING_PREFERENCE_C::varchar(765)                         as statement_mailing_preference_c
    , a.json:PERF_10_YR_C::double                                                 as perf_10_yr_c
    , a.json:PERF_1_D_C::double                                                   as perf_1_d_c
    , a.json:PERF_1_YR_C::double                                                  as perf_1_yr_c
    , a.json:PERF_3_YR_C::double                                                  as perf_3_yr_c
    , a.json:PERF_5_YR_C::double                                                  as perf_5_yr_c
    , a.json:PERF_AS_OF_DATE_C::date                                              as perf_as_of_date_c
    , a.json:PERF_INCEPTION_C::double                                             as perf_inception_c
    , a.json:PERF_MTD_C::double                                                   as perf_mtd_c
    , a.json:PERF_QTD_C::double                                                   as perf_qtd_c
    , a.json:PERF_YTD_C::double                                                   as perf_ytd_c
    , a.json:RISK_TOLERANCE_C::varchar(765)                                       as risk_tolerance_c
    , a.json:APPROVED_BILLING_HOUSEHOLD_C::varchar(18)                            as approved_billing_household_c
    , a.json:TOTAL_ACCOUNT_CASH_BALANCE_C::number(18 , 2)                         as total_account_cash_balance_c
    , a.json:TOTAL_ACCOUNT_VALUE_C::number(18 , 2)                                as total_account_value_c
    , a.json:PRIVATE_ACCOUNT_C::boolean                                           as private_account_c
    , a.json:CLIENT_CURRENT_QTR_FEE_C::number(18 , 2)                             as client_current_qtr_fee_c
    , a.json:CLIENT_CURRENT_QTR_GROSS_FEE_C::number(18 , 2)                       as client_current_qtr_gross_fee_c
    , a.json:TOTAL_ASSETS_HELD_AWAY_C::number(18 , 2)                             as total_assets_held_away_c
    , a.json:TOTAL_INSURANCE_DEATH_BENEFIT_C::number(18 , 2)                      as total_insurance_death_benefit_c
    , a.json:CLIENT_AGREEMENT_VERSION_C::varchar(18)                              as client_agreement_version_c
    , a.json:TOTAL_MORTGAGE_C::number(18 , 2)                                     as total_mortgage_c
    , a.json:CHICAGO_CLEARING_NOTES_C::varchar(765)                               as chicago_clearing_notes_c
    , a.json:CHICAGO_CLEARING_STATUS_C::varchar(765)                              as chicago_clearing_status_c
    , a.json:CURRENT_INVOICE_LINK_C::varchar(600)                                 as current_invoice_link_c
    , a.json:E_DELIVERY_ADDRESS_C::varchar(240)                                   as e_delivery_address_c
    , a.json:E_DELIVERY_CONSENT_C::varchar(765)                                   as e_delivery_consent_c
    , a.json:E_DELIVERY_ADDRESS_2_C::varchar(240)                                 as e_delivery_address_2_c
    , a.json:E_DELIVERY_SALUTATION_C::varchar(240)                                as e_delivery_salutation_c
    , a.json:USE_MAILING_ADDRESS_FOR_STATEMENT_C::boolean                         as use_mailing_address_for_statement_c
    , a.json:EDELIVERY_SALUTATION_2_C::varchar(240)                               as edelivery_salutation_2_c
    , a.json:TEMPORARY_INTRODUCER_REASON_C::varchar(765)                          as temporary_introducer_reason_c
    , a.json:TEMPORARY_INTRODUCER_PAYOUT_RATE_OR_C::double                        as temporary_introducer_payout_rate_or_c
    , a.json:TEMPORARY_INTRODUCER_CONVERSION_DATE_C::date                         as temporary_introducer_conversion_date_c
    , a.json:HOUSEHOLD_STRATEGY_C::varchar(90)                                    as household_strategy_c
    , a.json:RISK_TOLERANCE_ON_FILE_C::boolean                                    as risk_tolerance_on_file_c
    , a.json:RISK_TOLERANCE_PRE_2011_ON_FILE_C::varchar(765)                      as risk_tolerance_pre_2011_on_file_c
    , a.json:IMA_VERSION_C::varchar(765)                                          as ima_version_c
    , a.json:NAMES_OF_PUBLICALLY_TRADED_COMPANIES_C::varchar(765)                 as names_of_publically_traded_companies_c
    , a.json:MRA_LOCATION_C::varchar(765)                                         as mra_location_c
    , a.json:MAILING_LABEL_ORION_C::varchar(150)                                  as mailing_label_orion_c
    , a.json:LEGAL_FIRM_NOTES_C::varchar(300)                                     as legal_firm_notes_c
    , a.json:UNIQUE_ID_TEXT_C::varchar(90)                                        as unique_id_text_c
    , a.json:ACCOUNT_OPENED_C::date                                               as account_opened_c
    , a.json:CLIENT_PREVIOUS_QTR_FEE_C::number(18 , 2)                            as client_previous_qtr_fee_c
    , a.json:MRA_TYPE_C::varchar(765)                                             as mra_type_c
    , a.json:CLIENT_AGREEMENT_PROCESSED_DATE_C::date                              as client_agreement_processed_date_c
    , a.json:BO_QUARTERLY_REPORT_VERSION_ASSIGNED_C::varchar(765)                 as bo_quarterly_report_version_assigned_c
    , a.json:RISK_TOLERANCE_PROCESSED_DATE_C::date                                as risk_tolerance_processed_date_c
    , a.json:SOLICITOR_DISCLOSURE_PROCESSED_DATE_C::date                          as solicitor_disclosure_processed_date_c
    , a.json:OFAC_CONFIRMED_DATE_C::date                                          as ofac_confirmed_date_c
    , a.json:CHICAGO_CLEARING_NOTIFICATION_METHOD_C::varchar(765)                 as chicago_clearing_notification_method_c
    , a.json:CLIENT_MANAGER_C::varchar(18)                                        as client_manager_c
    , a.json:LEGAL_ADDRESS_CITY_C::varchar(150)                                   as legal_address_city_c
    , a.json:AUTH_TO_DISCUSS_FINANCIALS_ON_FILLE_C::date                          as auth_to_discuss_financials_on_fille_c
    , a.json:LEGAL_ADDRESS_POSTAL_CODE_C::varchar(30)                             as legal_address_postal_code_c
    , a.json:LEGAL_ADDRESS_STATE_C::varchar(6)                                    as legal_address_state_c
    , a.json:LEGAL_STREET_ADDRESS_C::varchar(300)                                 as legal_street_address_c
    , a.json:LEAD_SOURCE_VERIFIED_C::varchar(765)                                 as lead_source_verified_c
    , a.json:TOTAL_INORGANIC_ASSETS_C::number(18 , 2)                             as total_inorganic_assets_c
    , a.json:SHARE_WITH_C::varchar(765)                                           as share_with_c
    , a.json:MARINER_LOCATION_C::varchar(18)                                      as mariner_location_c
    , a.json:MARINER_MARKET_C::varchar(150)                                       as mariner_market_c
    , a.json:MARINER_REGION_C::varchar(150)                                       as mariner_region_c
    , a.json:CLIENT_FORECAST_FEE_C::number(18 , 2)                                as client_forecast_fee_c
    , a.json:REFERRAL_FEE_OVERRIDE_RATE_C::double                                 as referral_fee_override_rate_c
    , a.json:SYS_BOX_FOLDER_ID_C::varchar(765)                                    as sys_box_folder_id_c
    , a.json:INSURANCE_MANAGER_C::varchar(18)                                     as insurance_manager_c
    , a.json:TAX_MANAGER_C::varchar(18)                                           as tax_manager_c
    , a.json:ANNUAL_ALLOCATED_SERVICE_FEES_C::number(18 , 2)                      as annual_allocated_service_fees_c
    , a.json:DDL_FIRM_ID_C::varchar(765)                                          as ddl_firm_id_c
    , a.json:SYS_MIGRATION_ID_C::varchar(765)                                     as sys_migration_id_c
    , a.json:SYS_MIGRATION_SOURCE_C::varchar(4099)                                as sys_migration_source_c
    , a.json:FEE_MANAGER_C::varchar(18)                                           as fee_manager_c
    , a.json:OVERALL_TARGET_EQUITY_ALLOCATION_C::varchar(765)                     as overall_target_equity_allocation_c
    , a.json:ACCOUNT_BONUS_OVERRIDE_RATE_QB_C::double                             as account_bonus_override_rate_qb_c
    , a.json:ACCOUNT_OVERRIDE_CHANGE_DATE_3_P_C::date                             as account_override_change_date_3_p_c
    , a.json:ACCOUNT_OVERRIDE_DATE_BD_C::date                                     as account_override_date_bd_c
    , a.json:ACCOUNT_OVERRIDE_NEW_RATE_3_P_C::double                              as account_override_new_rate_3_p_c
    , a.json:ACCOUNT_OVERRIDE_NEW_RATE_BD_C::double                               as account_override_new_rate_bd_c
    , a.json:ACCOUNT_OVERRIDE_NOTES_3_P_C::varchar(765)                           as account_override_notes_3_p_c
    , a.json:ACCOUNT_OVERRIDE_NOTES_BD_C::varchar(765)                            as account_override_notes_bd_c
    , a.json:ACCOUNT_OVERRIDE_NOTES_QB_C::varchar(765)                            as account_override_notes_qb_c
    , a.json:ACCOUNT_OVERRIDE_ONGOING_RATE_3_P_C::double                          as account_override_ongoing_rate_3_p_c
    , a.json:ACCOUNT_OVERRIDE_ONGOING_RATE_BD_C::double                           as account_override_ongoing_rate_bd_c
    , a.json:ACCOUNT_OVERRIDE_RATE_QB_C::double                                   as account_override_rate_qb_c
    , a.json:EMPLOYEE_REFERRAL_SPLIT_C::double                                    as employee_referral_split_c
    , a.json:MANAGER_SPLIT_2_C::double                                            as manager_split_2_c
    , a.json:MANAGER_SPLIT_C::double                                              as manager_split_c
    , a.json:OPPORTUNITY_SPLIT_2_C::double                                        as opportunity_split_2_c
    , a.json:OPPORTUNITY_SPLIT_3_C::double                                        as opportunity_split_3_c
    , a.json:OPPORTUNITY_SPLIT_C::double                                          as opportunity_split_c
    , a.json:PORTFOLIO_RISK_PROFILE_C::varchar(765)                               as portfolio_risk_profile_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                                        as _fivetran_synced
    , a.json:INORGANIC_ASSET_C::boolean                                           as inorganic_asset_c
    , a.json:MWAACQUISITION_C::varchar(18)                                        as mwaacquisition_c
    , a.json:BILL_PAY_ADDENDUM_EFFECTIVE_DATE_C::date                             as bill_pay_addendum_effective_date_c
    , a.json:EXHIBIT_E_1_EFFECTIVE_DATE_C::date                                   as exhibit_e_1_effective_date_c
    , a.json:TAX_PAYMENT_AUTHORIZATION_FORM_EFFECTIVE_C::date                     as tax_payment_authorization_form_effective_c
    , a.json:TAX_PAYMENT_AUTH_FORM_EFFECTIVE_DATE_C::date                         as tax_payment_auth_form_effective_date_c
    , a.json:DATE_OF_ANNUAL_REVIEW_C::date                                        as date_of_annual_review_c
    , a.json:R_INVOICE_ON_QUARTERLY_REPORT_C::boolean                             as r_invoice_on_quarterly_report_c
    , a.json:RISK_TOLERANCE_STATUS_IMAGE_C::varchar(3900)                         as risk_tolerance_status_image_c
    , a.json:RISK_TOLERANCE_STATUS_C::varchar(3900)                               as risk_tolerance_status_c
    , a.json:ANNUAL_REVIEW_STATUS_IMAGE_C::varchar(3900)                          as annual_review_status_image_c
    , a.json:CLIENT_ID_18_C::varchar(3900)                                        as client_id_18_c
    , a.json:TOTAL_INVESTABLE_ASSETS_C::number(18 , 2)                            as total_investable_assets_c
    , a.json:CLOSE_DATE_C::date                                                   as close_date_c
    , a.json:REFERRAL_PARTNER_CATEGORY_C::varchar(3900)                           as referral_partner_category_c
    , a.json:ANNUAL_REVIEW_AGE_C::double                                          as annual_review_age_c
    , a.json:SYS_RISK_TOLERANCE_AGE_C::double                                     as sys_risk_tolerance_age_c
    , a.json:ANNUAL_REVIEW_STATUS_C::varchar(3900)                                as annual_review_status_c
    , a.json:REFERRAL_FEE_ESTIMATE_C::number(18 , 2)                              as referral_fee_estimate_c
    , a.json:MSECOPT_OUT_C::boolean                                               as msecopt_out_c
    , a.json:CLIENT_AGREEMENT_EFFECTIVE_DATE_C::date                              as client_agreement_effective_date_c
    , a.json:SOLICITOR_DISCLOSURE_EFFECTIVE_DATE_C::date                          as solicitor_disclosure_effective_date_c
    , a.json:ACCTS_MANAGED_BY_SUBADVISOR_EFF_DATE_C::date                         as accts_managed_by_subadvisor_eff_date_c
    , a.json:MH_RISK_TOLERANCE_C::varchar(18)                                     as mh_risk_tolerance_c
    , a.json:FAX::varchar(120)                                                    as fax
    , a.json:IMPORTANT_NOTES_C::varchar(96000)                                    as important_notes_c
    , a.json:SIC_DESC::varchar(240)                                               as sic_desc
    , a.json:BO_QUARTER_END_CLIENT_RECON_C::date                                  as bo_quarter_end_client_recon_c
    , a.json:SYS_CLIENT_MANAGER_CHANGE_TIME_C::timestamptz                        as sys_client_manager_change_time_c
    , a.json:PREVIOUS_CLIENT_MANAGER_C::varchar(18)                               as previous_client_manager_c
    , a.json:MARINER_SUPER_MARKET_C::varchar(150)                                 as mariner_super_market_c
    , a.json:_FIVETRAN_DELETED::boolean                                           as _fivetran_deleted

    , a.effective_at::timestamp                                                   as effective_at
    , a._created_at::timestamp                                                    as _created_at
    , {{ col_is_head(reference=source('salesforce_corbenic', 'account') , 
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
from {{ source('salesforce_corbenic', 'account') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn
    from {{ source('salesforce_corbenic', 'account') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
