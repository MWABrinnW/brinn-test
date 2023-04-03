select
    e.employee_id                               as employee_id
  , e.employee_num                              as payroll_file_number
  , e.associate_legal_name_first                as associate_legalname_first
  , e.associate_legal_name_middle               as associate_legalname_middle
  , e.associate_legal_name_last                 as associate_legalname_last
  , e.associate_preferred_name                  as associate_legalname_suffix
  , e.associate_legal_name_full                 as associate_legalname_full
  , e.associate_preferred_name                  as associate_preferredname
  , e.associate_birth_date                      as associate_birthdate
  , e.associate_gender_code                     as associate_gender_code
  , e.associate_gender_name                     as associate_gender_name
  , e.associate_personal_email                  as associate_personal_email
  , e.associate_personal_phone                  as associate_personal_phone
  , e.associate_personal_cell_phone             as associate_personal_cellphone
  , e.associate_legal_address_line1             as associate_legaladdress_line1
  , e.associate_legal_address_line2             as associate_legaladdress_line2
  , e.associate_legal_address_city              as associate_legaladdress_city
  , e.associate_legal_address_state_abb         as associate_legaladdress_stateabb
  , e.associate_legal_address_state             as associate_legaladdress_statename
  , e.associate_legal_address_zip_code          as associate_legaladdress_zipcode
  , e.associate_legal_address_country           as associate_legaladdress_country
  , e.associate_other_address_line1             as associate_otheraddress_line1
  , e.associate_other_address_line2             as associate_otheraddress_line2
  , e.associate_other_address_city              as associate_otheraddress_city
  , e.associate_other_address_state_abb         as associate_otheraddress_stateabb
  , e.associate_other_address_state             as associate_otheraddress_state
  , e.associate_other_address_zip_code          as associate_otheraddress_zipcode
  , e.associate_other_address_country           as associate_other_address_country
  , e.associate_eeo_identification_method       as associate_eeo_identification_method
  , e.associate_eeo_ethnicity                   as associate_eeo_ethnicity
  , e.associate_education                       as associate_education
  , e.associate_work_email                      as associate_work_email
  , e.associate_work_phone                      as associate_work_phone
  , e.associate_work_cell_phone                 as associate_work_cellphone
  , e.employment_status                         as associate_employment_status
  , e.position_seniority_hire_date              as associate_seniority_doh
  , e.associate_original_hire_date              as associate_original_doh
  , e.associate_rehire_date                     as associate_rehire_doh
  , e.associate_final_termination_date          as associate_final_dot
  , e.position_company_code                     as position_company_code
  , e.position_id                               as position_id
  , e.position_status_code                      as position_status_code
  , e.position_status                           as position_status
  , e.position_seniority_hire_date              as position_seniority_hire_date
  , e.position_start_date                       as position_start_date
  , e.hire_details                              as hire_details
  , e.position_termination_date                 as position_dot
  , e.position_change_reason                    as position_change_reason
  , e.position_region_code                      as position_region_code
  , e.position_region_name                      as position_region_name
  , e.position_region_description               as position_region_description
  , e.position_cost_num_market_code             as position_market_code
  , e.position_location_name                    as position_location_name
  , e.home_organizational_units_department_code as position_department_code
  , e.position_department_name                  as position_department_name
  , e.position_manager_position_id              as position_manager_id
  , e.position_manager_name                     as position_manager_name
  , e.position_primary_job_indicator            as position_primary_job_indicator
  , e.position_title_code                       as position_title_code
  , e.position_title                            as position_title
  , e.job_function_code                         as job_function_code
  , e.position_worker_type                      as position_worker_type
  , e.position_benefits_group_code              as position_benefitsgroup_code
  , e.position_benefits_group_class             as position_benefitsgroup_class
  , e.position_flsa                             as position_flsa
  , e.occupational_classifications_class_code   as position_class_code
  , e.occupational_classifications_class        as position_class
  , e.advisor_nonadvisor                        as advisor_nonadvisor
  , e.occupational_classifications_eeo_code     as position_eeo_code
  , e.position_eeo_class                        as position_eeo_class
  , e.position_full_time_equivalent             as position_fte
  , e.position_scheduled_hours                  as position_scheduled_hours
  , e.position_standard_hours                   as position_standard_hours
  , e.location_code                             as location_code
  , e.cost_num                                  as position_cost_number
  , e.position_work_site_location_code          as position_worksite_location_code
  , e.position_work_site_location_name          as position_worksite_location_name
  , e.position_work_site_address_line1          as position_worksiteaddress_line1
  , e.position_work_site_address_line2          as position_worksiteaddress_line2
  , e.position_work_site_address_line3          as position_worksiteaddress_line3
  , e.position_work_site_address_city           as position_worksiteaddress_city
  , e.position_work_site_address_state_abb      as position_worksiteaddress_stateabb
  , e.position_work_site_address_state          as position_worksiteaddress_state
  , e.position_work_site_address_zip_code       as position_worksiteaddress_zipcode
  , e.position_work_site_address_country        as position_worksiteaddress_country
  , e.data_last_refreshed_date                  as adp_last_update_date
  , e.data_last_refreshed_date                  as data_last_refreshed_date

  , e.change_reason_code                        as change_reason_code
  , e.change_reason_description                 as change_reason_description
  , e.vol_invol                                 as vol_invol
  , e.reporting_office                          as reporting_office
  , e.accounting_id                             as accounting_id
  , e.source                                    as source
  , e.title_change_reason                       as title_change_reason
from {{ ref('int_adp_employees_all') }} e
where true
  and e.is_head = 1
  {# and e.is_employee = 1 #}
  {# and e.position_primary_job_indicator = true #}
  {# and right(lower(e.position_id), 1) <> 'n' #}
  {# and nvl(e.is_deleted,0) = 0 #}
  and (
    e.is_employee = 1
    {# or e.position_id in (select distinct position) -- from where? #}
  )