select
    c.employee_reporting_id                                                 as associate_reporting_id
    , c.person_number                                                       as associate_id
    , h.employee_num_legacy                                                 as legacy_employee_number
    , c.full_name                                                           as associate_legal_name_full
    , case
        when c.actual_termination_date::date <= c.effective_date
            then 'Terminated'::text(200)
        else trim(split_part(c.assignment_status_name , '-' , 1))
    end                                                                     as employment_status
    , h.position_worker_type                                                as associate_worker_type
    , case
        when c.full_part_time_flag = 'FULL_TIME'
            then 'FT'
        when c.full_part_time_flag = 'PART_TIME'
            then 'PT'
        else 'TEMP'
    end                                                                     as ft_pt_temp
    , c.date_start::date                                                    as associate_latest_hire_date
    , case
        when c.actual_termination_date::date <= c.effective_date
            then c.actual_termination_date
    end::date                                                               as associate_final_termination_date
    , case
        when
            lower(c.action_reason_code) in (
                'eoa'
                , 'mwa_personal'
                , 'mwa_resign_lieu_term'
                , 'mwa_transfer_promo'
                , 'mwa_work_authorization'
                , 'resign_personal'
            )
            then 'Other'
        when lower(c.action_description) in ('retirement' , 'death') then 'Other'
        when lower(c.action_description) = 'involuntary termination' then 'Involuntary'
        when lower(c.action_description) = 'resignation' then 'Voluntary'
    end::text(100)                                                          as vol_invol
    , h.accounting_id                                                       as _3_accounting_id
    , l.location_code                                                       as location_code
    , c.location_name                                                       as associate_work_site_location_name
    , c.cost_num::text(200)                                                 as cost_num
    , case
        when c.people_group ilike '%.advisor'
            then 'Advisor'
        else 'Non-Advisor'
    end::text(200)                                                          as advisor_nonadvisor
    , c.mgmt_lvl::text(200)                                                 as job_level
    , l.region_name                                                         as region_name
    , l.location_name                                                       as location_name
    , c.department_name                                                     as associate_department_name
    , c.job_family_name                                                     as job_family
    , c.job_function_name                                                   as job_function_name
    , c.job_name                                                            as associate_title
    , c.tenure_in_years::text(50)                                           as years_of_service
    , case
        when c.age_in_years < 30 then '< 30 years'
        when c.age_in_years between 30 and 39 then '30-39 yrs'
        when c.age_in_years between 40 and 49 then '40-49 yrs'
        when c.age_in_years between 50 and 59 then '50-59 yrs'
        when c.age_in_years >= 60 then '> 60 yrs'
    end                                                                     as age_band
    , case
        when c.gender = 'F' then 'Female'
        when c.gender = 'M' then 'Male'
        when c.gender = 'ORA_HRX_X' then 'Non-binary'
        when c.gender = '~NOVALUE~' then 'Decline to answer'
    end                                                                     as associate_gender
    , c.fte                                                                 as associate_fte
    , case
        when c.person_number = '100940' then null--Marty Bicknell has no manager
        else c.mgr_full_name
    end                                                                     as associate_manager_name
    , substring(regexp_replace(c.mgr_assgn_number , '[^0-9]' , '') , 1 , 6) as associate_manager_assignment_id
    , c.real_estate_code                                                    as associate_work_site_location_real_estate_code
    , case
        when c.per_system_status = 'ACTIVE'
            then 1
        else 0
    end                                                                     as is_current
    , case
        when c.actual_termination_date
            >= date_trunc(month , c.effective_date::date)
            and c.date_start < date_trunc(month , c.effective_date::date)
            then 1
        when c.actual_termination_date is null
            and c.date_start < date_trunc(month , c.effective_date)
            then 1
        else 0
    end::int                                                                as is_start
    , case
        when c.actual_termination_date > c.effective_date::date
            and c.date_start <= c.effective_date::date
            then 1
        when c.actual_termination_date is null
            and c.date_start <= c.effective_date::date
            then 1
        else 0
    end::int                                                                as is_end
    , case
        when c.actual_termination_date between
            date_trunc(month , c.effective_date::date) and
            last_day(c.effective_date::date)
            and c.actual_termination_date <= c.effective_date::date
            then 1
        else 0
    end::int                                                                as is_term
    , case
        when c.date_start between date_trunc(month , c.effective_date)
            and last_day(c.effective_date) then 1
        else 0
    end::int                                                                as is_new
    , case
        when is_term = 1 and vol_invol ilike 'invol%' then 1
        else 0
    end::int                                                                as is_invol_term
    , case
        when is_term = 1 and vol_invol ilike 'vol%' then 1
        else 0
    end::int                                                                as is_vol_term
    , c.effective_date::date                                                as data_last_refreshed_date
    , c.assignment_effective_start_date                                     as assignment_start_date
    , h.person_source                                                       as person_source
    , c.assignment_action_code::text(200)                                   as title_change_reason
    , c.mariner_job_id                                                      as job_id
    , last_day(c.effective_date::date)                                      as month_end_date
    , date_trunc(month , c.effective_date::date)                            as first_day_of_month
    , last_day(c.effective_date::date)                                      as last_day_of_month
    , c.effective_date                                                      as effective_at
    , case
        when effective_at::date = last_day_of_month
            then 1
        else 0
    end::int                                                                as is_month_end
    , {{ col_is_head(
        reference=ref('faw__stg_census'),
        reference_date_col='effective_date',
        source_date_col='c.effective_date'
        ) }}
from {{ ref('faw__stg_census') }} as c
left join {{ ref('nml_oracle_hcm_associates') }} as h
    on c.effective_date = h.effective_at::date
    and c.person_number = h.employee_num
left join {{ ref('locations') }} as l
    on h.accounting_id = l.accounting_id
    and h.effective_at::date between coalesce(l.start_date , h.effective_at::date) and coalesce(l.end_date , h.effective_at::date)
where true
    and c.effective_date::date >= '2024-07-01'
    and c.job_id <> '-99999'

------------------------------------------------------------------------------------
union all

select
    em.employee_reporting_id                            as employee_reporting_id
    , coalesce(h1.employee_num , em.employee_num)       as employee_num
    , em.employee_num                                   as legacy_employee_number
    , em.associate_legal_name_full                      as associate_legal_name_full
    , em.employment_status                              as employment_status
    , em.position_worker_type                           as worker_type

    -- Standardize the type of employee based on benefit code.
    , em.ft_pt_temp                                     as ft_pt_temp
    , coalesce(
        em.position_seniority_hire_date
        , em.associate_rehire_date
        , em.associate_original_hire_date
    )                                                   as associate_latest_hire_date
    , em.associate_final_termination_date               as associate_final_termination_date
    , em.vol_invol                                      as vol_invol
    , em.accounting_id                                  as _3_accounting_id
    , em.location_code                                  as location_code
    , em.position_work_site_location_name               as associate_work_site_location_name
    , em.cost_num                                       as cost_num

    -- If the field position has the word "Advisor" then set employee as "Advisor"
    -- or "Non-Advisor".
    , em.advisor_nonadvisor                             as advisor_nonadvisor
    , em.occupational_classifications_class             as job_level
    , em.position_region_name                           as region_name
    , em.position_location_name                         as location_name
    , em.position_department_name                       as associate_department_name
    , null::text                                        as job_family
    , em.job_function_code                              as job_function_name
    , em.position_title                                 as associate_title

    -- Calculate the years and months for service for the employee.
    , em.years_of_service                               as years_of_service

    -- Set the age band employee from the CTE data.
    , em.age_band                                       as age_band
    , em.associate_gender_name                          as associate_gender
    , em.position_full_time_equivalent                  as associate_fte

    , em.position_manager_name                          as associate_manager_name
    , em.position_manager_position_id                   as associate_manager_assignment_id
    , regexp_substr(em.reporting_office , 'RE[0-9]{5}') as associate_work_site_location_real_estate_code

    , em.is_current                                     as is_current
    , em.is_start                                       as is_start
    , em.is_end                                         as is_end
    , em.is_term                                        as is_term
    , em.is_new                                         as is_new
    , em.is_invol_term                                  as is_invol_term
    , em.is_vol_term                                    as is_vol_term

    , em.data_last_refreshed_date                       as data_last_refreshed_date
    , em.position_start_date                            as assignment_start_date
    , em.source                                         as person_source
    , em.title_change_reason                            as title_change_reason
    , em.job_id                                         as job_id
    , em.month_end_date                                 as month_end_date
    , date_trunc(month , em.effective_at::date)         as first_day_of_month
    , em.month_end_date                                 as last_day_of_month
    , em.effective_at                                   as effective_at
    , em.is_month_end                                   as is_month_end
    , 0::int                                            as is_head
from {{ ref('int_adp_employees_all') }} as em
left join {{ ref('nml_oracle_hcm_associates') }} as h1
    on em.employee_num = h1.employee_num_legacy
    and h1.is_head = 1
where true
    and em.is_census = 1
    and coalesce(em.is_deleted , 0) = 0
    and em.effective_at::date between '12/1/2022' and '6/30/2024'

------------------------------------------------------------------------------------
union all

select
    le.report_month_end || '-' || le.position_id            as employee_reporting_id
    , coalesce(h2.employee_num , right(le.position_id , 6)) as employee_num
    , right(le.position_id , 6)                             as legacy_employee_number
    , le.legalname_full                                     as associate_legal_name_full
    , le.employment_status                                  as employment_status
    , le.worker_type                                        as worker_type
    , case
        when le.benefitsgroup_code in ('FT' , 'K1')
            then 'FT'
        when le.benefitsgroup_code in ('PTE' , 'PTN')
            then 'PT'
        else 'TEMP'
    end                                                     as ft_pt_temp
    , le.date_of_hire                                       as associate_latest_hire_date
    , le.final_termination_date                             as associate_final_termination_date
    , le.vol_invol                                          as vol_invol
    , be.accounting_id                                      as _3_accounting_id
    , be.location_code                                      as location_code
    , le.position_location_name                             as associate_work_site_location_name
    , le.cost_number                                        as cost_number
    , le.advisor_nonadvisor                                 as advisor_nonadvisor
    , le.class                                              as job_level
    , le.position_region_name                               as region_name
    , le.position_market_name                               as location_name
    , le.position_department_name                           as associate_department_name
    , null::text                                            as job_family

    , le.job_function_code                                  as job_function_name
    , le.title                                              as associate_title
    , le.years_of_service                                   as years_of_service
    , le.age_band                                           as age_band
    , le.gender                                             as associate_gender
    , le.fte                                                as associate_fte

    , be.position_manager_name                              as associate_manager_name
    , be.position_manager_position_id                       as associate_manager_assignment_id
    , regexp_substr(le.reporting_office , 'RE[0-9]{5}')     as associate_work_site_location_real_estate_code

    , case
        when (le.is_term = 1 or le.is_new = 1 or le.final_termination_date is null)
            and le.date_of_hire is not null
            then 1
        else 0
    end                                                     as is_current
    , le.is_start                                           as is_start
    , le.is_end                                             as is_end
    , le.is_term                                            as is_term
    , le.is_new                                             as is_new
    , be.is_invol_term                                      as is_invol_term
    , be.is_vol_term                                        as is_vol_term

    , null::timestamp_ntz                                   as data_last_refreshed_date
    , le.position_start_date                                as assignment_start_date
    , be.source                                             as person_source
    , be.title_change_reason                                as title_change_reason
    , null::text(200)                                       as job_id
    , le.report_month_end                                   as month_end_date
    , date_trunc(month , le.report_month_end)               as first_day_of_month
    , last_day(le.report_month_end)                         as last_day_of_month
    , le.report_month_end::timestamp                        as effective_at
    , 1::int                                                as is_month_end
    , 0::int                                                as is_head
from {{ ref('edw_legacy__base_employee_reporting_history') }} as le
left join {{ ref('int_adp_employees_all') }} as be
    on le.position_id = be.position_id
    and le.report_month_end = be.effective_at::date
left join {{ ref('nml_oracle_hcm_associates') }} as h2
    on right(le.position_id , 6) = h2.employee_num_legacy
    and h2.is_head = 1
where le.report_month_end <= '11/30/2022'
    and le.position_id <> '67L000942'--drop Gene Bicknell
