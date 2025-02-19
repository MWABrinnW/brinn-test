select
    associate_reporting_id             as employee_reporting_id
    , month_end_date                   as report_month_end
    {# ,company_code #}
    , position_id                      as position_id
    , legalname_full                   as legalname_full
    , employment_status                as employment_status
    , worker_type                      as worker_type
    , benefitsgroup_code               as benefitsgroup_code
    , ft_pt_temp                       as ft_pt_temp
    , date_of_hire                     as date_of_hire
    , hire_reason                      as hire_type
    , hire_details                     as hire_details
    , associate_final_termination_date as final_termination_date
    , vol_invol                        as vol_invol
    , location_code                    as location_code
    , cost_num                         as cost_number
    , advisor_nonadvisor               as advisor_nonadvisor
    , class                            as class
    , position_region_name             as position_region_name
    , position_location_name           as position_market_name
    , position_department_name         as position_department_name
    , work_site_location_name          as position_location_name
    , job_function_code                as title
    , job_function_code                as job_function_code
    , years_of_service                 as years_of_service
    , age_band                         as age_band
    , gender                           as gender
    , fte                              as fte
    {# ,is_current #}
    , is_start                         as is_start
    , is_end                           as is_end
    , is_new                           as is_new
    , is_term                          as is_term
    , is_invol_term                    as is_invol_term
    , is_vol_term                      as is_vol_term
    , reporting_office                 as reporting_office
    , manager_name                     as manager_name
    , manager_position_id              as manager_position_id
    , location_code                    as effective_location_code
    , location_name                    as effective_location_name
    , accounting_id                    as accounting_id
    {# ,first_day_of_month
    ,last_day_of_month
    ,position_start_date #}
    , source                           as source
    , title_change_reason              as title_change_reason
from {{ ref('associate_census') }}
where true
    and is_month_end = 1
