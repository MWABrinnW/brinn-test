select
     employee_reporting_id
    ,month_end_date     as report_month_end
    {# ,company_code #}
    ,position_id
    ,legalname_full
    ,employment_status
    ,worker_type
    ,benefitsgroup_code
    ,ft_pt_temp
    ,date_of_hire
    ,hire_reason as hire_type
    ,hire_details
    ,associate_final_termination_date as final_termination_date
    ,vol_invol
    ,location_code
    ,cost_num as cost_number
    ,advisor_nonadvisor
    ,class
    ,position_region_name
    ,position_market_name
    ,position_department_name
    ,work_site_location_name as position_location_name
    ,position_title as title
    ,job_function_code
    ,years_of_service
    ,age_band
    ,gender
    ,fte
    {# ,is_current #}
    ,is_start
    ,is_end
    ,is_new
    ,is_term
    ,is_invol_term
    ,is_vol_term
    ,reporting_office
    ,manager_name
    ,manager_position_id
    ,location_code as effective_location_code
    ,location_name as effective_location_name
    ,accounting_id
    {# ,first_day_of_month
    ,last_day_of_month
    ,position_start_date #}
    ,source
from {{ ref('employee_census') }}
where true
    and is_month_end = 1