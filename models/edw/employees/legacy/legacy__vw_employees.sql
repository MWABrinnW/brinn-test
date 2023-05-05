select
    emp.employee_num                         as employee_number
  , emp.position_id                          as position_id
  , emp.associate_legal_name_first           as legal_name_first
  , emp.associate_legal_name_middle          as legal_name_middle
  , emp.associate_legal_name_last            as legal_name_last
  , emp.associate_legal_name_suffix          as legal_name_suffix
  , emp.associate_legal_name_full            as legal_name_full
  , emp.associate_preferred_name             as preferred_name
  , emp.associate_birth_date_masked          as birth_date_masked
  , emp.associate_birth_date                 as birth_date
  , emp.associate_birth_month                as birth_month
  , emp.associate_work_email                 as work_email
  , emp.associate_work_phone                 as work_phone
  , emp.associate_work_cell_phone            as work_cell_phone
  , emp.position_work_site_address_line1     as work_site_address_line1
  , emp.position_work_site_address_line2     as work_site_address_line2
  , emp.position_work_site_address_line3     as work_site_address_line3
  , emp.employment_status                    as employment_status
  , emp.position_title                       as title
  , emp.job_function_code                    as job_function_code
  , emp.position_class                       as position_class
  , emp.advisor_nonadvisor                   as advisor_nonadvisor
  , emp.position_worker_type                 as worker_type
  , emp.position_company_code                as company_code
  , emp.position_manager_name                as manager_name
  , emp.position_manager_position_id         as manager_position_id
  , emp.position_region_name                 as position_region_name
  , emp.position_location_name               as position_market_name
  , emp.position_department_name             as position_department_name
  , emp.position_work_site_location_name     as work_site_location_name
  , emp.position_work_site_address_city      as work_site_address_city
  , emp.position_work_site_address_state_abb as work_site_address_state_abb
  , emp.position_work_site_address_zip_code  as work_site_address_zip_code
  , emp.location_code                        as location_code
  , emp.cost_num                             as cost_number
  , emp.reporting_office                     as reporting_office
  , emp.associate_original_hire_date         as original_hire_date
  , emp.position_seniority_hire_date         as seniority_hire_date
  , emp.associate_rehire_date                as rehire_date
  , emp.associate_final_termination_date     as final_termination_date
  , null                                     as adp_last_update_date
  , emp.data_last_refreshed_date             as data_last_refreshed_date
  , emp.location_code                        as accounting_id
  , emp.source                               as source
from {{ ref('employees') }} as emp
where true
  and right(lower(emp.position_id), 1) <> 'n'
  {# and nvl(emp.is_deleted,0) = 0 #}