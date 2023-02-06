select
    case when worker.associate_oid = '' then null else worker.associate_oid end as associate_oid
  , case when worker.employee_id = '' then null else worker.employee_id end as employee_id
  , worker.employee_status
  , worker.legal_name_first 
  , worker.legal_name_middle
  , worker.legal_name_last  
  , worker.legal_name_full  
  , worker.preferred_name   
  , worker.legal_name_suffix
  , worker.birth_date
  , worker.gender_code
  , worker.gender_name
  , worker.personal_email
  , worker.personal_phone
  , worker.personal_cell_phone
  , worker.legal_address_line1
  , worker.legal_address_line2
  , worker.legal_address_city
  , worker.legal_address_state_abb
  , worker.legal_address_state_name
  , worker.legal_address_zip_code
  , worker.legal_address_country
  , worker.other_address_line1
  , worker.other_address_line2
  , worker.other_address_city
  , worker.other_address_state_abb
  , worker.other_address_state_name
  , worker.other_address_zip_code
  , worker.other_address_country
  , worker.eeo_ethnicity
  , worker.eeo_identification_method
  , worker.education
  , worker.work_email
  , worker.work_phone
  , worker.work_cell_phone
  , worker.original_hire_date
  , worker.rehire_date
  , worker.final_termination_date
  , worker.reporting_office
  , worker.hire_details
  , worker.source
  , worker.title_change_reason
  , case when assignment.payroll_file_number = '' then null else assignment.payroll_file_number end as payroll_file_number
  , assignment.position_company_code
  , assignment.position_id
  , assignment.position_status_code
  , assignment.position_status
  , assignment.position_seniority_hire_date
  , assignment.position_start_date
  , assignment.position_termination_date
  , assignment.position_change_reason
  , assignment.position_region_code
  , assignment.position_region_name
  , assignment.position_region_description
  , assignment.home_organizational_units
  , assignment.position_manager_position_id
  , assignment.position_manager_name
  , assignment.position_primary_job_indicator
  , assignment.position_title_code
  , assignment.position_title
  , assignment.job_function_code
  , assignment.position_worker_type
  , assignment.position_benefits_group_code
  , assignment.position_benefits_group_class
  , assignment.position_flsa
  , assignment.occupational_classifications
  , assignment.position_full_time_equivalent
  , assignment.position_scheduled_hours
  , assignment.position_standard_hours
  , assignment.work_site_location_code
  , assignment.work_site_location_name
  , assignment.work_site_address_line1
  , assignment.work_site_address_line2
  , assignment.work_site_address_line3
  , assignment.work_site_address_city
  , assignment.work_site_address_state_abb
  , assignment.work_site_address_state
  , assignment.work_site_address_zip_code
  , assignment.work_site_address_country
  , assignment.status_change_code
  , assignment.is_head
  , worker.effective_at
  , worker._created_at
from {{ ref('adp_history__base_workers') }}           as worker
left join {{ ref('adp_history__base_assignments') }} as assignment
  on worker.associate_oid = assignment.associate_oid
  and worker.effective_at::date = assignment.effective_at::date
  and worker.rn = assignment.rn
where true
  {# and worker.rn = 1 #}
