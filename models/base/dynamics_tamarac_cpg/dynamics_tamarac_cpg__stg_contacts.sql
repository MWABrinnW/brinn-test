select
    json:ADDRESS_1_ADDRESSID::varchar(200)                as address_1_address_id
    , json:ADDRESS_1_ADDRESSTYPECODE::varchar(200)        as address_1_address_type_code
    , json:ADDRESS_1_CITY::varchar(200)                   as address_1_city
    , json:ADDRESS_1_COMPOSITE::varchar(200)              as address_1_composite
    , json:ADDRESS_1_COUNTRY::varchar(200)                as address_1_country
    , json:ADDRESS_1_LINE_1::varchar(200)                 as address_1_line_1
    , json:ADDRESS_1_LINE_2::varchar(200)                 as address_1_line_2
    , json:ADDRESS_1_LINE_3::varchar(200)                 as address_1_line_3
    , json:ADDRESS_1_NAME::varchar(200)                   as address_1_name
    , json:ADDRESS_1_POSTALCODE::varchar(200)             as address_1_postal_code
    , json:ADDRESS_1_STATEORPROVINCE::varchar(200)        as address_1_state_or_province
    , json:ADDRESS_2_ADDRESSID::varchar(200)              as address_2_address_id
    , json:ADDRESS_2_FREIGHTTERMSCODE::varchar(200)       as address_2_freight_terms_code
    , json:ADDRESS_2_SHIPPINGMETHODCODE::varchar(200)     as address_2_shipping_method_code
    , json:ADDRESS_3_ADDRESSID::varchar(200)              as address_3_address_id
    , json:ADX_CONFIRMREMOVEPASSWORD::boolean             as adx_confirm_remove_password
    , json:ADX_IDENTITY_EMAILADDRESS_1_CONFIRMED::boolean as adx_identity_email_address_1_confirmed
    , json:ADX_IDENTITY_LOCALLOGINDISABLED::boolean       as adx_identity_local_login_disabled
    , json:ADX_IDENTITY_LOCKOUTENABLED::boolean           as adx_identity_lockout_enabled
    , json:ADX_IDENTITY_LOGONENABLED::boolean             as adx_identity_logon_enabled
    , json:ADX_IDENTITY_MOBILEPHONECONFIRMED::boolean     as adx_identity_mobile_phone_confirmed
    , json:ADX_IDENTITY_TWOFACTORENABLED::boolean         as adx_identity_two_factor_enabled
    , json:ADX_PROFILEALERT::boolean                      as adx_profile_alert
    , json:ADX_PROFILEISANONYMOUS::boolean                as adx_profile_is_anonymous
    , json:ANNUALINCOME::decimal(20 , 2)                  as annual_income
    , json:ANNUALINCOME_BASE::decimal(20 , 2)             as annual_income_base
    , json:BIRTHDATE::date                                as birth_date
    , json:CONTACTID::varchar(200)                        as contact_id
    , json:CREATEDON::timestamp_ntz                       as created_at
    , json:CREDITONHOLD::boolean                          as credit_on_hold
    , json:CUSTOMERSIZECODE::varchar(200)                 as customer_size_code
    , json:CUSTOMERTYPECODE::varchar(200)                 as customer_type_code
    , json:DONOTBULKEMAIL::boolean                        as do_not_bulk_email
    , json:DONOTBULKPOSTALMAIL::boolean                   as do_not_bulk_postal_mail
    , json:DONOTEMAIL::boolean                            as do_not_email
    , json:DONOTFAX::boolean                              as do_not_fax
    , json:DONOTPHONE::boolean                            as do_not_phone
    , json:DONOTPOSTALMAIL::boolean                       as do_not_postal_mail
    , json:DONOTSENDMM::boolean                           as do_not_send_mm
    , json:EDUCATIONCODE::varchar(200)                    as education_code
    , effective_at::timestamp_ntz                         as effective_at
    , json:EMAILADDRESS_1::varchar(200)                   as email_address_1
    , json:EMAILADDRESS_2::varchar(200)                   as email_address_2
    , json:EXCHANGERATE::decimal(20 , 6)                  as exchange_rate
    , json:FAMILYSTATUSCODE::varchar(200)                 as family_status_code
    , json:FAX::varchar(200)                              as fax
    , json:FIRSTNAME::varchar(200)                        as first_name
    , json:FOLLOWEMAIL::boolean                           as follow_email
    , json:FULLNAME::varchar(200)                         as full_name
    , json:GENDERCODE::varchar(200)                       as gender_code
    , json:HASCHILDRENCODE::varchar(200)                  as has_children_code
    , json:IMPORTSEQUENCENUMBER::integer                  as import_sequence_number
    , json:ISBACKOFFICECUSTOMER::boolean                  as is_back_office_customer
    , json:JOBTITLE::varchar(200)                         as job_title
    , json:LASTNAME::varchar(200)                         as last_name
    , json:LEADSOURCECODE::varchar(200)                   as lead_source_code
    , json:MARKETINGONLY::boolean                         as marketing_only
    , json:MERGED::boolean                                as merged
    , json:MIDDLENAME::varchar(200)                       as middle_name
    , json:MOBILEPHONE::varchar(200)                      as mobile_phone
    , json:MODIFIEDON::timestamp_ntz                      as modified_at
    , json:MSDYN_DISABLEWEBTRACKING::boolean              as msdyn_disable_web_tracking
    , json:MSDYN_GDPROPTOUT::boolean                      as msdyn_gdprop_to_out
    , json:MSDYN_ISASSISTANTINORGCHART::boolean           as msdyn_is_assistant_in_org_chart
    , json:MSDYN_ISMINOR::boolean                         as msdyn_is_minor
    , json:MSDYN_ISMINORWITHPARENTALCONSENT::boolean      as msdyn_is_minor_with_parental_consent
    , json:MSDYN_ORGCHANGESTATUS::varchar(200)            as msdyn_org_change_status
    , json:NICKNAME::varchar(200)                         as nickname
    , json:PARTICIPATESINWORKFLOW::boolean                as participates_in_workflow
    , json:PREFERREDAPPOINTMENTTIMECODE::varchar(200)     as preferred_appointment_time_code
    , json:PREFERREDCONTACTMETHODCODE::varchar(200)       as preferred_contact_method_code
    , json:PROCESSID::varchar(200)                        as process_id
    , json:SALUTATION::varchar(200)                       as salutation
    , json:SHIPPINGMETHODCODE::varchar(200)               as shipping_method_code
    , json:STATECODE::varchar(200)                        as state_code
    , json:STATUSCODE::varchar(200)                       as status_code
    , json:SUFFIX::varchar(200)                           as suffix
    , json:TAMC_BOARDMEMBER::varchar(200)                 as tamc_board_member
    , json:TAM_ADDRESSUPDATEDFROMPLUGIN::varchar(200)     as tam_address_updated_from_plugin
    , json:TAM_ADDRESS_1::varchar(200)                    as tam_address_1
    , json:TAM_AGEBYENDOFYEAR::integer                    as tam_age_by_end_of_year
    , json:TAM_BIRTHDAYOFMONTH::integer                   as tam_birthday_of_month
    , json:TAM_BIRTHMONTH::integer                        as tam_birth_month
    , json:TAM_BIRTHYEAR::integer                         as tam_birth_year
    , json:TAM_COI::varchar(200)                          as tam_coi
    , json:TAM_COMPANY::varchar(200)                      as tam_company
    , json:TAM_CONTACTGUID::varchar(200)                  as tam_contact_guid
    , json:TAM_CREATEINAVREQUEST::boolean                 as tam_create_in_av_request
    , json:TAM_CURRENTAGE::integer                        as tam_current_age
    , json:TAM_DECEASEDDATE::date                         as tam_deceased_date
    , json:TAM_DRIVERSLICENSEISSUEDATE::date              as tam_drivers_license_issue_date
    , json:TAM_DRIVERSLICENSENUMBER::varchar(200)         as tam_drivers_license_number
    , json:TAM_DRIVERSLICENSESTATEOFISSUE::varchar(200)   as tam_drivers_license_state_of_issue
    , json:TAM_DRIVERSLICEXPDATE::date                    as tam_drivers_license_exp_date
    , json:TAM_EMAILTYPE_1::varchar(200)                  as tam_email_type_1
    , json:TAM_EMAILTYPE_2::varchar(200)                  as tam_email_type_2
    , json:TAM_ISPRIMARYCONTACT::boolean                  as tam_is_primary_contact
    , json:TAM_ISSECONDARYCONTACT::boolean                as tam_is_secondary_contact
    , json:TAM_LINKEDTOADVISORVIEW::boolean               as tam_linked_to_advisor_view
    , json:TAM_MAILING_ADDRESS_OPTION::varchar(200)       as tam_mailing_address_option
    , json:TAM_NEXTBIRTHDAY::date                         as tam_next_birthday
    , json:TAM_PHYSICAL_ADDRESS_OPTION::varchar(200)      as tam_physical_address_option
    , json:TAM_PORTALSTATUS::varchar(200)                 as tam_portal_status
    , json:TAM_PREFERREDDELIVERYMETHOD::varchar(200)      as tam_preferred_delivery_method
    , json:TAM_PREFERREDPHONE::varchar(200)               as tam_preferred_phone
    , json:TAM_PREFIX::varchar(200)                       as tam_prefix
    , json:TAM_RETIRED::boolean                           as tam_retired
    , json:TAM_SSN::varchar(200)                          as tam_ssn
    , json:TAM_TERMINATEDDATE::date                       as tam_terminated_date
    , json:TAM_TOTALSPOUSEAGE::integer                    as tam_total_spouse_age
    , json:TAM_TWOBIRTHDAYS::boolean                      as tam_two_birthdays
    , json:TAM_USEALTERNATEMODEL::boolean                 as tam_use_alternate_model
    , json:TAM_USEPRIMARYADDRESS::boolean                 as tam_use_primary_address
    , json:TAM_USESECONDARYADDRESS::boolean               as tam_use_secondary_address
    , json:TAM_USETHISASPRIMARYADDRESS::boolean           as tam_use_this_as_primary_address
    , json:TELEPHONE_1::varchar(200)                      as telephone_1
    , json:TELEPHONE_2::varchar(200)                      as telephone_2
    , json:TELEPHONE_3::varchar(200)                      as telephone_3
    , json:TERRITORYCODE::varchar(200)                    as territory_code
    , json:TIMEZONERULEVERSIONNUMBER::integer             as time_zone_rule_version_number
    , json:VERSIONNUMBER::integer                         as version_number
    , json:YOMIFULLNAME::varchar(200)                     as youi_full_name
    , json:_CREATEDBY_VALUE::varchar(200)                 as _created_by_value
    , json:_FIVETRAN_DELETED::integer                     as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz                as _fivetran_synced
    , json:_MASTERID_VALUE::varchar(200)                  as _master_id_value
    , json:_MODIFIEDBY_VALUE::varchar(200)                as _modified_by_value
    , json:_MODIFIEDONBEHALFBY_VALUE::varchar(200)        as _modified_on_behalf_by_value
    , json:_MSA_MANAGINGPARTNERID_VALUE::varchar(200)     as _msa_managing_partner_id_valu
    , json:_ORIGINATINGLEADID_VALUE::varchar(200)         as _originating_lead_id_value
    , json:_OWNERID_VALUE::varchar(200)                   as _owner_id_value
    , json:_OWNINGBUSINESSUNIT_VALUE::varchar(200)        as _owning_business_unit_value
    , json:_OWNINGUSER_VALUE::varchar(200)                as _owning_user_value
    , json:_PARENTCUSTOMERID_VALUE::varchar(200)          as _parent_customer_id_value
    , json:_TAM_ADDRESS_1_ID_VALUE::varchar(200)          as _tam_address_1_id_value
    , _created_at::timestamp_ntz                          as _created_at
    , json:_TRANSACTIONCURRENCYID_VALUE::varchar(200)     as _transaction_currency_id_value
    , {{ col_is_head(
        reference = source('dynamics_tamarac_cpg', 'contact'),
        reference_date_col = 'effective_at::date',
        source_date_col = 'effective_at::date') }}
    , case
        when _created_at = max(_created_at) over (
                partition by effective_at::date
            )
            then 1
        else 0
    end::int                                              as is_head_for_day
from {{ source('dynamics_tamarac_cpg', 'contact') }}
