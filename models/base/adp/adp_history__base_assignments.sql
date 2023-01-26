select
    w.json                                                                                                               as json
  , json:associateOID::string                                                                                            as associate_oid
  , wa.value:payrollFileNumber::string                                                                                   as payroll_file_number
  , wa.value:payrollGroupCode::string                                                                                    as position_company_code
  , wa.value:positionID::string                                                                                          as position_id
  , wa.value:assignmentStatus.statusCode.codeValue::string                                                               as position_status_code
  , wa.value:assignmentStatus.statusCode.shortName::string                                                               as position_status
  , wa.value:seniorityDate::date                                                                                         as position_seniority_hire_date
  , wa.value:actualStartDate::date                                                                                       as position_start_date
  , wa.value:terminationDate::date                                                                                       as position_termination_date
  , coalesce(wa.value:assignmentStatus.reasonCode.longName,
             wa.value:assignmentStatus.reasonCode.codeValue)::string                                                     as position_change_reason
  , wa.value:laborUnion.laborUnionCode.codeValue::string                                                                 as position_region_code
  , wa.value:laborUnion.laborUnionCode.shortName::string                                                                 as position_region_name
  , coalesce(wa.value:laborUnion.laborUnionCode.shortName,
             wa.value:laborUnion.laborUnionCode.longName)::string                                                        as position_region_description
  , wa.value:homeOrganizationalUnits::string                                                                             as home_organizational_units
  , wa.value:reportsTo[0].positionID::string                                                                             as position_manager_position_id
  , wa.value:reportsTo[0].reportsToWorkerName.formattedName::string                                                      as position_manager_name
  , wa.value:primaryIndicator::boolean::int                                                                              as position_primary_job_indicator
  , wa.value:jobCode.codeValue::string                                                                                   as position_title_code
  , wa.value:jobTitle::string                                                                                            as position_title
  , wa.value:jobFunctionCode.shortName::string                                                                           as job_function_code
  , wa.value:workerTypeCode.shortName::string                                                                            as position_worker_type
  , wa.value:workerGroups[0].groupCode.codeValue::string                                                                 as position_benefits_group_code
  , coalesce(wa.value:workerGroups[0].groupCode.shortName,
             wa.value:workerGroups[0].groupCode.longName)::string                                                        as position_benefits_group_class
  , wa.value:wageLawCoverage.coverageCode.codeValue::string                                                              as position_flsa
  , wa.value:occupationalClassifications::string                                                                         as occupational_classifications
  , wa.value:fullTimeEquivalenceRatio::float                                                                             as position_full_time_equivalent
  , wa.value:standardHours.hoursQuantity::float                                                                          as position_scheduled_hours
  , wa.value:standardPayPeriodHours.hoursQuantity::float                                                                 as position_standard_hours
  , wa.value:homeWorkLocation.nameCode.codeValue::string                                                                 as work_site_location_code
  , coalesce(wa.value:homeWorkLocation.nameCode.shortName,
             wa.value:homeWorkLocation.nameCode.longName)::string                                                        as work_site_location_name
  , wa.value:homeWorkLocation.address.lineOne::string                                                                    as work_site_address_line1
  , wa.value:homeWorkLocation.address.lineTwo::string                                                                    as work_site_address_line2
  , wa.value:homeWorkLocation.address.lineThree::string                                                                  as work_site_address_line3
  , wa.value:homeWorkLocation.address.cityName::string                                                                   as work_site_address_city
  , wa.value:homeWorkLocation.address.countrySubdivisionLevel1.codeValue::string                                         as work_site_address_state_abb
  , wa.value:homeWorkLocation.address.countrySubdivisionLevel1.shortName::string                                         as work_site_address_state
  , wa.value:homeWorkLocation.address.postalCode::string                                                                 as work_site_address_zip_code
  , wa.value:homeWorkLocation.address.countryCode::string                                                                as work_site_address_country
  , wa.value:assignmentStatus.reasonCode.codeValue::string                                                               as status_change_code
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('adp', 'worker_json_history') }}) then 1
        else 0 end                                                                                                       as is_head
  , w.record_datetime::timestamp                                                                                         as effective_at
  , w.record_datetime::timestamp                                                                                         as _created_at
  , row_number() over (partition by wa.value:positionID::string, record_datetime::date order by record_datetime desc)::int as rn
from {{ source('adp', 'worker_json_history') }}     w
   , table (flatten(input => json:workAssignments)) wa
where record_datetime::date >= '8/11/2021'

union all

select
    null                                                                                                    as json
  , associateoid                                                                                            as associate_oid
  , payrollfilenumber                                                                                       as payroll_file_number
  , payrollgroupcode                                                                                        as position_company_code
  , positionid                                                                                              as position_id
  , assignmentstatus_statuscode_codevalue                                                                   as position_status_code
  , assignmentstatus_statuscode_shortname                                                                   as position_status
  , case
        when senioritydate in ('', '0000-00-00') then null
        else senioritydate end::date                                                                        as position_seniority_hire_date
  , case
        when actualstartdate in ('', '0000-00-00') then null
        else actualstartdate end::date                                                                      as position_start_date
  , case
        when terminationdate in ('', '0000-00-00') then null
        else terminationdate end::date                                                                      as position_termination_date
  , coalesce(assignmentstatus_reasoncode_longname,
             assignmentstatus_reasoncode_codevalue)                                                         as position_change_reason
  , laborunion_laborunioncode_codevalue                                                                     as position_region_code
  , laborunion_laborunioncode_shortname                                                                     as position_region_name
  , coalesce(laborunion_laborunioncode_shortname,
             laborunion_laborunioncode_longname)                                                            as position_region_description
  , null                                                                                                    as home_organizational_units
  , reportsto_0_positionid                                                                                  as position_manager_position_id
  , reportsto_0_reportstoworkername_formattedname                                                           as position_manager_name
  , primaryindicator::int                                                                                   as position_primary_job_indicator
  , jobcode_codevalue                                                                                       as position_title_code
  , jobtitle                                                                                                as position_title
  , null                                                                                                    as job_function_code
  , workertypecode_shortname                                                                                as position_worker_type
  , workergroups_0_groupcode_codevalue                                                                      as position_benefits_group_code
  , coalesce(workergroups_0_groupcode_shortname,
             workergroups_0_groupcode_longname)                                                             as position_benefits_group_class
  , wagelawcoverage_coveragecode_codevalue                                                                  as position_flsa
  , null                                                                                                    as occupational_classifications
  , fulltimeequivalenceratio                                                                                as position_full_time_equivalent
  , standardhours_hoursquantity                                                                             as position_scheduled_hours
  , standardpayperiodhours_hoursquantity                                                                    as position_standard_hours
  , homeworklocation_namecode_codevalue                                                                     as work_site_location_code
  , coalesce(homeworklocation_namecode_shortname,
             homeworklocation_namecode_longname)                                                            as work_site_location_name
  , homeworklocation_address_lineone                                                                        as work_site_address_line1
  , homeworklocation_address_linetwo                                                                        as work_site_address_line2
  , homeworklocation_address_linethree                                                                      as work_site_address_line3
  , homeworklocation_address_cityname                                                                       as work_site_address_city
  , homeworklocation_address_countrysubdivisionlevel1_codevalue                                             as work_site_address_state_abb
  , homeworklocation_address_countrysubdivisionlevel1_shortname                                             as work_site_address_state
  , homeworklocation_address_postalcode                                                                     as work_site_address_zip_code
  , homeworklocation_address_countrycode                                                                    as work_site_address_country
  , assignmentstatus_reasoncode_codevalue                                                                   as status_change_code
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('adp', 'worker_json_history') }}) then 1
        else 0 end                                                                                          as is_head
  , record_datetime::timestamp                                                                              as effective_at
  , record_datetime::timestamp                                                                              as _created_at
  , row_number() over (partition by positionid, record_datetime::date order by record_datetime desc)::int   as rn
from {{ source('adp', 'worker_assignment_history_backup') }}
where 1 = 1
  and associateoid is not null
  and record_datetime::date < '8/11/2021'
