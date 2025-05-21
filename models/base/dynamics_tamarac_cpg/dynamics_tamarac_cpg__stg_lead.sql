{% set src = source('dynamics_tamarac_cpg', 'lead') %}

select
    nullif(json:"leadid"::text , '')                                                                  as lead_id
    , nullif(json:"_CREATEDBY_VALUE"::text , '')                                                      as _created_by
    , nullif(json:"_CREATEDBY_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _created_by_logical_name
    , nullif(json:"_MASTERID_VALUE"::text , '')                                                       as _master_id
    , nullif(json:"_MASTERID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')              as _master_id_logical_name
    , nullif(json:"_MODIFIEDBY_VALUE"::text , '')                                                     as _modified_by
    , nullif(json:"_MODIFIEDBY_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _modified_by_logical_name
    , nullif(json:"_MODIFIEDONBEHALFBY_VALUE"::text , '')                                             as _modified_on_behalf_by
    , nullif(json:"_MODIFIEDONBEHALFBY_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _modified_on_behalf_by_logical_name
    , nullif(json:"_OWNERID_VALUE"::text , '')                                                        as _owner_id
    , nullif(json:"_OWNERID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')               as _owner_id_logical_name
    , nullif(json:"_OWNINGBUSINESSUNIT_VALUE"::text , '')                                             as _owning_business_unit
    , nullif(json:"_OWNINGBUSINESSUNIT_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _owning_business_unit_logical_name
    , nullif(json:"_OWNINGUSER_VALUE"::text , '')                                                     as _owning_user
    , nullif(json:"_OWNINGUSER_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _owning_user_logical_name
    , nullif(json:"_PARENTACCOUNTID_VALUE"::text , '')                                                as _parent_account_id
    , nullif(json:"_PARENTACCOUNTID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _parent_account_id_logical_name
    , nullif(json:"_PARENTCONTACTID_VALUE"::text , '')                                                as _parent_contact_id
    , nullif(json:"_PARENTCONTACTID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _parent_contact_id_logical_name
    , nullif(json:"_TAM_ADDRESS_1_ID_VALUE"::text , '')                                               as _tam_address_1_id
    , nullif(json:"_TAM_ADDRESS_1_ID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _tam_address_1_id_logical_name
    , nullif(json:"_TAM_CSAID_VALUE"::text , '')                                                      as _tamc_said
    , nullif(json:"_TAM_CSAID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')             as _tamc_said_logical_name
    , nullif(json:"_TAM_LEADSOURCEID_VALUE"::text , '')                                               as _tam_lead_source_id
    , nullif(json:"_TAM_LEADSOURCEID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _tam_lead_source_id_logical_name
    , nullif(json:"_TAM_REFERREDBYID_VALUE"::text , '')                                               as _tam_referred_by_id
    , nullif(json:"_TAM_REFERREDBYID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _tam_referred_by_id_logical_name
    , nullif(json:"_TAM_REGION_VALUE"::text , '')                                                     as _tam_region
    , nullif(json:"_TAM_REGION_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _tam_region_logical_name
    , nullif(json:"_TRANSACTIONCURRENCYID_VALUE"::text , '')
        as _transaction_currency_id
    , nullif(json:"_TRANSACTIONCURRENCYID_VALUE_MICROSOFT_DYNAMICS_CRM_LOOKUPLOGICALNAME"::text , '')
        as _transaction_currency_id_logical_name
    , nullif(json:"ADDRESS_1_ADDRESSID"::text , '')                                                   as address_1_address_id
    , nullif(json:"ADDRESS_1_ADDRESSTYPECODE"::text , '')::int
        as address_1_address_typecode
    , nullif(json:"ADDRESS_1_CITY"::text , '')                                                        as address_1_city
    , nullif(json:"ADDRESS_1_COMPOSITE"::text , '')                                                   as address_1_composite
    , nullif(json:"ADDRESS_1_COUNTRY"::text , '')                                                     as address_1_country
    , nullif(json:"ADDRESS_1_COUNTY"::text , '')                                                      as address_1_county
    , nullif(json:"ADDRESS_1_FAX"::text , '')                                                         as address_1_fax
    , nullif(json:"ADDRESS_1_LATITUDE"::text , '')                                                    as address_1_latitude
    , nullif(json:"ADDRESS_1_LINE_1"::text , '')                                                      as address_1_line_1
    , nullif(json:"ADDRESS_1_LINE_2"::text , '')                                                      as address_1_line_2
    , nullif(json:"ADDRESS_1_LINE_3"::text , '')                                                      as address_1_line_3
    , nullif(json:"ADDRESS_1_LONGITUDE"::text , '')                                                   as address_1_longitude
    , nullif(json:"ADDRESS_1_NAME"::text , '')                                                        as address_1_name
    , nullif(json:"ADDRESS_1_POSTALCODE"::text , '')                                                  as address_1_postal_code
    , nullif(json:"ADDRESS_1_POSTOFFICEBOX"::text , '')
        as address_1_post_office_box
    , nullif(json:"ADDRESS_1_SHIPPINGMETHODCODE"::text , '')
        as address_1_shipping_method_code
    , nullif(json:"ADDRESS_1_STATEORPROVINCE"::text , '')
        as address_1_state_or_province
    , nullif(json:"ADDRESS_1_TELEPHONE_1"::text , '')                                                 as address_1_telephone_1
    , nullif(json:"ADDRESS_1_TELEPHONE_2"::text , '')                                                 as address_1_telephone_2
    , nullif(json:"ADDRESS_1_TELEPHONE_3"::text , '')                                                 as address_1_telephone_3
    , nullif(json:"ADDRESS_1_UPSZONE"::text , '')                                                     as address_1_ups_zone
    , nullif(json:"ADDRESS_1_UTCOFFSET"::text , '')                                                   as address_1_utc_offset
    , nullif(json:"ADDRESS_2_ADDRESSID"::text , '')                                                   as address_2_address_id
    , nullif(json:"ADDRESS_2_ADDRESSTYPECODE"::text , '')::int
        as address_2_address_typecode
    , nullif(json:"ADDRESS_2_CITY"::text , '')                                                        as address_2_city
    , nullif(json:"ADDRESS_2_COMPOSITE"::text , '')                                                   as address_2_composite
    , nullif(json:"ADDRESS_2_COUNTRY"::text , '')                                                     as address_2_country
    , nullif(json:"ADDRESS_2_COUNTY"::text , '')                                                      as address_2_county
    , nullif(json:"ADDRESS_2_FAX"::text , '')                                                         as address_2_fax
    , nullif(json:"ADDRESS_2_LATITUDE"::text , '')                                                    as address_2_latitude
    , nullif(json:"ADDRESS_2_LINE_1"::text , '')                                                      as address_2_line_1
    , nullif(json:"ADDRESS_2_LINE_2"::text , '')                                                      as address_2_line_2
    , nullif(json:"ADDRESS_2_LINE_3"::text , '')                                                      as address_2_line_3
    , nullif(json:"ADDRESS_2_LONGITUDE"::text , '')                                                   as address_2_longitude
    , nullif(json:"ADDRESS_2_NAME"::text , '')                                                        as address_2_name
    , nullif(json:"ADDRESS_2_POSTALCODE"::text , '')                                                  as address_2_postal_code
    , nullif(json:"ADDRESS_2_POSTOFFICEBOX"::text , '')
        as address_2_post_office_box
    , nullif(json:"ADDRESS_2_SHIPPINGMETHODCODE"::text , '')
        as address_2_shipping_method_code
    , nullif(json:"ADDRESS_2_STATEORPROVINCE"::text , '')
        as address_2_state_or_province
    , nullif(json:"ADDRESS_2_TELEPHONE_1"::text , '')                                                 as address_2_telephone_1
    , nullif(json:"ADDRESS_2_TELEPHONE_2"::text , '')                                                 as address_2_telephone_2
    , nullif(json:"ADDRESS_2_TELEPHONE_3"::text , '')                                                 as address_2_telephone_3
    , nullif(json:"ADDRESS_2_UPSZONE"::text , '')                                                     as address_2_ups_zone
    , nullif(json:"ADDRESS_2_UTCOFFSET"::text , '')                                                   as address_2_utc_offset
    , nullif(json:"COMPANYNAME"::text , '')                                                           as company_name
    , to_boolean(nullif(json:"CONFIRMINTEREST"::text , ''))::int                                      as confirm_interest
    , nullif(json:"CREATEDON"::text , '')                                                             as created_on
    , to_boolean(nullif(json:"DECISIONMAKER"::text , ''))::int                                        as decision_maker
    , to_boolean(nullif(json:"DONOTBULKEMAIL"::text , ''))::int                                       as do_not_bulk_email
    , to_boolean(nullif(json:"DONOTEMAIL"::text , ''))::int                                           as do_not_email
    , to_boolean(nullif(json:"DONOTFAX"::text , ''))::int                                             as do_not_fax
    , to_boolean(nullif(json:"DONOTPHONE"::text , ''))::int                                           as do_not_phone
    , to_boolean(nullif(json:"DONOTPOSTALMAIL"::text , ''))::int                                      as do_not_postal_mail
    , to_boolean(nullif(json:"DONOTSENDMM"::text , ''))::int                                          as do_not_send_mm
    , nullif(json:"EMAILADDRESS_1"::text , '')                                                        as email_address_1
    , nullif(json:"EMAILADDRESS_2"::text , '')                                                        as email_address_2
    , nullif(json:"EMAILADDRESS_3"::text , '')                                                        as email_address_3
    , nullif(json:"ESTIMATEDAMOUNT"::text , '')::int                                                  as estimated_amount
    , nullif(json:"ESTIMATEDAMOUNT_BASE"::text , '')::int                                             as estimated_amount_base
    , nullif(json:"ESTIMATEDCLOSEDATE"::text , '')::date                                              as estimated_close_date
    , to_boolean(nullif(json:"EVALUATEFIT"::text , ''))::int                                          as evaluate_fit
    , nullif(json:"EXCHANGERATE"::text , '')::int                                                     as exchange_rate
    , nullif(json:"FIRSTNAME"::text , '')                                                             as first_name
    , to_boolean(nullif(json:"FOLLOWEMAIL"::text , ''))::int                                          as follow_email
    , nullif(json:"FULLNAME"::text , '')                                                              as full_name
    , nullif(json:"JOBTITLE"::text , '')                                                              as job_title
    , nullif(json:"LASTNAME"::text , '')                                                              as last_name
    , nullif(json:"LEADQUALITYCODE"::text , '')::int                                                  as lead_quality_code
    , to_boolean(nullif(json:"MERGED"::text , ''))::int                                               as merged
    , nullif(json:"MOBILEPHONE"::text , '')                                                           as mobile_phone
    , nullif(json:"MODIFIEDON"::text , '')                                                            as modified_on
    , to_boolean(nullif(json:"MSDYN_GDPROPTOUT"::text , ''))::int                                     as msd_yn_gdpr_opt_out
    , to_boolean(nullif(json:"PARTICIPATESINWORKFLOW"::text , ''))::int
        as participates_in_workflow
    , nullif(json:"PREFERREDCONTACTMETHODCODE"::text , '')::int
        as preferred_contact_method_code
    , nullif(json:"PRIORITYCODE"::text , '')::int                                                     as priority_code
    , nullif(json:"PROCESSID"::text , '')                                                             as processid
    , nullif(json:"SALESSTAGECODE"::text , '')::int                                                   as sales_stage_code
    , nullif(json:"SALUTATION"::text , '')                                                            as salutation
    , nullif(json:"STATECODE"::text , '')::int                                                        as state_code
    , nullif(json:"STATUSCODE"::text , '')::int                                                       as status_code
    , nullif(json:"SUBJECT"::text , '')                                                               as subject
    , nullif(json:"TAM_ADDRESS_1"::text , '')                                                         as tam_address_1
    , nullif(json:"TAM_ADDRESS_1_line4"::text , '')                                                   as tam_address_1_line4
    , nullif(json:"TAM_ADDRESS_1_line5"::text , '')                                                   as tam_address_1_line5
    , nullif(json:"TAM_ADDRESS_1_line6"::text , '')                                                   as tam_address_1_line6
    , nullif(json:"TAM_ADDRESS_2"::text , '')                                                         as tam_address_2
    , nullif(json:"TAM_ADDRESS_2_line4"::text , '')                                                   as tam_address_2_line4
    , nullif(json:"TAM_ADDRESS_2_line5"::text , '')                                                   as tam_address_2_line5
    , nullif(json:"TAM_ADDRESS_2_line6"::text , '')                                                   as tam_address_2_line6
    , nullif(json:"TAM_ADDRESSNAMELINE"::text , '')                                                   as tam_address_name_line
    , nullif(json:"TAM_ADDRESSUPDATEDFROMPLUGIN"::text , '')
        as tam_address_updated_from_plugin
    , nullif(json:"TAM_ALERT"::text , '')                                                             as tam_alert
    , nullif(json:"TAM_BIRTHDATE"::text , '')::date                                                   as tam_birthdate
    , nullif(json:"TAM_COMPANY"::text , '')                                                           as tam_company
    , nullif(json:"TAM_DOCUMENTLINK"::text , '')                                                      as tam_document_link
    , nullif(json:"TAM_EMAILTYPE_1"::text , '')::int                                                  as tam_email_type_1
    , nullif(json:"TAM_EMAILTYPE_2"::text , '')::int                                                  as tam_email_type_2
    , nullif(json:"TAM_FORMTYPE"::text , '')::int                                                     as tam_form_type
    , nullif(json:"TAM_GENDER"::text , '')::int                                                       as tam_gender
    , nullif(json:"TAM_INITIALMEETING"::text , '')::date                                              as tam_initial_meeting
    , nullif(json:"TAM_LASTAPPOINTMENT"::text , '')::date                                             as tam_last_appointment
    , nullif(json:"TAM_LASTCALL"::text , '')::date                                                    as tam_last_call
    , nullif(json:"TAM_LASTCONTACTED"::text , '')::date                                               as tam_last_contacted
    , nullif(json:"TAM_LEADDESCRIPTION"::text , '')                                                   as tam_lead_description
    , nullif(json:"TAM_LEADSTAGE"::text , '')::int                                                    as tam_lead_stage
    , nullif(json:"TAM_MARITALSTATUS"::text , '')::int                                                as tam_marital_status
    , nullif(json:"TAM_POTENTIALAUM"::text , '')::int                                                 as tam_potential_aum
    , nullif(json:"TAM_POTENTIALAUM_BASE"::text , '')::int                                            as tam_potential_aum_base
    , nullif(json:"TAM_PREFERREDPHONE"::text , '')::int                                               as tam_preferred_phone
    , nullif(json:"TAM_SECONDARYBIRTHDATE"::text , '')::date                                          as tam_secondary_birthdate
    , nullif(json:"TAM_SECONDARYBUSINESSPHONE"::text , '')
        as tam_secondary_business_phone
    , nullif(json:"TAM_SECONDARYCOMPANY"::text , '')                                                  as tam_secondary_company
    , nullif(json:"TAM_SECONDARYEMAILADDRESS_1"::text , '')
        as tam_secondary_email_address_1
    , nullif(json:"TAM_SECONDARYEMAILADDRESS_2"::text , '')
        as tam_secondary_email_address_2
    , nullif(json:"TAM_SECONDARYEMAILTYPE_1"::text , '')::int
        as tam_secondary_email_type_1
    , nullif(json:"TAM_SECONDARYFIRSTNAME"::text , '')
        as tam_secondary_first_name
    , nullif(json:"TAM_SECONDARYGENDER"::text , '')::int                                              as tam_secondary_gender
    , nullif(json:"TAM_SECONDARYHOMEPHONE"::text , '')
        as tam_secondary_home_phone
    , nullif(json:"TAM_SECONDARYJOBTITLE"::text , '')                                                 as tam_secondary_job_title
    , nullif(json:"TAM_SECONDARYLASTNAME"::text , '')                                                 as tam_secondary_last_name
    , nullif(json:"TAM_SECONDARYMARITALSTATUS"::text , '')::int
        as tam_secondary_marital_status
    , nullif(json:"TAM_SECONDARYMOBILEPHONE"::text , '')
        as tam_secondary_mobile_phone
    , nullif(json:"TAM_SECONDARYOTHERPHONE"::text , '')
        as tam_secondary_other_phone
    , nullif(json:"TAM_SECONDARYPREFERREDPHONE"::text , '')::int
        as tam_secondary_preferred_phone
    , nullif(json:"TAM_SECONDARYSSN"::text , '')                                                      as tam_secondary_ssn
    , nullif(json:"TAM_SSN"::text , '')                                                               as tam_ssn
    , nullif(json:"TAM_STATEOFPRIMARYRESIDENCE"::text , '')::int
        as tam_state_of_primary_residence
    , nullif(json:"TELEPHONE_1"::text , '')                                                           as telephone_1
    , nullif(json:"TELEPHONE_2"::text , '')                                                           as telephone_2
    , nullif(json:"TELEPHONE_3"::text , '')                                                           as telephone_3
    , nullif(json:"TIMEZONERULEVERSIONNUMBER"::text , '')::int
        as timezone_rule_version_number
    , nullif(json:"VERSIONNUMBER"::text , '')::int                                                    as version_number
    , nullif(json:"WEBSITEURL"::text , '')                                                            as website_url
    , nullif(json:"YOMIFULLNAME"::text , '')                                                          as yomi_full_name

    , to_boolean(nullif(json:"_FIVETRAN_DELETED"::text , ''))::int                                    as _fivetran_deleted
    , nullif(json:"_FIVETRAN_SYNCED"::text , '')::timestamp_ntz                                       as _fivetran_synced
    , _created_at::timestamp_ntz                                                                      as _created_at
    , {{ col_is_head(reference = src,
            reference_date_col = 'effective_at::date',
            source_date_col = 'effective_at::date') }}
    , (dense_rank() over (
        partition by effective_at::date
        order by date_trunc('second' , _created_at) desc
    ) = 1)::int                                                                                       as is_head_for_day
from {{ src }}
