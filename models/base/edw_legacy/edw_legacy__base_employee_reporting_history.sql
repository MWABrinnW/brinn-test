select
    employee_reporting_id
    ,report_month_end::date as report_month_end
    ,position_id
    ,legalname_full
    ,employment_status
    ,worker_type
    ,benefitsgroup_code
    ,date_of_hire::date as date_of_hire
    ,hire_type
    ,replacement_budget
    ,final_termination_date
    ,vol_invol
    ,change_reason
    ,cost_number
    ,cost_number_legal_code
    ,cost_number_region_code
    ,cost_number_market_code
    ,cost_number_location_code
    ,cost_number_team_code
    ,cost_number_natural_code
    ,cost_number_sub_code
    ,advisor_nonadvisor
    ,class
    ,position_region_name
    ,position_market_name
    ,position_department_name
    ,position_location_name
    ,title
    ,years_of_service
    ,age_band
    ,gender
    ,fte
    ,"START"    as is_start
    ,"END"      as is_end
    ,"NEW"      as is_new
    ,"TERM"     as is_term
    ,invol_term
    ,vol_term
    ,year_end_summary
    ,position_start_date::date as position_start_date
    ,job_function_code
    ,reporting_office
from {{ source('edw_legacy', 'employee_reporting_history') }}