select
    json:assignment_number::text                                                     as assignment_number
    , json:person_number::text                                                       as person_number
    , json:employee_reporting_id::text                                               as employee_reporting_id
    , json:person_id::text                                                           as person_id
    , json:age_in_years::int                                                         as age_in_years
    , json:assignment_status_name::text                                              as assignment_status_name
    , json:asgn_action_code::text                                                    as assignment_action_code
    , json:action_type_code::text                                                    as action_type_code
    , try_to_date(json:asgn_effective_start_date::text , 'MM/DD/YYYY HH12:MI:SS AM') as assignment_effective_start_date
    , json:business_unit_name::text                                                  as business_unit_name
    , try_to_date(json:calendar_date::text , 'MM/DD/YYYY HH12:MI:SS AM')             as calendar_date
    , try_to_date(json:date_start::text , 'MM/DD/YYYY HH12:MI:SS AM')                as date_start
    , try_to_date(json:actual_termination_date::text , 'MM/DD/YYYY HH12:MI:SS AM')   as actual_termination_date
    , json:termination_type::text                                                    as termination_type
    , json:department_name::text                                                     as department_name
    , json:division::text                                                            as division
    , json:ethnicity_name::text                                                      as ethnicity_name
    , json:fte::int                                                                  as fte
    , json:full_name::text                                                           as full_name
    , json:full_part_time_flag::text                                                 as full_part_time_flag
    , json:job_family_code::text                                                     as job_family_code
    , json:job_family_name::text                                                     as job_family_name
    , json:job_function_name::text                                                   as job_function_name
    , json:job_id::text                                                              as job_id
    , json:mariner_job_id::text                                                      as mariner_job_id
    , json:legal_employer_name::text                                                 as legal_employer_name
    , json:location_code::text                                                       as location_code
    , json:location_name::text                                                       as location_name
    , json:mgmt_lvl::text                                                            as mgmt_lvl
    , json:mgr_assgn_number::text                                                    as mgr_assgn_number
    , json:mgr_full_name::text                                                       as mgr_full_name
    , json:mgr_person_number::text                                                   as mgr_person_number
    , json:per_system_status::text                                                   as per_system_status
    , json:real_estate_code::text                                                    as real_estate_code
    , json:region::text                                                              as region
    , json:sector::text                                                              as sector
    , json:system_person_type::text                                                  as system_person_type
    , json:tenure_in_years::int                                                      as tenure_in_years
    , json:action_name::text                                                         as action_name
    , json:action_reason_code::text                                                  as action_reason_code
    , json:dflt_expense_acct::text                                                   as cost_num
    , json:gender::text                                                              as gender
    , json:people_grp::text                                                          as people_group
    , json:source::text                                                              as source
    , json:start_count::int                                                          as start_count
    , json:end_count::int                                                            as end_count
    , json:new_count::int                                                            as new_count
    , json:term_count::int                                                           as term_count
    , json:integration_id::text                                                      as integration_id
    , to_timestamp(json:w_insert_dt::text , 'MM/DD/YYYY HH12:MI:SS AM')              as w_insert_dt
    , json:acct_id::int                                                              as acct_id
    , json:is_mth_end::int                                                           as is_month_end
    , to_timestamp(json:first_day_of_mth::text , 'MM/DD/YYYY HH12:MI:SS AM')         as first_day_of_month
    , to_timestamp(json:last_day_of_mth::text , 'MM/DD/YYYY HH12:MI:SS AM')          as last_day_of_month
    , json:assignment_id::int                                                        as assignment_id
    , json:age_band::text                                                            as age_band
    , json:action_description::text                                                  as action_description
    , json:invol_term_event_ind::int                                                 as in_vol_term_event_ind
    , json:term_event_ind::int                                                       as term_event_ind
    , json:rehire_event_ind::int                                                     as rehire_event_ind
    , json:vol_term_event_ind::int                                                   as vol_term_event_ind
    , json:job_name::text                                                            as job_name
    , json:job_change_ind::int                                                       as job_change_ind
    , json:hire_event_ind::int                                                       as hire_event_ind
    , json:cal_day_id::int                                                           as cal_day_id
    , json:transfer_event_ind::int                                                   as transfer_event_ind
    , json:salary_basis::text                                                        as salary_basis

    , effective_date::date                                                           as effective_date
    , {{ col_is_head(reference=source('oracle','faw_census'),
        reference_date_col='effective_date',
        source_date_col='effective_date') }}
    , _created_at::datetime                                                          as _created_at
    , _id::int                                                                       as _id
from {{ source('oracle', 'faw_census') }}
