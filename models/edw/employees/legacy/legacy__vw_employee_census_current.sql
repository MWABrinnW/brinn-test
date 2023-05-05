select
    employee_num                            as employee_number
    ,company_code
    ,position_id
    ,legalname_full
    ,employment_status
    ,worker_type
    ,benefitsgroup_code
    ,ft_pt_temp
    ,date_of_hire
    ,hire_reason
    ,hire_details
    ,associate_final_termination_date
    ,vol_invol
    ,accounting_id                          as location_code
    ,cost_num                               as cost_number
    ,advisor_nonadvisor
    ,class
    ,position_region_name
    ,position_location_name                 as position_market_name
    ,position_department_name
    ,work_site_location_name
    ,reporting_office
    ,position_title
    ,job_function_code
    ,years_of_service
    ,age_band
    ,gender
    ,fte
    ,is_current
    ,is_start
    ,is_end
    ,is_term
    ,is_new
    ,data_last_refreshed_date
    ,first_day_of_month
    ,last_day_of_month
    ,position_start_date
    ,source
    ,manager_name                           as position_manager_name
    ,manager_position_id                    as position_manager_position_id
    ,title_change_reason
from {{ ref('employee_census') }}
where true
    and is_head = 1