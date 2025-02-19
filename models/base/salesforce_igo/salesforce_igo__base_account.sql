select
    json:ID :: text                                                as id
  , json:IS_DELETED :: boolean                                     as is_deleted
  , json:MASTER_RECORD_ID :: text                                  as master_record_id
  , json:NAME :: text                                              as name
  , json:LAST_NAME :: text                                         as last_name
  , json:FIRST_NAME :: text                                        as first_name
  , json:SALUTATION :: text                                        as salutation
  , json:RECORD_TYPE_ID :: text                                    as record_type_id
  , json:PHOTO_URL :: text                                         as photo_url
  , json:OWNER_ID :: text                                          as owner_id
  , json:CREATED_DATE :: timestamp_tz                              as created_date
  , json:CREATED_BY_ID :: text                                     as created_by_id
  , json:LAST_MODIFIED_DATE :: timestamp_tz                        as last_modified_date
  , json:LAST_MODIFIED_BY_ID :: text                               as last_modified_by_id
  , json:SYSTEM_MODSTAMP :: timestamp_tz                           as system_modstamp
  , json:LAST_ACTIVITY_DATE :: date                                as last_activity_date
  , json:LAST_VIEWED_DATE :: timestamp_tz                          as last_viewed_date
  , json:LAST_REFERENCED_DATE :: timestamp_tz                      as last_referenced_date
  , json:PERSON_CONTACT_ID :: text                                 as person_contact_id
  , json:IS_PERSON_ACCOUNT :: boolean                              as is_person_account
  , json:PERSON_LAST_CUREQUEST_DATE :: timestamp_tz                as person_last_curequest_date
  , json:PERSON_LAST_CUUPDATE_DATE :: timestamp_tz                 as person_last_cuupdate_date
  , json:PERSON_EMAIL_BOUNCED_REASON :: text                       as person_email_bounced_reason
  , json:PERSON_EMAIL_BOUNCED_DATE :: timestamp_tz                 as person_email_bounced_date
  , json:PERSON_INDIVIDUAL_ID :: text                              as person_individual_id
  , json:JIGSAW_COMPANY_ID :: text                                 as jigsaw_company_id
  , json:IS_PRIORITY_RECORD :: boolean                             as is_priority_record
  , json:PRACTIFI_AUM_C :: number(18 , 2)                          as practifi_aum_c
  , json:PRACTIFI_BATCH_C :: text                                  as practifi_batch_c
  , json:PRACTIFI_BECAME_CLIENT_ON_C :: date                       as practifi_became_client_on_c
  , json:PRACTIFI_BECAME_LOST_CLIENT_ON_C :: date                  as practifi_became_lost_client_on_c
  , json:PRACTIFI_BECAME_LOST_PROSPECT_ON_C :: date                as practifi_became_lost_prospect_on_c
  , json:PRACTIFI_BECAME_PROSPECT_ON_C :: date                     as practifi_became_prospect_on_c
  , json:PRACTIFI_CLIENT_SEGMENT_C :: text                         as practifi_client_segment_c
  , json:PRACTIFI_CLIENT_STAGE_ENTRY_DATE_C :: date                as practifi_client_stage_entry_date_c
  , json:PRACTIFI_CLIENT_STAGE_C :: text                           as practifi_client_stage_c
  , json:PRACTIFI_DEFINITIONS_C :: text                            as practifi_definitions_c
  , json:PRACTIFI_EMAIL_C :: text                                  as practifi_email_c
  , json:PRACTIFI_EXTERNAL_ID_C :: text                            as practifi_external_id_c
  , json:PRACTIFI_FORMAL_NAME_C :: text                            as practifi_formal_name_c
  , json:PRACTIFI_HOUSING_STATUS_C :: text                         as practifi_housing_status_c
  , json:PRACTIFI_INFLUENCER_SEGMENT_C :: text                     as practifi_influencer_segment_c
  , json:PRACTIFI_PARTNER_C :: text                                as practifi_partner_c
  , json:PRACTIFI_POTENTIAL_AUM_C :: number(18 , 2)                as practifi_potential_aum_c
  , json:PRACTIFI_PRIMARY_CONTACT_C :: text                        as practifi_primary_contact_c
  , json:PRACTIFI_PRIMARY_ENTITY_C :: text                         as practifi_primary_entity_c
  , json:PRACTIFI_RMD_DATE_C :: date                               as practifi_rmd_date_c
  , json:PRACTIFI_REFERRED_AUM_C :: number(18 , 2)                 as practifi_referred_aum_c
  , json:PRACTIFI_RELATED_DIVISION_C :: text                       as practifi_related_division_c
  , json:PRACTIFI_SERVICING_TEAM_C :: text                         as practifi_servicing_team_c
  , json:PRACTIFI_SHARING_SCOPE_C :: text                          as practifi_sharing_scope_c
  , json:PRACTIFI_SOURCE_C :: text                                 as practifi_source_c
  , json:PRACTIFI_TAX_NUMBER_RECORDED_C :: boolean                 as practifi_tax_number_recorded_c
  , json:PRACTIFI_TAX_NUMBER_C :: text                             as practifi_tax_number_c
  , json:PRACTIFI_TOPICS_C :: text                                 as practifi_topics_c
  , json:PRACTIFI_TRUST_TYPE_C :: text                             as practifi_trust_type_c
  , json:PRACTIFI_TRUSTEE_TYPE_C :: text                           as practifi_trustee_type_c
  , json:PRACTIFI_TYPE_C :: text                                   as practifi_type_c
  , json:PRACTIFI_VALUATION_C :: float                             as practifi_valuation_c
  , json:PRACTIFI_X_401_K_PROVIDER_C :: text                       as practifi_x_401_k_provider_c
  , json:PRACTIFI_REVENUE_C :: number(18 , 2)                      as practifi_revenue_c
  , json:PRACTIFI_DAYS_SINCE_LAST_CONTACT_RANGE_C :: text          as practifi_days_since_last_contact_range_c
  , json:PRACTIFI_LAST_CONTACT_DATE_C :: date                      as practifi_last_contact_date_c
  , json:PRACTIFI_LAST_EVENT_DATE_C :: date                        as practifi_last_event_date_c
  , json:PRACTIFI_PREFERRED_EMAIL_C :: text                        as practifi_preferred_email_c
  , json:PRACTIFI_PREFERRED_PHONE_C :: text                        as practifi_preferred_phone_c
  , json:PRACTIFI_ADDITIONAL_TRUSTEE_C :: text                     as practifi_additional_trustee_c
  , json:PRACTIFI_BENEFICIARY_C :: text                            as practifi_beneficiary_c
  , json:PRACTIFI_GRANTOR_C :: text                                as practifi_grantor_c
  , json:PRACTIFI_NEXT_EVENT_C :: timestamp_tz                     as practifi_next_event_c
  , json:PRACTIFI_ORGANIZATION_TYPE_C :: text                      as practifi_organization_type_c
  , json:PRACTIFI_PARTNER_TYPE_C :: text                           as practifi_partner_type_c
  , json:PRACTIFI_POTENTIAL_REVENUE_C :: number(18 , 2)            as practifi_potential_revenue_c
  , json:PRACTIFI_POWER_OF_ATTORNEY_C :: text                      as practifi_power_of_attorney_c
  , json:PRACTIFI_SUCCESSOR_TRUSTEE_C :: text                      as practifi_successor_trustee_c
  , json:PRACTIFI_TRUSTEE_C :: text                                as practifi_trustee_c
  , json:PRACTIFI_ENVESTNET_HANDLE_C :: text                       as practifi_envestnet_handle_c
  , json:PRACTIFI_LENDER_C :: boolean                              as practifi_lender_c
  , json:PRACTIFI_SET_AS_CREATED_DATE_C :: timestamp_tz            as practifi_set_as_created_date_c
  , json:PRACTIFI_LOSS_REASON_NOTIFICATION_C :: text               as practifi_loss_reason_notification_c
  , json:PRACTIFI_REASON_FOR_LOSS_C :: text                        as practifi_reason_for_loss_c
  , json:PRACTIFI_STATE_OF_RESIDENCE_C :: text                     as practifi_state_of_residence_c
  , json:PRACTIFI_TAX_ID_NUMBER_C :: text                          as practifi_tax_id_number_c
  , json:PRACTIFI_MISSING_INFORMATION_C :: text                    as practifi_missing_information_c
  , json:PRACTIFI_PRIMARY_MEMBER_C :: text                         as practifi_primary_member_c
  , json:PRACTIFI_SPOUSE_C :: text                                 as practifi_spouse_c
  , json:PRACTIFI_SPECIALTY_INVESTOR_STATUS_C :: text              as practifi_specialty_investor_status_c
  , json:PRACTIFI_DATE_OF_FIRST_CONTACT_C :: date                  as practifi_date_of_first_contact_c
  , json:PRACTIFI_DATE_OF_INCORPORATION_C :: date                  as practifi_date_of_incorporation_c
  , json:PRACTIFI_ENTITY_NUMBER_1_C :: text                        as practifi_entity_number_1_c
  , json:PRACTIFI_ENTITY_NUMBER_2_C :: text                        as practifi_entity_number_2_c
  , json:PRACTIFI_DEFER_AUTOMATION_C :: boolean                    as practifi_defer_automation_c
  , json:PRACTIFI_OTHER_DEFINITIONS_C :: text                      as practifi_other_definitions_c
  , json:PRACTIFI_ANNUAL_REVENUE_C :: number(18 , 2)               as practifi_annual_revenue_c
  , json:PRACTIFI_CONTRIBUTING_EMPLOYER_C :: boolean               as practifi_contributing_employer_c
  , json:PRACTIFI_DISPLAY_COUNTRY_C :: boolean                     as practifi_display_country_c
  , json:PRACTIFI_DISPLAY_EMPLOYER_AND_TITLE_C :: boolean          as practifi_display_employer_and_title_c
  , json:PRACTIFI_EMPLOYER_SEGMENT_C :: text                       as practifi_employer_segment_c
  , json:PRACTIFI_EMPLOYER_STAGE_C :: text                         as practifi_employer_stage_c
  , json:PRACTIFI_FIRST_CONTACT_DATE_C :: date                     as practifi_first_contact_date_c
  , json:PRACTIFI_FIRST_EVENT_DATE_C :: date                       as practifi_first_event_date_c
  , json:PRACTIFI_MAILING_LABEL_C :: text                          as practifi_mailing_label_c
  , json:PRACTIFI_MEMBER_STAGE_C :: text                           as practifi_member_stage_c
  , json:PRACTIFI_PARTICIPATING_FUND_C :: text                     as practifi_participating_fund_c
  , json:PRACTIFI_POTENTIAL_ANNUAL_REVENUE_C :: number(18 , 2)     as practifi_potential_annual_revenue_c
  , json:PRACTIFI_PRIMARY_ASSET_C :: text                          as practifi_primary_asset_c
  , json:PRACTIFI_PRIMARY_DEAL_C :: text                           as practifi_primary_deal_c
  , json:PRACTIFI_PRIMARY_SERVICE_C :: text                        as practifi_primary_service_c
  , json:PRACTIFI_REFERRER_C :: text                               as practifi_referrer_c
  , json:PRACTIFI_REPLACE_MAILING_NAME_WITH_C :: text              as practifi_replace_mailing_name_with_c
  , json:PRACTIFI_SYNC_LOCATION_ADDRESS_WITH_MEMBERS_C :: boolean  as practifi_sync_location_address_with_members_c
  , json:PRACTIFI_SYNC_POSTAL_ADDRESS_WITH_MEMBERS_C :: boolean    as practifi_sync_postal_address_with_members_c
  , json:PRACTIFI_AUM_RANGE_C :: text                              as practifi_aum_range_c
  , json:PRACTIFI_ACQUISITION_STAGE_ENTRY_DATE_C :: date           as practifi_acquisition_stage_entry_date_c
  , json:PRACTIFI_ACQUISITION_STAGE_C :: text                      as practifi_acquisition_stage_c
  , json:PRACTIFI_ACQUISITION_STATUS_C :: text                     as practifi_acquisition_status_c
  , json:PRACTIFI_AVERAGE_CLIENT_TENURE_C :: float                 as practifi_average_client_tenure_c
  , json:PRACTIFI_BECAME_CANDIDATE_ON_C :: date                    as practifi_became_candidate_on_c
  , json:PRACTIFI_BECAME_CONTENDER_ON_C :: date                    as practifi_became_contender_on_c
  , json:PRACTIFI_BECAME_PART_OF_FIRM_ON_C :: date                 as practifi_became_part_of_firm_on_c
  , json:PRACTIFI_BOOK_FIT_C :: float                              as practifi_book_fit_c
  , json:PRACTIFI_CRM_C :: text                                    as practifi_crm_c
  , json:PRACTIFI_CHARITABLE_ORG_AUM_C :: number(18 , 2)           as practifi_charitable_org_aum_c
  , json:PRACTIFI_CLIENT_FIT_C :: float                            as practifi_client_fit_c
  , json:PRACTIFI_CLIENTS_AVERAGE_AGE_C :: float                   as practifi_clients_average_age_c
  , json:PRACTIFI_CULTURE_FIT_C :: float                           as practifi_culture_fit_c
  , json:PRACTIFI_CUSTODIANS_C :: text                             as practifi_custodians_c
  , json:PRACTIFI_DAYS_IN_DUE_DILIGENCE_RANGE_C :: text            as practifi_days_in_due_diligence_range_c
  , json:PRACTIFI_DAYS_IN_ONBOARDING_RANGE_C :: text               as practifi_days_in_onboarding_range_c
  , json:PRACTIFI_DISCRETIONARY_AUM_C :: number(18 , 2)            as practifi_discretionary_aum_c
  , json:PRACTIFI_EBITDA_C :: number(18 , 2)                       as practifi_ebitda_c
  , json:PRACTIFI_ENTERED_DUE_DILIGENCE_ON_C :: date               as practifi_entered_due_diligence_on_c
  , json:PRACTIFI_ENTERED_ONBOARDING_ON_C :: date                  as practifi_entered_onboarding_on_c
  , json:PRACTIFI_ESTIMATED_REVENUE_C :: number(18 , 2)            as practifi_estimated_revenue_c
  , json:PRACTIFI_EXTERNAL_ID_1_C :: text                          as practifi_external_id_1_c
  , json:PRACTIFI_EXTERNAL_ID_2_C :: text                          as practifi_external_id_2_c
  , json:PRACTIFI_EXTERNAL_ID_3_C :: text                          as practifi_external_id_3_c
  , json:PRACTIFI_EXTERNAL_ID_4_C :: text                          as practifi_external_id_4_c
  , json:PRACTIFI_FEE_STANDARD_C :: text                           as practifi_fee_standard_c
  , json:PRACTIFI_FINANCIAL_PLANNING_C :: text                     as practifi_financial_planning_c
  , json:PRACTIFI_FOREIGN_AUM_C :: number(18 , 2)                  as practifi_foreign_aum_c
  , json:PRACTIFI_FOREIGN_CLIENTS_C :: float                       as practifi_foreign_clients_c
  , json:PRACTIFI_HIGH_NET_WORTH_AUM_C :: number(18 , 2)           as practifi_high_net_worth_aum_c
  , json:PRACTIFI_HIGH_NET_WORTH_CLIENTS_C :: float                as practifi_high_net_worth_clients_c
  , json:PRACTIFI_INVESTMENT_PHILOSOPHY_C :: float                 as practifi_investment_philosophy_c
  , json:PRACTIFI_NON_DISCRETIONARY_AUM_C :: number(18 , 2)        as practifi_non_discretionary_aum_c
  , json:PRACTIFI_NON_HIGH_NET_WORTH_AUM_C :: number(18 , 2)       as practifi_non_high_net_worth_aum_c
  , json:PRACTIFI_NON_HIGH_NET_WORTH_CLIENTS_C :: float            as practifi_non_high_net_worth_clients_c
  , json:PRACTIFI_NUMBER_OF_ADVISORS_C :: float                    as practifi_number_of_advisors_c
  , json:PRACTIFI_NUMBER_OF_CLIENTS_C :: float                     as practifi_number_of_clients_c
  , json:PRACTIFI_NUMBER_OF_EMPLOYEES_RANGE_C :: text              as practifi_number_of_employees_range_c
  , json:PRACTIFI_NUMBER_OF_OFFICES_C :: float                     as practifi_number_of_offices_c
  , json:PRACTIFI_NUMBER_OF_REFERRALS_PER_YEAR_C :: float          as practifi_number_of_referrals_per_year_c
  , json:PRACTIFI_NUMBER_OF_STAFF_C :: float                       as practifi_number_of_staff_c
  , json:PRACTIFI_OTHER_AUM_C :: number(18 , 2)                    as practifi_other_aum_c
  , json:PRACTIFI_PERFORMANCE_LAST_12_MONTHS_C :: float            as practifi_performance_last_12_months_c
  , json:PRACTIFI_PERFORMANCE_LAST_36_MONTHS_C :: float            as practifi_performance_last_36_months_c
  , json:PRACTIFI_PERFORMANCE_MTD_C :: float                       as practifi_performance_mtd_c
  , json:PRACTIFI_PERFORMANCE_QTD_C :: float                       as practifi_performance_qtd_c
  , json:PRACTIFI_PERFORMANCE_YTD_C :: float                       as practifi_performance_ytd_c
  , json:PRACTIFI_PORTFOLIO_MANAGER_C :: text                      as practifi_portfolio_manager_c
  , json:PRACTIFI_REALIZED_GAIN_LAST_YEAR_C :: number(18 , 2)      as practifi_realized_gain_last_year_c
  , json:PRACTIFI_REALIZED_GAIN_YTD_C :: number(18 , 2)            as practifi_realized_gain_ytd_c
  , json:PRACTIFI_REVENUE_LAST_YEAR_ROLLING_C :: number(18 , 2)    as practifi_revenue_last_year_rolling_c
  , json:PRACTIFI_SERVICES_OFFERED_C :: text                       as practifi_services_offered_c
  , json:PRACTIFI_SHARING_SCOPE_2_C :: text                        as practifi_sharing_scope_2_c
  , json:PRACTIFI_SHARING_SCOPE_3_C :: text                        as practifi_sharing_scope_3_c
  , json:PRACTIFI_SHARING_SCOPE_4_C :: text                        as practifi_sharing_scope_4_c
  , json:PRACTIFI_SHARING_SCOPE_5_C :: text                        as practifi_sharing_scope_5_c
  , json:PRACTIFI_STANDARD_OF_VALUE_C :: text                      as practifi_standard_of_value_c
  , json:PRACTIFI_STRUCTURE_C :: text                              as practifi_structure_c
  , json:PRACTIFI_TOTAL_RETURN_LAST_12_MONTHS_C :: number(18 , 2)  as practifi_total_return_last_12_months_c
  , json:PRACTIFI_TOTAL_RETURN_LAST_36_MONTHS_C :: number(18 , 2)  as practifi_total_return_last_36_months_c
  , json:PRACTIFI_TOTAL_RETURN_MTD_C :: number(18 , 2)             as practifi_total_return_mtd_c
  , json:PRACTIFI_TOTAL_RETURN_QTD_C :: number(18 , 2)             as practifi_total_return_qtd_c
  , json:PRACTIFI_TOTAL_RETURN_YTD_C :: number(18 , 2)             as practifi_total_return_ytd_c
  , json:PRACTIFI_UNREALIZED_GAIN_C :: number(18 , 2)              as practifi_unrealized_gain_c
  , json:PRACTIFI_VALUATION_DATE_C :: date                         as practifi_valuation_date_c
  , json:PRACTIFI_VALUATION_METHODOLOGY_C :: text                  as practifi_valuation_methodology_c
  , json:PRACTIFI_YEAR_FOUNDED_C :: text                           as practifi_year_founded_c
  , json:PRACTIFI_YEARS_EXPERIENCE_C :: float                      as practifi_years_experience_c
  , json:PRACTIFI_CONFIDENTIAL_C :: boolean                        as practifi_confidential_c
  , json:PRACTIFI_HAS_ACTIVE_SERVICES_C :: boolean                 as practifi_has_active_services_c
  , json:PRACTIFI_HOUSEHOLD_EMAIL_C :: text                        as practifi_household_email_c
  , json:PRACTIFI_HOUSEHOLD_PHONE_C :: text                        as practifi_household_phone_c
  , json:PRACTIFI_ORGANIZATION_EMAIL_C :: text                     as practifi_organization_email_c
  , json:PRACTIFI_ORGANIZATION_PHONE_C :: text                     as practifi_organization_phone_c
  , json:PRACTIFI_POTENTIAL_SERVICE_C :: text                      as practifi_potential_service_c
  , json:PRACTIFI_BATCH_PC :: text                                 as practifi_batch_pc
  , json:PRACTIFI_BIRTH_NAME_PC :: text                            as practifi_birth_name_pc
  , json:PRACTIFI_COUNTRY_OF_CITIZENSHIP_PC :: text                as practifi_country_of_citizenship_pc
  , json:PRACTIFI_COUNTRY_OF_RESIDENCE_PC :: text                  as practifi_country_of_residence_pc
  , json:PRACTIFI_EMPLOYER_PC :: text                              as practifi_employer_pc
  , json:PRACTIFI_EMPLOYMENT_STATUS_PC :: text                     as practifi_employment_status_pc
  , json:PRACTIFI_EXTERNAL_ID_PC :: text                           as practifi_external_id_pc
  , json:PRACTIFI_GENDER_PC :: text                                as practifi_gender_pc
  , json:PRACTIFI_MARITAL_STATUS_PC :: text                        as practifi_marital_status_pc
  , json:PRACTIFI_MIDDLE_NAME_PC :: text                           as practifi_middle_name_pc
  , json:PRACTIFI_OCCUPATION_PC :: text                            as practifi_occupation_pc
  , json:PRACTIFI_PREFERRED_NAME_PC :: text                        as practifi_preferred_name_pc
  , json:PRACTIFI_RMD_DATE_PC :: date                              as practifi_rmd_date_pc
  , json:PRACTIFI_SHARING_SCOPE_PC :: text                         as practifi_sharing_scope_pc
  , json:PRACTIFI_PRIMARY_ENTITY_PC :: text                        as practifi_primary_entity_pc
  , json:PRACTIFI_BIRTH_PLACE_PC :: text                           as practifi_birth_place_pc
  , json:PRACTIFI_SUFFIX_PC :: text                                as practifi_suffix_pc
  , json:PRACTIFI_SET_AS_CREATED_DATE_PC :: timestamp_tz           as practifi_set_as_created_date_pc
  , json:PRACTIFI_ALTERNATE_EMAIL_PC :: text                       as practifi_alternate_email_pc
  , json:PRACTIFI_ANTICIPATED_RETIREMENT_DATE_PC :: date           as practifi_anticipated_retirement_date_pc
  , json:PRACTIFI_CITIZENSHIP_STATUS_PC :: text                    as practifi_citizenship_status_pc
  , json:PRACTIFI_COUNTRY_OF_ORIGIN_PC :: text                     as practifi_country_of_origin_pc
  , json:PRACTIFI_DATE_OF_DEATH_PC :: date                         as practifi_date_of_death_pc
  , json:PRACTIFI_ENVESTNET_HANDLE_PC :: text                      as practifi_envestnet_handle_pc
  , json:PRACTIFI_PREFERRED_PHONE_PC :: text                       as practifi_preferred_phone_pc
  , json:PRACTIFI_RELATED_DIVISION_PC :: text                      as practifi_related_division_pc
  , json:PRACTIFI_STATE_OF_RESIDENCE_PC :: text                    as practifi_state_of_residence_pc
  , json:PRACTIFI_TAX_ID_NUMBER_PC :: text                         as practifi_tax_id_number_pc
  , json:PRACTIFI_CTCT_CONTACT_ID_PC :: text                       as practifi_ctct_contact_id_pc
  , json:PRACTIFI_PREFERRED_EMAIL_PC :: text                       as practifi_preferred_email_pc
  , json:PRACTIFI_DATE_OF_MARRIAGE_PC :: date                      as practifi_date_of_marriage_pc
  , json:PRACTIFI_EXTERNAL_ID_1_PC :: text                         as practifi_external_id_1_pc
  , json:PRACTIFI_EXTERNAL_ID_2_PC :: text                         as practifi_external_id_2_pc
  , json:PRACTIFI_EXTERNAL_ID_3_PC :: text                         as practifi_external_id_3_pc
  , json:PRACTIFI_EXTERNAL_ID_4_PC :: text                         as practifi_external_id_4_pc
  , json:PRACTIFI_PREFERRED_CONTACT_METHODS_PC :: text             as practifi_preferred_contact_methods_pc
  , json:PRACTIFI_DEFER_AUTOMATION_PC :: boolean                   as practifi_defer_automation_pc
  , json:PRACTIFI_DEPENDANT_UNTIL_AGE_PC :: float                  as practifi_dependant_until_age_pc
  , json:PRACTIFI_DISPLAY_COUNTRY_PC :: boolean                    as practifi_display_country_pc
  , json:PRACTIFI_DISPLAY_EMPLOYER_AND_TITLE_PC :: boolean         as practifi_display_employer_and_title_pc
  , json:PRACTIFI_EXCLUDE_LOCATION_ADDRESS_FROM_SYNC_PC :: boolean as practifi_exclude_location_address_from_sync_pc
  , json:PRACTIFI_EXCLUDE_POSTAL_ADDRESS_FROM_SYNC_PC :: boolean   as practifi_exclude_postal_address_from_sync_pc
  , json:PRACTIFI_MAILING_LABEL_PC :: text                         as practifi_mailing_label_pc
  , json:PRACTIFI_SMOKING_STATUS_PC :: text                        as practifi_smoking_status_pc
  , json:PRACTIFI_TAX_RESIDENT_STATUS_PC :: text                   as practifi_tax_resident_status_pc
  , json:PRACTIFI_SHARING_SCOPE_2_PC :: text                       as practifi_sharing_scope_2_pc
  , json:PRACTIFI_SHARING_SCOPE_3_PC :: text                       as practifi_sharing_scope_3_pc
  , json:PRACTIFI_SHARING_SCOPE_4_PC :: text                       as practifi_sharing_scope_4_pc
  , json:PRACTIFI_SHARING_SCOPE_5_PC :: text                       as practifi_sharing_scope_5_pc
  , json:PRACTIFI_IDENTITY_DOCUMENT_PC :: text                     as practifi_identity_document_pc
  , json:PRACTIFI_WORK_PHONE_PC :: text                            as practifi_work_phone_pc
  , json:PRACTIFI_REPLACE_MAILING_NAME_WITH_PC :: text             as practifi_replace_mailing_name_with_pc
  , json:PRACTIFI_TOPICS_PC :: text                                as practifi_topics_pc
  , json:PRACTIFI_ACTUAL_RETIREMENT_DATE_PC :: date                as practifi_actual_retirement_date_pc
  , json:PRACTIFI_INCOME_PC :: number(18 , 2)                      as practifi_income_pc
  , json:CRD_NO_PC :: text                                         as crd_no_pc
  , json:_FIVETRAN_DELETED :: boolean                              as _fivetran_deleted
  , json:_FIVETRAN_SYNCED :: timestamp_tz                          as _fivetran_synced
  , json:PRACTIFI_LAST_EMAIL_DATE_C :: timestamp_tz                as practifi_last_email_date_c
  , json:PRACTIFI_PERFORMANCE_LAST_5_YEARS_C :: float              as practifi_performance_last_5_years_c
  , json:PRACTIFI_PERFORMANCE_SINCE_INCEPTION_C :: float           as practifi_performance_since_inception_c
  , json:PRACTIFI_PERFORMANCE_PREVIOUS_YEAR_C :: float             as practifi_performance_previous_year_c
  , json:PRACTIFI_AS_AT_C :: date                                  as practifi_as_at_c
  , json:HUBSPOT_SCORE_PC :: float                                 as hubspot_score_pc
  , json:LIFECYCLE_STAGE_PC :: text                                as lifecycle_stage_pc
  , json:HS_LEAD_STATUS_PC :: text                                 as hs_lead_status_pc
  , json:LAST_CONTACTED_PC :: timestamp_tz                         as last_contacted_pc
  , json:HS_LEAD_SOURCE_PC :: text                                 as hs_lead_source_pc
  , json:BUSINESS_UNIT_PC :: text                                  as business_unit_pc
  , json:ARE_YOU_A_PC :: text                                      as are_you_a_pc
  , json:HS_ANALYTICS_SOURCE_PC :: text                            as hs_analytics_source_pc
  , json:HS_ANALYTICS_SOURCE_DATA_2_PC :: text                     as hs_analytics_source_data_2_pc
  , json:HS_ANALYTICS_SOURCE_DATA_1_PC :: text                     as hs_analytics_source_data_1_pc
  , json:HS_MARKETABLE_STATUS_PC :: boolean                        as hs_marketable_status_pc
  , json:ASSETS_UNDER_MANAGEMENT_PC :: number(18 , 2)              as assets_under_management_pc
  , json:REGISTRATION_STATUS_PC :: text                            as registration_status_pc
  , json:IP_COUNTRY_PC :: text                                     as ip_country_pc
  , 'salesforce'::text                                             as system_name
  , 'igo'::text                                                    as system_instance
  , system_name || '__' || system_instance                         as system_key
  , effective_at                                                   as effective_at
  , _created_at                                                    as _created_at
  , {{ col_is_head(
    reference=source('salesforce_igo', 'account'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('salesforce_igo', 'account') }}
