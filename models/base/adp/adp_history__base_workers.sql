
select
    JSON                                                                                                            as json
  , JSON:associateOID::string                                                                                       as associate_oid
  , JSON:workerID.idValue::string                                                                                   as employee_id
  , JSON:workerStatus.statusCode.codeValue::string                                                                  as employee_status
  , JSON:person.legalName.givenName::string                                                                         as legal_name_first 
  , JSON:person.legalName.middleName::string                                                                        as legal_name_middle
  , JSON:person.legalName.familyName1::string                                                                       as legal_name_last  
  , JSON:person.legalName.formattedName::string                                                                     as legal_name_full  
  , JSON:person.legalName.nickName::string                                                                          as preferred_name   
  , JSON:person.legalName.generationAffixCode.shortName::string                                                     as legal_name_suffix
  , JSON:person.birthDate::date                                                                                     as birth_date
  , JSON:person.genderCode.codeValue::string                                                                        as gender_code
  , JSON:person.genderCode.shortName::string                                                                        as gender_name
  , JSON:person.communication.emails[0].emailUri::string                                                            as personal_email
  , JSON:person.communication.landlines[0].formattedNumber::string                                                  as personal_phone
  , JSON:person.communication.mobiles[0].formattedNumber::string                                                    as personal_cell_phone
  , JSON:person.legalAddress.lineOne::string                                                                        as legal_address_line1
  , JSON:person.legalAddress.lineTwo::string                                                                        as legal_address_line2
  , JSON:person.legalAddress.cityName::string                                                                       as legal_address_city
  , JSON:person.legalAddress.countrySubdivisionLevel1.codeValue::string                                             as legal_address_state_abb
  , JSON:person.legalAddress.countrySubdivisionLevel1.shortName::string                                             as legal_address_state_name
  , JSON:person.legalAddress.postalCode::string                                                                     as legal_address_zip_code
  , JSON:person.legalAddress.countryCode::string                                                                    as legal_address_country
  , JSON:person.otherPersonalAddresses[0].lineOne::string                                                           as other_address_line1
  , JSON:person.otherPersonalAddresses[0].lineTwo::string                                                           as other_address_line2
  , JSON:person.otherPersonalAddresses[0].cityName::string                                                          as other_address_city
  , JSON:person.otherPersonalAddresses[0].countrySubdivisionLevel1.codeValue::string                                as other_address_state_abb
  , JSON:person.otherPersonalAddresses[0].countrySubdivisionLevel1.shortName::string                                as other_address_state_name
  , JSON:person.otherPersonalAddresses[0].postalCode::string                                                        as other_address_zip_code
  , JSON:person.otherPersonalAddresses[0].countryCode::string                                                       as other_address_country
  , iff(JSON:person.raceCode.shortName = '', JSON:person.raceCode.longName,
        JSON:person.raceCode.shortName)::string                                                                     as eeo_ethnicity
  , JSON:person.raceCode.identificationMethodCode.shortName::string                                                 as eeo_identification_method
  , JSON:person.highestEducationLevelCode.codeValue::string                                                         as education
  , JSON:businessCommunication.emails[0].emailUri::string                                                           as work_email
  , JSON:businessCommunication.landlines[0].formattedNumber::string                                                 as work_phone
  , JSON:businessCommunication.mobiles[0].formattedNumber::string                                                   as work_cell_phone
  , JSON:workerDates.originalHireDate::date                                                                         as original_hire_date
  , JSON:workerDates.rehireDate::date                                                                               as rehire_date
  , JSON:workerDates.terminationDate::date                                                                          as final_termination_date
  , JSON:customFieldGroup.stringFields[0].stringValue::string                                                       as reporting_office
  , JSON:customFieldGroup.stringFields[1].stringValue::string                                                       as hire_details
  , JSON:customFieldGroup.stringFields[2].stringValue::string                                                       as source
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('adp', 'worker_json_history') }}) then 1
        else 0 end                                                                                                  as is_head
  , record_datetime::timestamp                                                                                      as effective_at
  , record_datetime::timestamp                                                                                      as _created_at
  , row_number() over(partition by JSON:associateOID::string, record_datetime::date order by record_datetime desc)::int  as rn
from {{ source('adp', 'worker_json_history') }}
where record_datetime::date >= '8/11/2021'

union all

select
    null                                                                                                         as json
  , associateoid                                                                                                 as associate_oid
  , workerid_idvalue                                                                                             as employee_id
  , workerstatus_statuscode_codevalue                                                                            as employee_status
  , person_legalname_givenname                                                                                   as legal_name_first 
  , person_legalname_middlename                                                                                  as legal_name_middle
  , person_legalname_familyname1                                                                                 as legal_name_last  
  , person_legalname_formattedname                                                                               as legal_name_full  
  , person_legalname_nickname                                                                                    as preferred_name   
  , person_legalname_generationaffixcode_codevalue                                                               as legal_name_suffix
  , case
        when person_birthdate in ('', '0000-00-00') then null
        else person_birthdate end::date                                                                          as birth_date
  , person_gendercode_codevalue                                                                                  as gender_code
  , person_gendercode_shortname                                                                                  as gender_name
  , person_communication_emails_0_emailuri                                                                       as personal_email
  , person_communication_mobiles_0_formattednumber                                                               as personal_phone
  , person_communication_landlines_0_formattednumber                                                             as personal_phone
  , person_legaladdress_lineone                                                                                  as legal_address_line1
  , person_legaladdress_linetwo                                                                                  as legal_address_line2
  , person_legaladdress_cityname                                                                                 as legal_address_city
  , person_legaladdress_countrysubdivisionlevel1_codevalue                                                       as legal_address_state_abb
  , person_legaladdress_countrysubdivisionlevel2_shortname                                                       as legal_address_state_name
  , person_legaladdress_postalcode                                                                               as legal_address_zip_code
  , person_legaladdress_countrycode                                                                              as legal_address_country
  , person_otherpersonaladdresses_0_lineone                                                                      as other_address_line1
  , person_otherpersonaladdresses_0_linetwo                                                                      as other_address_line2
  , person_otherpersonaladdresses_0_cityname                                                                     as other_address_city
  , person_otherpersonaladdresses_0_countrysubdivisionlevel1_codevalue                                           as other_address_state_abb
  , person_otherpersonaladdresses_0_countrysubdivisionlevel2_shortname                                           as other_address_state_name
  , person_otherpersonaladdresses_0_postalcode                                                                   as other_address_zip_code
  , person_otherpersonaladdresses_0_countrycode                                                                  as other_address_country
  , iff(person_racecode_shortname = '', person_racecode_longname,
        person_racecode_shortname)                                                                               as eeo_ethnicity
  , person_racecode_identificationmethodcode_shortname                                                           as eeo_identification_method
  , person_highesteducationlevelcode_codevalue                                                                   as education
  , businesscommunication_emails_0_emailuri                                                                      as work_email
  , businesscommunication_landlines_0_formattednumber                                                            as work_phone
  , businesscommunication_mobiles_0_formattednumber                                                              as work_cell_phone
  , case
        when workerdates_originalhiredate in ('', '0000-00-00') then null
        else workerdates_originalhiredate end                                                                    as original_hire_date
  , case
        when workerdates_rehiredate in ('', '0000-00-00') then null
        else workerdates_rehiredate end                                                                          as rehire_date
  , case
        when workassignments_0_terminationdate in ('', '0000-00-00') then null
        else workassignments_0_terminationdate end                                                               as final_termination_date
  , customfieldgroup_stringfields_0_stringvalue                                                                  as reporting_office
  , customfieldgroup_stringfields_1_stringvalue                                                                  as hire_details
  , null                                                                                                         as source
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('adp', 'worker_json_history') }}) then 1
        else 0 end                                                                                               as is_head
  , record_datetime::timestamp                                                                                   as effective_at
  , record_datetime::timestamp                                                                                   as _created_at
  , row_number() over (partition by associateoid, record_datetime::date order by record_datetime desc)::int      as rn
from {{ source('adp', 'worker_history_backup') }}
where true
  and associateoid is not null
  and record_datetime::date < '8/11/2021'
