select
    json:ID::text                                                 as id
    , json:IS_DELETED::boolean                                    as is_deleted
    , json:MASTER_RECORD_ID::text                                 as master_record_id
    , json:IS_PERSON_ACCOUNT::boolean                             as is_person_account
    , json:LAST_NAME::text                                        as last_name
    , json:FIRST_NAME::text                                       as first_name
    , json:SALUTATION::text                                       as salutation
    , json:NAME::text                                             as name
    , json:RECORD_TYPE_ID::text                                   as record_type_id
    , json:OWNER_ID::text                                         as owner_id
    , json:CREATED_DATE::timestamp_tz                             as created_date
    , json:CREATED_BY_ID::text                                    as created_by_id
    , json:LAST_MODIFIED_DATE::timestamp_tz                       as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text                              as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamp_tz                          as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                               as last_activity_date
    , json:LAST_CUREQUEST_DATE::timestamp_tz                      as last_curequest_date
    , json:LAST_CUUPDATE_DATE::timestamp_tz                       as last_cuupdate_date
    , json:LAST_VIEWED_DATE::timestamp_tz                         as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamp_tz                     as last_referenced_date
    , json:EMAIL_BOUNCED_REASON::text                             as email_bounced_reason
    , json:EMAIL_BOUNCED_DATE::timestamp_tz                       as email_bounced_date
    , json:IS_EMAIL_BOUNCED::boolean                              as is_email_bounced
    , json:PHOTO_URL::text                                        as photo_url
    , json:JIGSAW_CONTACT_ID::text                                as jigsaw_contact_id
    , json:IS_PRIORITY_RECORD::boolean                            as is_priority_record
    , json:CONTACT_SOURCE::text                                   as contact_source
    , json:CRD_NO_C::text                                         as crd_no_c
    , json:_FIVETRAN_DELETED::boolean                             as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz                         as _fivetran_synced
    , json:PRACTIFI_RMD_DATE_C::date                              as practifi_rmd_date_c
    , json:PRACTIFI_CTCT_CONTACT_ID_C::text                       as practifi_ctct_contact_id_c
    , json:PRACTIFI_PREFERRED_CONTACT_METHODS_C::text             as practifi_preferred_contact_methods_c
    , json:PRACTIFI_WORK_PHONE_C::text                            as practifi_work_phone_c
    , json:PRACTIFI_INCOME_C::number(18 , 10)                     as practifi_income_c
    , json:PRACTIFI_BIRTH_NAME_C::text                            as practifi_birth_name_c
    , json:PRACTIFI_DEFER_AUTOMATION_C::boolean                   as practifi_defer_automation_c
    , json:PRACTIFI_SET_AS_CREATED_DATE_C::timestamp_tz           as practifi_set_as_created_date_c
    , json:PRACTIFI_REPLACE_MAILING_NAME_WITH_C::text             as practifi_replace_mailing_name_with_c
    , json:INDIVIDUAL_ID::text                                    as individual_id
    , json:PRACTIFI_COUNTRY_OF_ORIGIN_C::text                     as practifi_country_of_origin_c
    , json:PRACTIFI_EXTERNAL_ID_4_C::text                         as practifi_external_id_4_c
    , json:PRACTIFI_CITIZENSHIP_STATUS_C::text                    as practifi_citizenship_status_c
    , json:PRACTIFI_EXTERNAL_ID_C::text                           as practifi_external_id_c
    , json:PRACTIFI_EXTERNAL_ID_2_C::text                         as practifi_external_id_2_c
    , json:PRACTIFI_MIDDLE_NAME_C::text                           as practifi_middle_name_c
    , json:PRACTIFI_TAX_ID_NUMBER_C::text                         as practifi_tax_id_number_c
    , json:PRACTIFI_SHARING_SCOPE_2_C::text                       as practifi_sharing_scope_2_c
    , json:PRACTIFI_SHARING_SCOPE_4_C::text                       as practifi_sharing_scope_4_c
    , json:PRACTIFI_OCCUPATION_C::text                            as practifi_occupation_c
    , json:PRACTIFI_MARITAL_STATUS_C::text                        as practifi_marital_status_c
    , json:PRACTIFI_DATE_OF_DEATH_C::date                         as practifi_date_of_death_c
    , json:PRACTIFI_TOPICS_C::text                                as practifi_topics_c
    , json:PRACTIFI_PREFERRED_NAME_C::text                        as practifi_preferred_name_c
    , json:PRACTIFI_RELATED_DIVISION_C::text                      as practifi_related_division_c
    , json:PRACTIFI_STATE_OF_RESIDENCE_C::text                    as practifi_state_of_residence_c
    , json:PRACTIFI_COUNTRY_OF_RESIDENCE_C::text                  as practifi_country_of_residence_c
    , json:PRACTIFI_DATE_OF_MARRIAGE_C::date                      as practifi_date_of_marriage_c
    , json:PRACTIFI_GENDER_C::text                                as practifi_gender_c
    , json:PRACTIFI_ANTICIPATED_RETIREMENT_DATE_C::date           as practifi_anticipated_retirement_date_c
    , json:PRACTIFI_ENVESTNET_HANDLE_C::text                      as practifi_envestnet_handle_c
    , json:PRACTIFI_MAILING_LABEL_C::text                         as practifi_mailing_label_c
    , json:PRACTIFI_EXTERNAL_ID_3_C::text                         as practifi_external_id_3_c
    , json:PRACTIFI_DISPLAY_COUNTRY_C::boolean                    as practifi_display_country_c
    , json:PRACTIFI_TAX_RESIDENT_STATUS_C::text                   as practifi_tax_resident_status_c
    , json:PRACTIFI_ALTERNATE_EMAIL_C::text                       as practifi_alternate_email_c
    , json:PRACTIFI_EXTERNAL_ID_1_C::text                         as practifi_external_id_1_c
    , json:PRACTIFI_EXCLUDE_POSTAL_ADDRESS_FROM_SYNC_C::boolean   as practifi_exclude_postal_address_from_sync_c
    , json:PRACTIFI_BIRTH_PLACE_C::text                           as practifi_birth_place_c
    , json:PRACTIFI_SMOKING_STATUS_C::text                        as practifi_smoking_status_c
    , json:PRACTIFI_ACTUAL_RETIREMENT_DATE_C::date                as practifi_actual_retirement_date_c
    , json:PRACTIFI_BATCH_C::text                                 as practifi_batch_c
    , json:PRACTIFI_EMPLOYMENT_STATUS_C::text                     as practifi_employment_status_c
    , json:PRACTIFI_PRIMARY_ENTITY_C::text                        as practifi_primary_entity_c
    , json:PRACTIFI_EXCLUDE_LOCATION_ADDRESS_FROM_SYNC_C::boolean as practifi_exclude_location_address_from_sync_c
    , json:PRACTIFI_PREFERRED_PHONE_C::text                       as practifi_preferred_phone_c
    , json:PRACTIFI_SHARING_SCOPE_3_C::text                       as practifi_sharing_scope_3_c
    , json:PRACTIFI_SHARING_SCOPE_5_C::text                       as practifi_sharing_scope_5_c
    , json:PRACTIFI_PREFERRED_EMAIL_C::text                       as practifi_preferred_email_c
    , json:PRACTIFI_SUFFIX_C::text                                as practifi_suffix_c
    , json:PRACTIFI_DEPENDANT_UNTIL_AGE_C::float                  as practifi_dependant_until_age_c
    , json:PRACTIFI_IDENTITY_DOCUMENT_C::text                     as practifi_identity_document_c
    , json:PRACTIFI_DISPLAY_EMPLOYER_AND_TITLE_C::boolean         as practifi_display_employer_and_title_c
    , json:PRACTIFI_COUNTRY_OF_CITIZENSHIP_C::text                as practifi_country_of_citizenship_c
    , json:PRACTIFI_SHARING_SCOPE_C::text                         as practifi_sharing_scope_c
    , json:PRACTIFI_EMPLOYER_C::text                              as practifi_employer_c
    , json:HS_ANALYTICS_SOURCE_DATA_1_C::text                     as hs_analytics_source_data_1_c
    , json:LIFECYCLE_STAGE_C::text                                as lifecycle_stage_c
    , json:IP_COUNTRY_C::text                                     as ip_country_c
    , json:BUSINESS_UNIT_C::text                                  as business_unit_c
    , json:HS_ANALYTICS_SOURCE_C::text                            as hs_analytics_source_c
    , json:LAST_CONTACTED_C::timestamp_tz                         as last_contacted_c
    , json:REGISTRATION_STATUS_C::text                            as registration_status_c
    , json:HS_ANALYTICS_SOURCE_DATA_2_C::text                     as hs_analytics_source_data_2_c
    , json:HS_LEAD_STATUS_C::text                                 as hs_lead_status_c
    , json:HUBSPOT_SCORE_C::float                                 as hubspot_score_c
    , json:ASSETS_UNDER_MANAGEMENT_C::number(18 , 10)             as assets_under_management_c
    , json:HS_MARKETABLE_STATUS_C::boolean                        as hs_marketable_status_c
    , json:ARE_YOU_A_C::text                                      as are_you_a_c
    , json:HS_LEAD_SOURCE_C::text                                 as hs_lead_source_c
    , 'salesforce'::text                                          as system_name
    , 'igo'::text                                                 as system_instance
    , system_name || '__' || system_instance                      as system_key
    , effective_at                                                as effective_at
    , _created_at                                                 as _created_at
    , {{ col_is_head(
      reference=source('salesforce_igo', 'contact'),
      source_date_col='effective_at',
      reference_date_col='effective_at'
      ) }}
from {{ source('salesforce_igo', 'contact') }}
