select
    json:ID::text                                             as id
    , json:OWNER_ID::text                                     as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::text                                         as name
    , json:CREATED_DATE::timestamp_tz                         as created_date
    , json:CREATED_BY_ID::text                                as created_by_id
    , json:LAST_MODIFIED_DATE::timestamp_tz                   as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text                          as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamp_tz                      as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                           as last_activity_date
    , json:LAST_VIEWED_DATE::timestamp_tz                     as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamp_tz                 as last_referenced_date
    , json:PRACTIFI_AUM_C::number(18 , 2)                     as practifi_aum_c
    , json:PRACTIFI_ANNUAL_REVENUE_C::number(18 , 2)          as practifi_annual_revenue_c
    , json:PRACTIFI_BATCH_C::text                             as practifi_batch_c
    , json:PRACTIFI_CLOSE_DATE_C::date                        as practifi_close_date_c
    , json:PRACTIFI_ENTITY_C::text                            as practifi_entity_c
    , json:PRACTIFI_EXTERNAL_ID_C::text                       as practifi_external_id_c
    , json:PRACTIFI_ONE_TIME_REVENUE_C::number(18 , 2)        as practifi_one_time_revenue_c
    , json:PRACTIFI_RATING_C::text                            as practifi_rating_c
    , json:PRACTIFI_RELATED_DIVISION_C::text                  as practifi_related_division_c
    , json:PRACTIFI_SERVICE_TYPE_C::text                      as practifi_service_type_c
    , json:PRACTIFI_SERVICE_C::text                           as practifi_service_c
    , json:PRACTIFI_SHARING_SCOPE_C::text                     as practifi_sharing_scope_c
    , json:PRACTIFI_STAGE_C::text                             as practifi_stage_c
    , json:PRACTIFI_RELATED_ENTITY_C::text                    as practifi_related_entity_c
    , json:PRACTIFI_FINANCIAL_PRODUCT_C::text                 as practifi_financial_product_c
    , json:PRACTIFI_SET_AS_CREATED_DATE_C::timestamp_tz       as practifi_set_as_created_date_c
    , json:PRACTIFI_DEFER_AUTOMATION_C::boolean               as practifi_defer_automation_c
    , json:PRACTIFI_FEE_C::text                               as practifi_fee_c
    , json:PRACTIFI_PERSON_C::text                            as practifi_person_c
    , json:PRACTIFI_STAGE_ENTRY_DATE_C::date                  as practifi_stage_entry_date_c
    , json:PRACTIFI_AMOUNT_C::number(18 , 2)                  as practifi_amount_c
    , json:PRACTIFI_BALANCE_C::number(18 , 2)                 as practifi_balance_c
    , json:PRACTIFI_DESCRIPTION_C::text                       as practifi_description_c
    , json:PRACTIFI_SALARY_C::number(18 , 2)                  as practifi_salary_c
    , json:PRACTIFI_PROBABILITY_TO_CLOSE_C::float             as practifi_probability_to_close_c
    , json:PRACTIFI_SHARING_SCOPE_2_C::text                   as practifi_sharing_scope_2_c
    , json:PRACTIFI_SHARING_SCOPE_3_C::text                   as practifi_sharing_scope_3_c
    , json:PRACTIFI_SHARING_SCOPE_4_C::text                   as practifi_sharing_scope_4_c
    , json:PRACTIFI_SHARING_SCOPE_5_C::text                   as practifi_sharing_scope_5_c
    , json:PRACTIFI_SPECIAL_CONSIDERATIONS_C::text            as practifi_special_considerations_c
    , json:PRACTIFI_STAGE_DAYS_IN_RANGE_C::text               as practifi_stage_days_in_range_c
    , json:PRACTIFI_STATUS_C::text                            as practifi_status_c
    , json:PRACTIFI_TYPE_C::text                              as practifi_type_c
    , json:CLIENT_NOTES_C::text                               as client_notes_c
    , json:GROWTH_C::text                                     as growth_c
    , json:OWNERSHIP_C::text                                  as ownership_c
    , json:TRANSACTION_RATIONALE_C::text                      as transaction_rationale_c
    , json:EXCLUDE_POSTAL_ADDRESS_SYNC_FROM_ENTITY_C::boolean as exclude_postal_address_sync_from_entity_c
    , json:CAMPAIGN_C::text                                   as campaign_c
    , json:IAPD_C::text                                       as iapd_c
    , json:LINKED_IN_C::text                                  as linked_in_c
    , json:TARGET_MARKET_C::text                              as target_market_c
    , json:A_LA_CARTE_SERVICES_C::text                        as a_la_carte_services_c
    , json:ADVISOR_PAYOUT_C::float                            as advisor_payout_c
    , json:AFFILIATION_MODEL_C::text                          as affiliation_model_c
    , json:BD_PAYOUT_C::float                                 as bd_payout_c
    , json:DEAL_STAGE_C::text                                 as deal_stage_c
    , json:LOAN_DOCS_ON_FILE_C::boolean                       as loan_docs_on_file_c
    , json:MARINER_TA_C::text                                 as mariner_ta_c
    , json:PCS_AUM_COMMITMENT_C::number(18 , 2)               as pcs_aum_commitment_c
    , json:PCS_FEE_C::float                                   as pcs_fee_c
    , json:PREVIOUS_DEAL_OWNER_C::text                        as previous_deal_owner_c
    , json:SERVICE_OFFERING_C::text                           as service_offering_c
    , json:SHARE_WITH_C::text                                 as share_with_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz                     as _fivetran_synced
    , json:PCS_ENGAGEMENT_C::boolean                          as pcs_engagement_c
    , json:TRANSITION_TIMELINE_C::text                        as transition_timeline_c
    , json:IAPD_BROKER_CHECK_C::text                          as iapd_broker_check_c
    , json:TRANSITION_NOTES_C::text                           as transition_notes_c
    , json:LPL_TA_C::text                                     as lpl_ta_c
    , json:NAF_WAIVED_C::boolean                              as naf_waived_c
    , json:DBA_FIRM_NAME_C::text                              as dba_firm_name_c
    , json:NO_OF_ADVISORY_ACCOUNTS_C::float                   as no_of_advisory_accounts_c
    , json:OTHER_REVENUE_C::number(18 , 2)                    as other_revenue_c
    , json:INSURANCE_REVENUE_C::number(18 , 2)                as insurance_revenue_c
    , json:JOINING_AN_EXISTING_OFFICE_C::boolean              as joining_an_existing_office_c
    , json:REFERRAL_FEE_C::float                              as referral_fee_c
    , json:ADVISORY_REVENUE_C::number(18 , 2)                 as advisory_revenue_c
    , json:WEALTH_REVENUE_C::number(18 , 2)                   as wealth_revenue_c
    , json:BROKERAGE_REVENUE_C::number(18 , 2)                as brokerage_revenue_c
    , json:ENTITY_ESTABLISHMENT_NEEDED_C::text                as entity_establishment_needed_c
    , json:NO_OF_BROKERAGE_ACCOUNTS_C::float                  as no_of_brokerage_accounts_c
    , json:TAX_REVENUE_C::number(18 , 2)                      as tax_revenue_c
    , json:X_401_K_PLAN_REVENUE_C::number(18 , 2)             as x_401_k_plan_revenue_c
    , json:SUCCESSION_C::boolean                              as succession_c
    , json:ADVISOR_STAGE_C::text                              as advisor_stage_c
    , json:TA_NEEDED_C::boolean                               as ta_needed_c
    , json:MB_MEETING_NOTES_C::text                           as mb_meeting_notes_c
    , json:MB_MEETING_C::date                                 as mb_meeting_c
    , 'salesforce'::text                                      as system_name
    , 'igo'::text                                             as system_instance
    , system_name || '__' || system_instance                  as system_key
    , effective_at                                            as effective_at
    , _created_at                                             as _created_at
    , {{ col_is_head(
      reference=source('salesforce_igo', 'practifi_deal_c'),
      source_date_col='effective_at',
      reference_date_col='effective_at'
      ) }}
from {{ source('salesforce_igo', 'practifi_deal_c') }}
