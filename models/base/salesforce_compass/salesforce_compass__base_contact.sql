select
    'salesforce'::text(200)                                       as system_name
    , 'compass'::text(200)                                        as system_instance
    , concat(system_name , '__' , system_instance)::text(200)     as system_key
    , 'mwa'::text(200)                                            as firm_source
    , a.json:ID::varchar(18)                                      as id
    , a.json:IS_DELETED::boolean                                  as is_deleted
    , a.json:MASTER_RECORD_ID::varchar(18)                        as master_record_id
    , a.json:ACCOUNT_ID::varchar(18)                              as account_id
    , a.json:LAST_NAME::varchar(240)                              as last_name
    , a.json:FIRST_NAME::varchar(120)                             as first_name
    , a.json:SALUTATION::varchar(120)                             as salutation
    , a.json:MIDDLE_NAME::varchar(120)                            as middle_name
    , a.json:SUFFIX::varchar(120)                                 as suffix
    , a.json:NAME::varchar(363)                                   as name
    , a.json:RECORD_TYPE_ID::varchar(18)                          as record_type_id
    , a.json:OTHER_STREET::varchar(765)                           as other_street
    , a.json:OTHER_CITY::varchar(120)                             as other_city
    , a.json:OTHER_STATE::varchar(240)                            as other_state
    , a.json:OTHER_POSTAL_CODE::varchar(60)                       as other_postal_code
    , a.json:OTHER_COUNTRY::varchar(240)                          as other_country
    , a.json:OTHER_LATITUDE::double                               as other_latitude
    , a.json:OTHER_LONGITUDE::double                              as other_longitude
    , a.json:OTHER_GEOCODE_ACCURACY::varchar(120)                 as other_geocode_accuracy
    , a.json:MAILING_STREET::varchar(765)                         as mailing_street
    , a.json:MAILING_CITY::varchar(120)                           as mailing_city
    , a.json:MAILING_STATE::varchar(240)                          as mailing_state
    , a.json:MAILING_POSTAL_CODE::varchar(60)                     as mailing_postal_code
    , a.json:MAILING_COUNTRY::varchar(240)                        as mailing_country
    , a.json:MAILING_LATITUDE::double                             as mailing_latitude
    , a.json:MAILING_LONGITUDE::double                            as mailing_longitude
    , a.json:MAILING_GEOCODE_ACCURACY::varchar(120)               as mailing_geocode_accuracy
    , a.json:PHONE::varchar(120)                                  as phone
    , a.json:FAX::varchar(120)                                    as fax
    , a.json:MOBILE_PHONE::varchar(120)                           as mobile_phone
    , a.json:HOME_PHONE::varchar(120)                             as home_phone
    , a.json:OTHER_PHONE::varchar(120)                            as other_phone
    , a.json:ASSISTANT_PHONE::varchar(120)                        as assistant_phone
    , a.json:TITLE::varchar(384)                                  as title
    , a.json:DEPARTMENT::varchar(240)                             as department
    , a.json:ASSISTANT_NAME::varchar(120)                         as assistant_name
    , a.json:BIRTHDATE::date                                      as birthdate
    , a.json:DESCRIPTION::varchar(96000)                          as description
    , a.json:OWNER_ID::varchar(18)                                as owner_id
    , a.json:DO_NOT_CALL::boolean                                 as do_not_call
    , a.json:CREATED_DATE::timestamptz                            as created_date
    , a.json:CREATED_BY_ID::varchar(18)                           as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                      as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                     as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                         as system_modstamp
    , a.json:LAST_ACTIVITY_DATE::date                             as last_activity_date
    , a.json:LAST_CUREQUEST_DATE::timestamptz                     as last_curequest_date
    , a.json:LAST_CUUPDATE_DATE::timestamptz                      as last_cuupdate_date
    , a.json:LAST_VIEWED_DATE::timestamptz                        as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                    as last_referenced_date
    , a.json:EMAIL_BOUNCED_REASON::varchar(765)                   as email_bounced_reason
    , a.json:EMAIL_BOUNCED_DATE::timestamptz                      as email_bounced_date
    , a.json:IS_EMAIL_BOUNCED::boolean                            as is_email_bounced
    , a.json:PHOTO_URL::varchar(765)                              as photo_url
    , a.json:JIGSAW_CONTACT_ID::varchar(60)                       as jigsaw_contact_id
    , a.json:ASSISTANT_EMAIL_C::varchar(240)                      as assistant_email_c
    , a.json:BUSINESS_EMAIL_C::varchar(240)                       as business_email_c
    , a.json:BUSINESS_NAME_C::varchar(240)                        as business_name_c
    , a.json:BUSINESS_PHONE_C::varchar(120)                       as business_phone_c
    , a.json:COLLEGE_C::varchar(300)                              as college_c
    , a.json:REFERRAL_SOURCE_C::varchar(18)                       as referral_source_c
    , a.json:DATE_OF_DEATH_C::date                                as date_of_death_c
    , a.json:FAVORITE_ALCOHOLIC_BEVERAGE_C::varchar(300)          as favorite_alcoholic_beverage_c
    , a.json:FAVORITE_LIGHT_BEVERAGE_C::varchar(300)              as favorite_light_beverage_c
    , a.json:FAVORITE_SNACK_C::varchar(300)                       as favorite_snack_c
    , a.json:FILE_AS_C::varchar(300)                              as file_as_c
    , a.json:GENDER_C::varchar(765)                               as gender_c
    , a.json:HOBBIES_C::varchar(4099)                             as hobbies_c
    , a.json:INVESTMENT_INTERESTS_C::varchar(4099)                as investment_interests_c
    , a.json:INVESTMENT_OBJECTIVES_C::varchar(4099)               as investment_objectives_c
    , a.json:INVESTMENT_VEHICLES_USED_C::varchar(4099)            as investment_vehicles_used_c
    , a.json:LEGAL_ADDRESS_CITY_C::varchar(150)                   as legal_address_city_c
    , a.json:LEGAL_ADDRESS_LABEL_C::varchar(240)                  as legal_address_label_c
    , a.json:LEGAL_ADDRESS_POSTAL_CODE_C::varchar(30)             as legal_address_postal_code_c
    , a.json:LEGAL_ADDRESS_STATE_C::varchar(90)                   as legal_address_state_c
    , a.json:LEGAL_STREET_ADDRESS_C::varchar(300)                 as legal_street_address_c
    , a.json:MARITAL_STATUS_C::varchar(765)                       as marital_status_c
    , a.json:MOBILE_PERSONAL_C::varchar(120)                      as mobile_personal_c
    , a.json:NICKNAME_C::varchar(150)                             as nickname_c
    , a.json:OCCUPATION_C::varchar(150)                           as occupation_c
    , a.json:PERSONAL_EMAIL_C::varchar(240)                       as personal_email_c
    , a.json:PREFERRED_CONTACT_METHOD_C::varchar(765)             as preferred_contact_method_c
    , a.json:PREFERRED_CONTACT_TIME_C::varchar(765)               as preferred_contact_time_c
    , a.json:PREFERRED_WEALTH_EMAIL_C::varchar(765)               as preferred_wealth_email_c
    , a.json:BUSINESS_ADDRESS_CITY_C::varchar(300)                as business_address_city_c
    , a.json:BUSINESS_ADDRESS_LABEL_C::varchar(240)               as business_address_label_c
    , a.json:BUSINESS_ADDRESS_POSTAL_CODE_C::varchar(30)          as business_address_postal_code_c
    , a.json:BUSINESS_ADDRESS_STATE_C::varchar(90)                as business_address_state_c
    , a.json:BUSINESS_ADDRESS_C::varchar(300)                     as business_address_c
    , a.json:COLLEGE_GRADUATION_C::date                           as college_graduation_c
    , a.json:DIGITAL_MARKETING_CAMPAIGNS_WEALTH_C::varchar(4099)  as digital_marketing_campaigns_wealth_c
    , a.json:DIGITAL_MARKETING_OPT_OUT_WEALTH_C::boolean          as digital_marketing_opt_out_wealth_c
    , a.json:DIGITAL_MARKETING_OPTIONS_WEALTH_C::varchar(4099)    as digital_marketing_options_wealth_c
    , a.json:TAGS_C::varchar(4099)                                as tags_c
    , a.json:WEDDING_ANNIVERSARY_C::date                          as wedding_anniversary_c
    , a.json:USER_C::varchar(18)                                  as user_c
    , a.json:WEALTH_CONTACT_LIFECYCLE_C::varchar(765)             as wealth_contact_lifecycle_c
    , a.json:RETIREMENT_CONTACT_LIFECYCLE_C::varchar(765)         as retirement_contact_lifecycle_c
    , a.json:LEAD_SOURCE_WEALTH_C::varchar(765)                   as lead_source_wealth_c
    , a.json:ASSET_MANAGEMENT_CONTACT_LIFECYCLE_C::varchar(765)   as asset_management_contact_lifecycle_c
    , a.json:LEAD_AMOUNT_WEALTH_C::number(18 , 2)                 as lead_amount_wealth_c
    , a.json:MARKETING_OWNER_C::varchar(18)                       as marketing_owner_c
    , a.json:CONTACT_TYPE_C::varchar(765)                         as contact_type_c
    , a.json:INDIVIDUAL_INSURANCE_DEATH_BENEFIT_C::number(18 , 2) as individual_insurance_death_benefit_c
    , a.json:MARKETING_OWNER_WEALTH_C::varchar(18)                as marketing_owner_wealth_c
    , a.json:MARKETING_OWNER_RETIREMENT_C::varchar(18)            as marketing_owner_retirement_c
    , a.json:MARKETING_OWNER_ASSET_MGT_C::varchar(18)             as marketing_owner_asset_mgt_c
    , a.json:ROLE_C::varchar(4099)                                as role_c
    , a.json:MH_QUARTERLY_REPORT_VERSION_C::varchar(765)          as mh_quarterly_report_version_c
    , a.json:MH_RBG_COLOR_ASSIGNMENT_C::varchar(765)              as mh_rbg_color_assignment_c
    , a.json:MAILING_LABEL_C::varchar(240)                        as mailing_label_c
    , a.json:MH_TEAM_FILE_LOCATION_C::varchar(600)                as mh_team_file_location_c
    , a.json:SHORT_NOTE_C::varchar(15000)                         as short_note_c
    , a.json:COUNTRY_OF_CITIZENSHIP_C::varchar(765)               as country_of_citizenship_c
    , a.json:ADVISOR_TERMINATION_DATE_C::date                     as advisor_termination_date_c
    , a.json:FIRST_DATE_OF_OFAC_CHECK_C::date                     as first_date_of_ofac_check_c
    , a.json:MOST_RECENT_DATE_OF_OFAC_CHECK_C::date               as most_recent_date_of_ofac_check_c
    , a.json:UNIQUE_ID_C::varchar(90)                             as unique_id_c
    , a.json:DDL_FIRM_ID_C::varchar(765)                          as ddl_firm_id_c
    , a.json:DDL_REP_ID_C::varchar(765)                           as ddl_rep_id_c
    , a.json:SYS_TOPIC_1_C::varchar(765)                          as sys_topic_1_c
    , a.json:SYS_TOPIC_2_C::varchar(765)                          as sys_topic_2_c
    , a.json:SYS_TOPIC_3_C::varchar(765)                          as sys_topic_3_c
    , a.json:COUNTRY_OF_RESIDENCE_C::varchar(765)                 as country_of_residence_c
    , a.json:SYS_MIGRATION_SOURCE_C::varchar(4099)                as sys_migration_source_c
    , a.json:SYS_MIGRATION_ID_C::varchar(765)                     as sys_migration_id_c
    , a.json:MFIT_EXCLUSION_OVERRIDE_C::boolean                   as mfit_exclusion_override_c
    , a.json:NOTIFICATION_ID_C::varchar(90)                       as notification_id_c
    , a.json:MH_PHOTO_C::varchar(98304)                           as mh_photo_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                        as _fivetran_synced
    , a.json:CONTACT_ID_18_C::varchar(3900)                       as contact_id_18_c
    , a.json:CLIENT_AGE_C::double                                 as client_age_c
    , a.json:OCCUPATION_CODE_C::varchar(18)                       as occupation_code_c
    , a.json:RETIRED_C::boolean                                   as retired_c
    , a.json:ORIGINAL_OPPTY_STAGE_C::varchar(765)                 as original_oppty_stage_c
    , a.json:REPORTS_TO_ID::varchar(18)                           as reports_to_id
    , a.json:LEAD_AMOUNT_ASSET_MGT_C::number(18 , 2)              as lead_amount_asset_mgt_c
    , a.json:LEAD_SOURCE_RETIREMENT_C::varchar(765)               as lead_source_retirement_c
    , a.json:LEAD_AMOUNT_RETIREMENT_C::number(18 , 2)             as lead_amount_retirement_c
    , a.json:HAS_OPTED_OUT_OF_FAX::boolean                        as has_opted_out_of_fax
    , a.json:ALTERNATE_EMAIL_C::varchar(240)                      as alternate_email_c
    , a.json:LEAD_SOURCE::varchar(765)                            as lead_source
    , a.json:OUT_OF_OFFICE_C::boolean                             as out_of_office_c
    , a.json:ALLOW_CASES_C::boolean                               as allow_cases_c
    , a.json:LEAD_SOURCE_ASSET_MGT_C::varchar(765)                as lead_source_asset_mgt_c
    , a.json:ADV_CATEGORY_C::varchar(3900)                        as adv_category_c
    , a.json:OPERATIONS_EMPLOYEE_C::boolean                       as operations_employee_c
    , a.json:IMPORT_ID_C::varchar(150)                            as import_id_c
    , a.json:BOCLIENT_DATA_PROJECT_KEY_C::varchar(765)            as boclient_data_project_key_c
    , a.json:EMAIL::varchar(240)                                  as email
    , a.json:HAS_OPTED_OUT_OF_EMAIL::boolean                      as has_opted_out_of_email
    , a.json:PAYEE_TYPE_C::varchar(200)                           as payee_type_c
    , a.json:_FIVETRAN_DELETED::boolean                           as _fivetran_deleted

    , a.effective_at::timestamp                                   as effective_at
    , a._created_at::timestamp                                    as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'contact')
        , source_date_col='a.effective_at'
        , reference_date_col='effective_at') }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                           as is_head_for_day
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                           as is_latest
    , case
        when a._created_at = min(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                           as is_earliest
from {{ source('salesforce_compass', 'contact') }} as a
