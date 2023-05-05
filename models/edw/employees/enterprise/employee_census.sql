select
    em.employee_reporting_id                                                                             as employee_reporting_id
  , em.employee_num                                                                                      as employee_num
  , em.position_company_code                                                                             as company_code
  , em.position_id                                                                                       as position_id
  , em.associate_legal_name_full                                                                         as legalname_full
  , em.employment_status                                                                                 as employment_status
  , em.position_worker_type                                                                              as worker_type
  , em.position_benefits_group_code                                                                      as benefitsgroup_code

    -- Standardize the type of employee based on benefit code.
  , em.ft_pt_temp                                                                                        as ft_pt_temp

  , coalesce(em.position_seniority_hire_date, em.associate_rehire_date, em.associate_original_hire_date) as date_of_hire

    -- Get hire reason if available.
  , case
        when charindex('-', em.hire_details, 1) > 1
            then trim(left(em.hire_details, (charindex('-', em.hire_details) - 1)))
        else em.hire_details
        end                                                                                              as hire_reason

    -- Get hire details if available.
  , case
        when charindex('-', em.hire_details, 1) > 1
            then right(em.hire_details, (len(em.hire_details) - (charindex('-', em.hire_details) + 1)))
        else em.hire_details
        end                                                                                              as hire_details

  , em.associate_final_termination_date                                                                  as associate_final_termination_date
  , em.vol_invol                                                                                         as vol_invol
  , em.accounting_id                                                                                     as accounting_id
  , em.location_code                                                                                     as location_code
  , em.location_name                                                                                     as location_name

  , em.cost_num                                                                                          as cost_num

    -- If the field position has the word "Advisor" then set employee as "Advisor" or "Non-Advisor"
  , em.advisor_nonadvisor                                                                                as advisor_nonadvisor
  , em.occupational_classifications_class                                                                as class
  , em.position_region_name                                                                              as position_region_name
  , em.position_location_name                                                                            as position_location_name
  , em.position_department_name                                                                          as position_department_name
  , em.position_work_site_location_name                                                                  as work_site_location_name
  , em.reporting_office                                                                                  as reporting_office
  , em.position_title                                                                                    as position_title
  , em.job_function_code                                                                                 as job_function_code

    -- Calculate the years and months for service for the employee.
  , em.years_of_service                                                                                  as years_of_service

    -- Set the age band employee from the CTE data.
  , em.age_band                                                                                          as age_band
  , em.associate_gender_name                                                                             as gender
  , em.position_full_time_equivalent                                                                     as fte

  , em.position_manager_name                                                                             as manager_name
  , em.position_manager_position_id                                                                      as manager_position_id

  , em.is_current                                                                                        as is_current
  , em.is_start                                                                                          as is_start
  , em.is_end                                                                                            as is_end
  , em.is_term                                                                                           as is_term
  , em.is_new                                                                                            as is_new
  , em.is_invol_term                                                                                     as is_invol_term
  , em.is_vol_term                                                                                       as is_vol_term

  , em.data_last_refreshed_date                                                                          as data_last_refreshed_date
  , em.position_start_date                                                                               as position_start_date
  , em.source                                                                                            as source
  , em.title_change_reason                                                                               as title_change_reason
  , em.month_end_date                                                                                    as month_end_date
  , date_trunc(month, em.effective_at::date)                                                             as first_day_of_month
  , em.month_end_date                                                                                    as last_day_of_month
  , em.effective_at                                                                                      as effective_at
  , em.is_month_end                                                                                      as is_month_end
  , em.is_head                                                                                           as is_head
from {{ ref('int_adp_employees_all') }} em
where true
  and em.is_census = 1
  and nvl(em.is_deleted, 0) = 0
  and em.effective_at::date >= '12/1/2022'

union all

select
    le.report_month_end || '-' || le.position_id  as employee_reporting_id
  , right(le.position_id, 6)               as employee_num
  , left(le.position_id, 3)                as company_code
  , le.position_id
  , le.legalname_full
  , le.employment_status
  , le.worker_type
  , le.benefitsgroup_code
  , case
        when le.benefitsgroup_code = 'FT'
            then 'FT'
        when le.benefitsgroup_code = 'PTE'
            then 'PT'
        when le.benefitsgroup_code = 'PTN'
            then 'PT'
        when le.benefitsgroup_code = 'K1'
            then 'FT'
        else 'TEMP'
        end                                as ft_pt_temp
  , le.date_of_hire
  , le.hire_type                           as hire_reason
  , null                                   as hire_details
  , le.final_termination_date
  , le.vol_invol
  , be.accounting_id                       as accounting_id
  , be.location_code                       as location_code
  , be.location_name                       as location_name
  , le.cost_number
  , le.advisor_nonadvisor
  , le.class
  , le.position_region_name
  , le.position_market_name
  , le.position_department_name
  , le.position_location_name
  , le.reporting_office

  , le.title
  , le.job_function_code
  , le.years_of_service
  , le.age_band
  , le.gender
  , le.fte

  , be.position_manager_name               as manager_name
  , be.position_manager_position_id        as manager_position_id

  , case
        when (le.is_term = 1 or le.is_new = 1 or le.final_termination_date is null) and le.date_of_hire is not null
            then 1
        else 0
        end                                as is_current
  , le.is_start                            as is_start
  , le.is_end                              as is_end
  , le.is_term                             as is_term
  , le.is_new                              as is_new
  , be.is_invol_term                       as is_invol_term
  , be.is_vol_term                         as is_vol_term

  , null                                   as data_last_refreshed_date
  , le.position_start_date                 as position_start_date
  , be.source                              as source
  , be.title_change_reason                 as title_change_reason
  , le.report_month_end                    as month_end_date
  , date_trunc(month, le.report_month_end) as first_day_of_month
  , last_day(le.report_month_end)          as last_day_of_month
  , le.report_month_end::timestamp         as effective_at
  , 1                                      as is_month_end
  , 0                                      as is_head
from {{ ref('edw_legacy__base_employee_reporting_history') }} le
left join {{ ref('int_adp_employees_all') }}                    be
  on le.position_id = be.position_id
  and le.report_month_end = be.effective_at::date
where report_month_end <= '11/30/2022'

