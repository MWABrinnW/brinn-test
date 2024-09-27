select
    'salesforce'::text(200)                                     as system_name
    , 'compass'::text(200)                                      as system_instance
    , concat(system_name , '__' , system_instance)::text(200)   as system_key
    , 'mwa'::text(200)                                          as firm_source
    , json:ID::varchar(18)                                      as id
    , json:IS_DELETED::boolean                                  as is_deleted
    , json:MASTER_RECORD_ID::varchar(18)                        as master_record_id
    , json:ACCOUNT_ID::varchar(18)                              as account_id
    , json:LAST_NAME::varchar(240)                              as last_name
    , json:FIRST_NAME::varchar(120)                             as first_name
    , json:SALUTATION::varchar(120)                             as salutation
    , json:MIDDLE_NAME::varchar(120)                            as middle_name
    , json:SUFFIX::varchar(120)                                 as suffix
    , json:NAME::varchar(363)                                   as name
    , json:RECORD_TYPE_ID::varchar(18)                          as record_type_id
    , json:OTHER_STREET::varchar(765)                           as other_street
    , json:OTHER_CITY::varchar(120)                             as other_city
    , json:OTHER_STATE::varchar(240)                            as other_state
    , json:OTHER_POSTAL_CODE::varchar(60)                       as other_postal_code
    , json:OTHER_COUNTRY::varchar(240)                          as other_country
    , json:OTHER_LATITUDE::double                               as other_latitude
    , json:OTHER_LONGITUDE::double                              as other_longitude
    , json:OTHER_GEOCODE_ACCURACY::varchar(120)                 as other_geocode_accuracy
    , json:MAILING_STREET::varchar(765)                         as mailing_street
    , json:MAILING_CITY::varchar(120)                           as mailing_city
    , json:MAILING_STATE::varchar(240)                          as mailing_state
    , json:MAILING_POSTAL_CODE::varchar(60)                     as mailing_postal_code
    , json:MAILING_COUNTRY::varchar(240)                        as mailing_country
    , json:MAILING_LATITUDE::double                             as mailing_latitude
    , json:MAILING_LONGITUDE::double                            as mailing_longitude
    , json:MAILING_GEOCODE_ACCURACY::varchar(120)               as mailing_geocode_accuracy
    , json:PHONE::varchar(120)                                  as phone
    , json:FAX::varchar(120)                                    as fax
    , json:MOBILE_PHONE::varchar(120)                           as mobile_phone
    , json:HOME_PHONE::varchar(120)                             as home_phone
    , json:OTHER_PHONE::varchar(120)                            as other_phone
    , json:ASSISTANT_PHONE::varchar(120)                        as assistant_phone
    , json:TITLE::varchar(384)                                  as title
    , json:DEPARTMENT::varchar(240)                             as department
    , json:ASSISTANT_NAME::varchar(120)                         as assistant_name
    , json:BIRTHDATE::date                                      as birthdate
    , json:DESCRIPTION::varchar(96000)                          as description
    , json:OWNER_ID::varchar(18)                                as owner_id
    , json:DO_NOT_CALL::boolean                                 as do_not_call
    , json:CREATED_DATE::timestamptz                            as created_date
    , json:CREATED_BY_ID::varchar(18)                           as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                      as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                     as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                         as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                             as last_activity_date
    , json:LAST_CUREQUEST_DATE::timestamptz                     as last_curequest_date
    , json:LAST_CUUPDATE_DATE::timestamptz                      as last_cuupdate_date
    , json:LAST_VIEWED_DATE::timestamptz                        as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                    as last_referenced_date
    , json:EMAIL_BOUNCED_REASON::varchar(765)                   as email_bounced_reason
    , json:EMAIL_BOUNCED_DATE::timestamptz                      as email_bounced_date
    , json:IS_EMAIL_BOUNCED::boolean                            as is_email_bounced
    , json:PHOTO_URL::varchar(765)                              as photo_url
    , json:JIGSAW_CONTACT_ID::varchar(60)                       as jigsaw_contact_id
    , json:ASSISTANT_EMAIL_C::varchar(240)                      as assistant_email_c
    , json:BUSINESS_EMAIL_C::varchar(240)                       as business_email_c
    , json:BUSINESS_NAME_C::varchar(240)                        as business_name_c
    , json:BUSINESS_PHONE_C::varchar(120)                       as business_phone_c
    , json:COLLEGE_C::varchar(300)                              as college_c
    , json:REFERRAL_SOURCE_C::varchar(18)                       as referral_source_c
    , json:DATE_OF_DEATH_C::date                                as date_of_death_c
    , json:FAVORITE_ALCOHOLIC_BEVERAGE_C::varchar(300)          as favorite_alcoholic_beverage_c
    , json:FAVORITE_LIGHT_BEVERAGE_C::varchar(300)              as favorite_light_beverage_c
    , json:FAVORITE_SNACK_C::varchar(300)                       as favorite_snack_c
    , json:FILE_AS_C::varchar(300)                              as file_as_c
    , json:GENDER_C::varchar(765)                               as gender_c
    , json:HOBBIES_C::varchar(4099)                             as hobbies_c
    , json:INVESTMENT_INTERESTS_C::varchar(4099)                as investment_interests_c
    , json:INVESTMENT_OBJECTIVES_C::varchar(4099)               as investment_objectives_c
    , json:INVESTMENT_VEHICLES_USED_C::varchar(4099)            as investment_vehicles_used_c
    , json:LEGAL_ADDRESS_CITY_C::varchar(150)                   as legal_address_city_c
    , json:LEGAL_ADDRESS_LABEL_C::varchar(240)                  as legal_address_label_c
    , json:LEGAL_ADDRESS_POSTAL_CODE_C::varchar(30)             as legal_address_postal_code_c
    , json:LEGAL_ADDRESS_STATE_C::varchar(90)                   as legal_address_state_c
    , json:LEGAL_STREET_ADDRESS_C::varchar(300)                 as legal_street_address_c
    , json:MARITAL_STATUS_C::varchar(765)                       as marital_status_c
    , json:MOBILE_PERSONAL_C::varchar(120)                      as mobile_personal_c
    , json:NICKNAME_C::varchar(150)                             as nickname_c
    , json:OCCUPATION_C::varchar(150)                           as occupation_c
    , json:PERSONAL_EMAIL_C::varchar(240)                       as personal_email_c
    , json:PREFERRED_CONTACT_METHOD_C::varchar(765)             as preferred_contact_method_c
    , json:PREFERRED_CONTACT_TIME_C::varchar(765)               as preferred_contact_time_c
    , json:PREFERRED_WEALTH_EMAIL_C::varchar(765)               as preferred_wealth_email_c
    , json:BUSINESS_ADDRESS_CITY_C::varchar(300)                as business_address_city_c
    , json:BUSINESS_ADDRESS_LABEL_C::varchar(240)               as business_address_label_c
    , json:BUSINESS_ADDRESS_POSTAL_CODE_C::varchar(30)          as business_address_postal_code_c
    , json:BUSINESS_ADDRESS_STATE_C::varchar(90)                as business_address_state_c
    , json:BUSINESS_ADDRESS_C::varchar(300)                     as business_address_c
    , json:COLLEGE_GRADUATION_C::date                           as college_graduation_c
    , json:DIGITAL_MARKETING_CAMPAIGNS_WEALTH_C::varchar(4099)  as digital_marketing_campaigns_wealth_c
    , json:DIGITAL_MARKETING_OPT_OUT_WEALTH_C::boolean          as digital_marketing_opt_out_wealth_c
    , json:DIGITAL_MARKETING_OPTIONS_WEALTH_C::varchar(4099)    as digital_marketing_options_wealth_c
    , json:TAGS_C::varchar(4099)                                as tags_c
    , json:WEDDING_ANNIVERSARY_C::date                          as wedding_anniversary_c
    , json:USER_C::varchar(18)                                  as user_c
    , json:WEALTH_CONTACT_LIFECYCLE_C::varchar(765)             as wealth_contact_lifecycle_c
    , json:RETIREMENT_CONTACT_LIFECYCLE_C::varchar(765)         as retirement_contact_lifecycle_c
    , json:LEAD_SOURCE_WEALTH_C::varchar(765)                   as lead_source_wealth_c
    , json:ASSET_MANAGEMENT_CONTACT_LIFECYCLE_C::varchar(765)   as asset_management_contact_lifecycle_c
    , json:LEAD_AMOUNT_WEALTH_C::number(18 , 2)                 as lead_amount_wealth_c
    , json:MARKETING_OWNER_C::varchar(18)                       as marketing_owner_c
    , json:CONTACT_TYPE_C::varchar(765)                         as contact_type_c
    , json:INDIVIDUAL_INSURANCE_DEATH_BENEFIT_C::number(18 , 2) as individual_insurance_death_benefit_c
    , json:MARKETING_OWNER_WEALTH_C::varchar(18)                as marketing_owner_wealth_c
    , json:MARKETING_OWNER_RETIREMENT_C::varchar(18)            as marketing_owner_retirement_c
    , json:MARKETING_OWNER_ASSET_MGT_C::varchar(18)             as marketing_owner_asset_mgt_c
    , json:ROLE_C::varchar(4099)                                as role_c
    , json:MH_QUARTERLY_REPORT_VERSION_C::varchar(765)          as mh_quarterly_report_version_c
    , json:MH_RBG_COLOR_ASSIGNMENT_C::varchar(765)              as mh_rbg_color_assignment_c
    , json:MAILING_LABEL_C::varchar(240)                        as mailing_label_c
    , json:MH_TEAM_FILE_LOCATION_C::varchar(600)                as mh_team_file_location_c
    , json:SHORT_NOTE_C::varchar(15000)                         as short_note_c
    , json:COUNTRY_OF_CITIZENSHIP_C::varchar(765)               as country_of_citizenship_c
    , json:ADVISOR_TERMINATION_DATE_C::date                     as advisor_termination_date_c
    , json:FIRST_DATE_OF_OFAC_CHECK_C::date                     as first_date_of_ofac_check_c
    , json:MOST_RECENT_DATE_OF_OFAC_CHECK_C::date               as most_recent_date_of_ofac_check_c
    , json:UNIQUE_ID_C::varchar(90)                             as unique_id_c
    , json:DDL_FIRM_ID_C::varchar(765)                          as ddl_firm_id_c
    , json:DDL_REP_ID_C::varchar(765)                           as ddl_rep_id_c
    , json:SYS_TOPIC_1_C::varchar(765)                          as sys_topic_1_c
    , json:SYS_TOPIC_2_C::varchar(765)                          as sys_topic_2_c
    , json:SYS_TOPIC_3_C::varchar(765)                          as sys_topic_3_c
    , json:COUNTRY_OF_RESIDENCE_C::varchar(765)                 as country_of_residence_c
    , json:SYS_MIGRATION_SOURCE_C::varchar(4099)                as sys_migration_source_c
    , json:SYS_MIGRATION_ID_C::varchar(765)                     as sys_migration_id_c
    , json:MFIT_EXCLUSION_OVERRIDE_C::boolean                   as mfit_exclusion_override_c
    , json:NOTIFICATION_ID_C::varchar(90)                       as notification_id_c
    , json:MH_PHOTO_C::varchar(98304)                           as mh_photo_c
    , json:_FIVETRAN_SYNCED::timestamptz                        as _fivetran_synced
    , json:CONTACT_ID_18_C::varchar(3900)                       as contact_id_18_c
    , json:CLIENT_AGE_C::double                                 as client_age_c
    , json:OCCUPATION_CODE_C::varchar(18)                       as occupation_code_c
    , json:RETIRED_C::boolean                                   as retired_c
    , json:ORIGINAL_OPPTY_STAGE_C::varchar(765)                 as original_oppty_stage_c
    , json:REPORTS_TO_ID::varchar(18)                           as reports_to_id
    , json:LEAD_AMOUNT_ASSET_MGT_C::number(18 , 2)              as lead_amount_asset_mgt_c
    , json:LEAD_SOURCE_RETIREMENT_C::varchar(765)               as lead_source_retirement_c
    , json:LEAD_AMOUNT_RETIREMENT_C::number(18 , 2)             as lead_amount_retirement_c
    , json:HAS_OPTED_OUT_OF_FAX::boolean                        as has_opted_out_of_fax
    , json:ALTERNATE_EMAIL_C::varchar(240)                      as alternate_email_c
    , json:LEAD_SOURCE::varchar(765)                            as lead_source
    , json:OUT_OF_OFFICE_C::boolean                             as out_of_office_c
    , json:ALLOW_CASES_C::boolean                               as allow_cases_c
    , json:LEAD_SOURCE_ASSET_MGT_C::varchar(765)                as lead_source_asset_mgt_c
    , json:ADV_CATEGORY_C::varchar(3900)                        as adv_category_c
    , json:OPERATIONS_EMPLOYEE_C::boolean                       as operations_employee_c
    , json:IMPORT_ID_C::varchar(150)                            as import_id_c
    , json:BOCLIENT_DATA_PROJECT_KEY_C::varchar(765)            as boclient_data_project_key_c
    , json:EMAIL::varchar(240)                                  as email
    , json:HAS_OPTED_OUT_OF_EMAIL::boolean                      as has_opted_out_of_email
    , json:PAYEE_TYPE_C::varchar(200)                           as payee_type_c
    , json:_FIVETRAN_DELETED::boolean                           as _fivetran_deleted

    , effective_at::timestamp                                   as effective_at
    , _created_at::timestamp                                    as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'contact')
        , source_date_col='effective_at'
        , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                         as is_latest
from {{ source('salesforce_compass', 'contact') }}
