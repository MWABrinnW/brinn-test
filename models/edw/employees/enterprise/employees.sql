select
    emp.source_system
  , emp.employee_num        
  , emp.position_id
  , emp.employment_status
  , emp.position_title
  , emp.job_function_code
  , emp.advisor_nonadvisor
  , emp.associate_work_email
  , emp.associate_work_phone
  , emp.associate_work_cell_phone
  , emp.associate_legal_name_first
  , emp.associate_legal_name_middle
  , emp.associate_legal_name_last
  , emp.associate_legal_name_suffix
  , emp.associate_legal_name_full
  , emp.associate_preferred_name
  , to_date('1804-' || date_part('MM', emp.associate_birth_date) || '-' || date_part('dd', emp.associate_birth_date))  as associate_birth_date_masked
  , monthname(emp.associate_birth_date) || ' ' || date_part(day, emp.associate_birth_date)          as associate_birth_date
  , monthname(emp.associate_birth_date)                                                             as associate_birth_month
  , emp.position_work_site_address_line1
  , emp.position_work_site_address_line2
  , emp.position_work_site_address_line3
  , emp.occupational_classifications_class as position_class
  , emp.position_worker_type
  , emp.position_company_code
  , emp.position_manager_name
  , emp.position_manager_position_id
  , emp.position_region_name
  , emp.position_market_name
  , emp.position_department_name
  , emp.position_work_site_location_name
  , emp.position_work_site_address_city
  , emp.position_work_site_address_state_abb
  , emp.position_work_site_address_zip_code
  , emp.location_code
  , emp.cost_num
  , emp.reporting_office
  , emp.associate_original_hire_date
  , emp.position_seniority_hire_date
  , emp.associate_rehire_date
  , emp.associate_final_termination_date
  , emp.data_last_refreshed_date
  , emp.accounting_id
  , emp.source
  , emp.position_start_date
  , emp.title_change_reason
from {{ ref('int_adp_employees_all') }} emp
where true
  and right(lower(emp.position_id),1) <> 'n'
  and emp.is_head = 1
  and nvl(emp.is_deleted,0) = 0