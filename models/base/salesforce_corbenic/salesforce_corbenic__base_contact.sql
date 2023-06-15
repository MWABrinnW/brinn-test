select
    a.json:ID:: VARCHAR(18)                                     as id
  , a.json:IS_DELETED:: BOOLEAN                                 as is_deleted
  , a.json:MASTER_RECORD_ID:: VARCHAR(18)                       as master_record_id
  , a.json:ACCOUNT_ID:: VARCHAR(18)                             as account_id
  , a.json:LAST_NAME:: VARCHAR(240)                             as last_name
  , a.json:FIRST_NAME:: VARCHAR(120)                            as first_name
  , a.json:SALUTATION:: VARCHAR(120)                            as salutation
  , a.json:MIDDLE_NAME:: VARCHAR(120)                           as middle_name
  , a.json:SUFFIX:: VARCHAR(120)                                as suffix
  , a.json:NAME:: VARCHAR(363)                                  as name
  , a.json:RECORD_TYPE_ID:: VARCHAR(18)                         as record_type_id
  , a.json:OTHER_STREET:: VARCHAR(765)                          as other_street
  , a.json:OTHER_CITY:: VARCHAR(120)                            as other_city
  , a.json:OTHER_STATE:: VARCHAR(240)                           as other_state
  , a.json:OTHER_POSTAL_CODE:: VARCHAR(60)                      as other_postal_code
  , a.json:OTHER_COUNTRY:: VARCHAR(240)                         as other_country
  , a.json:OTHER_LATITUDE:: DOUBLE                              as other_latitude
  , a.json:OTHER_LONGITUDE:: DOUBLE                             as other_longitude
  , a.json:OTHER_GEOCODE_ACCURACY:: VARCHAR(120)                as other_geocode_accuracy
  , a.json:MAILING_STREET:: VARCHAR(765)                        as mailing_street
  , a.json:MAILING_CITY:: VARCHAR(120)                          as mailing_city
  , a.json:MAILING_STATE:: VARCHAR(240)                         as mailing_state
  , a.json:MAILING_POSTAL_CODE:: VARCHAR(60)                    as mailing_postal_code
  , a.json:MAILING_COUNTRY:: VARCHAR(240)                       as mailing_country
  , a.json:MAILING_LATITUDE:: DOUBLE                            as mailing_latitude
  , a.json:MAILING_LONGITUDE:: DOUBLE                           as mailing_longitude
  , a.json:MAILING_GEOCODE_ACCURACY:: VARCHAR(120)              as mailing_geocode_accuracy
  , a.json:PHONE:: VARCHAR(120)                                 as phone
  , a.json:FAX:: VARCHAR(120)                                   as fax
  , a.json:MOBILE_PHONE:: VARCHAR(120)                          as mobile_phone
  , a.json:HOME_PHONE:: VARCHAR(120)                            as home_phone
  , a.json:OTHER_PHONE:: VARCHAR(120)                           as other_phone
  , a.json:ASSISTANT_PHONE:: VARCHAR(120)                       as assistant_phone
  , a.json:TITLE:: VARCHAR(384)                                 as title
  , a.json:DEPARTMENT:: VARCHAR(240)                            as department
  , a.json:ASSISTANT_NAME:: VARCHAR(120)                        as assistant_name
  , a.json:BIRTHDATE:: DATE                                     as birthdate
  , a.json:DESCRIPTION:: VARCHAR(96000)                         as description
  , a.json:OWNER_ID:: VARCHAR(18)                               as owner_id
  , a.json:DO_NOT_CALL:: BOOLEAN                                as do_not_call
  , a.json:CREATED_DATE:: TIMESTAMPTZ                           as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                          as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ                     as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)                    as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ                        as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: DATE                            as last_activity_date
  , a.json:LAST_CUREQUEST_DATE:: TIMESTAMPTZ                    as last_curequest_date
  , a.json:LAST_CUUPDATE_DATE:: TIMESTAMPTZ                     as last_cuupdate_date
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ                       as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ                   as last_referenced_date
  , a.json:EMAIL_BOUNCED_REASON:: VARCHAR(765)                  as email_bounced_reason
  , a.json:EMAIL_BOUNCED_DATE:: TIMESTAMPTZ                     as email_bounced_date
  , a.json:IS_EMAIL_BOUNCED:: BOOLEAN                           as is_email_bounced
  , a.json:PHOTO_URL:: VARCHAR(765)                             as photo_url
  , a.json:JIGSAW_CONTACT_ID:: VARCHAR(60)                      as jigsaw_contact_id
  , a.json:ASSISTANT_EMAIL_C:: VARCHAR(240)                     as assistant_email_c
  , a.json:BUSINESS_EMAIL_C:: VARCHAR(240)                      as business_email_c
  , a.json:BUSINESS_NAME_C:: VARCHAR(240)                       as business_name_c
  , a.json:BUSINESS_PHONE_C:: VARCHAR(120)                      as business_phone_c
  , a.json:COLLEGE_C:: VARCHAR(300)                             as college_c
  , a.json:REFERRAL_SOURCE_C:: VARCHAR(18)                      as referral_source_c
  , a.json:DATE_OF_DEATH_C:: DATE                               as date_of_death_c
  , a.json:FAVORITE_ALCOHOLIC_BEVERAGE_C:: VARCHAR(300)         as favorite_alcoholic_beverage_c
  , a.json:FAVORITE_LIGHT_BEVERAGE_C:: VARCHAR(300)             as favorite_light_beverage_c
  , a.json:FAVORITE_SNACK_C:: VARCHAR(300)                      as favorite_snack_c
  , a.json:FILE_AS_C:: VARCHAR(300)                             as file_as_c
  , a.json:GENDER_C:: VARCHAR(765)                              as gender_c
  , a.json:HOBBIES_C:: VARCHAR(4099)                            as hobbies_c
  , a.json:INVESTMENT_INTERESTS_C:: VARCHAR(4099)               as investment_interests_c
  , a.json:INVESTMENT_OBJECTIVES_C:: VARCHAR(4099)              as investment_objectives_c
  , a.json:INVESTMENT_VEHICLES_USED_C:: VARCHAR(4099)           as investment_vehicles_used_c
  , a.json:LEGAL_ADDRESS_CITY_C:: VARCHAR(150)                  as legal_address_city_c
  , a.json:LEGAL_ADDRESS_LABEL_C:: VARCHAR(240)                 as legal_address_label_c
  , a.json:LEGAL_ADDRESS_POSTAL_CODE_C:: VARCHAR(30)            as legal_address_postal_code_c
  , a.json:LEGAL_ADDRESS_STATE_C:: VARCHAR(90)                  as legal_address_state_c
  , a.json:LEGAL_STREET_ADDRESS_C:: VARCHAR(300)                as legal_street_address_c
  , a.json:MARITAL_STATUS_C:: VARCHAR(765)                      as marital_status_c
  , a.json:MOBILE_PERSONAL_C:: VARCHAR(120)                     as mobile_personal_c
  , a.json:NICKNAME_C:: VARCHAR(150)                            as nickname_c
  , a.json:OCCUPATION_C:: VARCHAR(150)                          as occupation_c
  , a.json:PERSONAL_EMAIL_C:: VARCHAR(240)                      as personal_email_c
  , a.json:PREFERRED_CONTACT_METHOD_C:: VARCHAR(765)            as preferred_contact_method_c
  , a.json:PREFERRED_CONTACT_TIME_C:: VARCHAR(765)              as preferred_contact_time_c
  , a.json:PREFERRED_WEALTH_EMAIL_C:: VARCHAR(765)              as preferred_wealth_email_c
  , a.json:BUSINESS_ADDRESS_CITY_C:: VARCHAR(300)               as business_address_city_c
  , a.json:BUSINESS_ADDRESS_LABEL_C:: VARCHAR(240)              as business_address_label_c
  , a.json:BUSINESS_ADDRESS_POSTAL_CODE_C:: VARCHAR(30)         as business_address_postal_code_c
  , a.json:BUSINESS_ADDRESS_STATE_C:: VARCHAR(90)               as business_address_state_c
  , a.json:BUSINESS_ADDRESS_C:: VARCHAR(300)                    as business_address_c
  , a.json:COLLEGE_GRADUATION_C:: DATE                          as college_graduation_c
  , a.json:DIGITAL_MARKETING_CAMPAIGNS_WEALTH_C:: VARCHAR(4099) as digital_marketing_campaigns_wealth_c
  , a.json:DIGITAL_MARKETING_OPT_OUT_WEALTH_C:: BOOLEAN         as digital_marketing_opt_out_wealth_c
  , a.json:DIGITAL_MARKETING_OPTIONS_WEALTH_C:: VARCHAR(4099)   as digital_marketing_options_wealth_c
  , a.json:TAGS_C:: VARCHAR(4099)                               as tags_c
  , a.json:WEDDING_ANNIVERSARY_C:: DATE                         as wedding_anniversary_c
  , a.json:USER_C:: VARCHAR(18)                                 as user_c
  , a.json:WEALTH_CONTACT_LIFECYCLE_C:: VARCHAR(765)            as wealth_contact_lifecycle_c
  , a.json:RETIREMENT_CONTACT_LIFECYCLE_C:: VARCHAR(765)        as retirement_contact_lifecycle_c
  , a.json:LEAD_SOURCE_WEALTH_C:: VARCHAR(765)                  as lead_source_wealth_c
  , a.json:ASSET_MANAGEMENT_CONTACT_LIFECYCLE_C:: VARCHAR(765)  as asset_management_contact_lifecycle_c
  , a.json:LEAD_AMOUNT_WEALTH_C:: NUMBER(18, 2)                 as lead_amount_wealth_c
  , a.json:MARKETING_OWNER_C:: VARCHAR(18)                      as marketing_owner_c
  , a.json:CONTACT_TYPE_C:: VARCHAR(765)                        as contact_type_c
  , a.json:INDIVIDUAL_INSURANCE_DEATH_BENEFIT_C:: NUMBER(18, 2) as individual_insurance_death_benefit_c
  , a.json:MARKETING_OWNER_WEALTH_C:: VARCHAR(18)               as marketing_owner_wealth_c
  , a.json:MARKETING_OWNER_RETIREMENT_C:: VARCHAR(18)           as marketing_owner_retirement_c
  , a.json:MARKETING_OWNER_ASSET_MGT_C:: VARCHAR(18)            as marketing_owner_asset_mgt_c
  , a.json:ROLE_C:: VARCHAR(4099)                               as role_c
  , a.json:MH_QUARTERLY_REPORT_VERSION_C:: VARCHAR(765)         as mh_quarterly_report_version_c
  , a.json:MH_RBG_COLOR_ASSIGNMENT_C:: VARCHAR(765)             as mh_rbg_color_assignment_c
  , a.json:MAILING_LABEL_C:: VARCHAR(240)                       as mailing_label_c
  , a.json:MH_TEAM_FILE_LOCATION_C:: VARCHAR(600)               as mh_team_file_location_c
  , a.json:SHORT_NOTE_C:: VARCHAR(15000)                        as short_note_c
  , a.json:COUNTRY_OF_CITIZENSHIP_C:: VARCHAR(765)              as country_of_citizenship_c
  , a.json:ADVISOR_TERMINATION_DATE_C:: DATE                    as advisor_termination_date_c
  , a.json:FIRST_DATE_OF_OFAC_CHECK_C:: DATE                    as first_date_of_ofac_check_c
  , a.json:MOST_RECENT_DATE_OF_OFAC_CHECK_C:: DATE              as most_recent_date_of_ofac_check_c
  , a.json:UNIQUE_ID_C:: VARCHAR(90)                            as unique_id_c
  , a.json:DDL_FIRM_ID_C:: VARCHAR(765)                         as ddl_firm_id_c
  , a.json:DDL_REP_ID_C:: VARCHAR(765)                          as ddl_rep_id_c
  , a.json:SYS_TOPIC_1_C:: VARCHAR(765)                         as sys_topic_1_c
  , a.json:SYS_TOPIC_2_C:: VARCHAR(765)                         as sys_topic_2_c
  , a.json:SYS_TOPIC_3_C:: VARCHAR(765)                         as sys_topic_3_c
  , a.json:COUNTRY_OF_RESIDENCE_C:: VARCHAR(765)                as country_of_residence_c
  , a.json:SYS_MIGRATION_SOURCE_C:: VARCHAR(4099)               as sys_migration_source_c
  , a.json:SYS_MIGRATION_ID_C:: VARCHAR(765)                    as sys_migration_id_c
  , a.json:MFIT_EXCLUSION_OVERRIDE_C:: BOOLEAN                  as mfit_exclusion_override_c
  , a.json:NOTIFICATION_ID_C:: VARCHAR(90)                      as notification_id_c
  , a.json:MH_PHOTO_C:: VARCHAR(98304)                          as mh_photo_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ                       as _fivetran_synced
  , a.json:CONTACT_ID_18_C:: VARCHAR(3900)                      as contact_id_18_c
  , a.json:CLIENT_AGE_C:: DOUBLE                                as client_age_c
  , a.json:OCCUPATION_CODE_C:: VARCHAR(18)                      as occupation_code_c
  , a.json:RETIRED_C:: BOOLEAN                                  as retired_c
  , a.json:ORIGINAL_OPPTY_STAGE_C:: VARCHAR(765)                as original_oppty_stage_c
  , a.json:REPORTS_TO_ID:: VARCHAR(18)                          as reports_to_id
  , a.json:LEAD_AMOUNT_ASSET_MGT_C:: NUMBER(18, 2)              as lead_amount_asset_mgt_c
  , a.json:LEAD_SOURCE_RETIREMENT_C:: VARCHAR(765)              as lead_source_retirement_c
  , a.json:LEAD_AMOUNT_RETIREMENT_C:: NUMBER(18, 2)             as lead_amount_retirement_c
  , a.json:HAS_OPTED_OUT_OF_FAX:: BOOLEAN                       as has_opted_out_of_fax
  , a.json:ALTERNATE_EMAIL_C:: VARCHAR(240)                     as alternate_email_c
  , a.json:LEAD_SOURCE:: VARCHAR(765)                           as lead_source
  , a.json:OUT_OF_OFFICE_C:: BOOLEAN                            as out_of_office_c
  , a.json:ALLOW_CASES_C:: BOOLEAN                              as allow_cases_c
  , a.json:LEAD_SOURCE_ASSET_MGT_C:: VARCHAR(765)               as lead_source_asset_mgt_c
  , a.json:ADV_CATEGORY_C:: VARCHAR(3900)                       as adv_category_c
  , a.json:OPERATIONS_EMPLOYEE_C:: BOOLEAN                      as operations_employee_c
  , a.json:IMPORT_ID_C:: VARCHAR(150)                           as import_id_c
  , a.json:BOCLIENT_DATA_PROJECT_KEY_C:: VARCHAR(765)           as boclient_data_project_key_c
  , a.json:EMAIL:: VARCHAR(240)                                 as email
  , a.json:HAS_OPTED_OUT_OF_EMAIL:: BOOLEAN                     as has_opted_out_of_email
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                          as _fivetran_deleted

  , a.effective_at::timestamp                                   as effective_at
  , a._created_at::timestamp                                    as _created_at
  , {{ col_is_head(reference=source('salesforce_corbenic', 'contact'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                        as is_latest
from {{ source('salesforce_corbenic', 'contact') }} a
left join (
              select
                  effective_at::date                                                            as effective_at
                , _created_at
                , row_number() over (partition by effective_at::date order by _created_at desc) as rn
              from {{ source('salesforce_corbenic', 'contact') }}
              group by 1, 2
          )                                         b
          on a.effective_at::date = b.effective_at::date
              and a._created_at = b._created_at