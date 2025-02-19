select
    json:assignment_number::text(200)                                                as assignment_number
    , json:person_number::text(200)                                                  as person_number
    , json:employee_reporting_id::text(200)                                          as employee_reporting_id
    , json:person_id::text(200)                                                      as person_id
    , json:age_in_years::int                                                         as age_in_years
    , json:assignment_status_name::text(200)                                         as assignment_status_name
    , json:asgn_action_code::text(200)                                               as assignment_action_code
    , json:action_type_code::text(200)                                               as action_type_code
    , try_to_date(json:asgn_effective_start_date::text , 'MM/DD/YYYY HH12:MI:SS AM') as assignment_effective_start_date
    , json:business_unit_name::text(200)                                             as business_unit_name
    , try_to_date(json:calendar_date::text , 'MM/DD/YYYY HH12:MI:SS AM')             as calendar_date
    , try_to_date(json:date_start::text , 'MM/DD/YYYY HH12:MI:SS AM')                as date_start
    , try_to_date(json:actual_termination_date::text , 'MM/DD/YYYY HH12:MI:SS AM')   as actual_termination_date
    , json:termination_type::text(200)                                               as termination_type
    , json:department_name::text(200)                                                as department_name
    , json:division::text(200)                                                       as division
    , json:ethnicity_name::text(200)                                                 as ethnicity_name
    , json:fte::int                                                                  as fte
    , json:full_name::text(200)                                                      as full_name
    , json:full_part_time_flag::text(200)                                            as full_part_time_flag
    , json:job_family_code::text(200)                                                as job_family_code
    , json:job_family_name::text(200)                                                as job_family_name
    , json:job_function_name::text(200)                                              as job_function_name
    , json:job_id::text(200)                                                         as job_id
    , json:mariner_job_id::text(200)                                                 as mariner_job_id
    , json:legal_employer_name::text(200)                                            as legal_employer_name
    , json:location_code::text(200)                                                  as location_code
    , json:location_name::text(200)                                                  as location_name
    , json:mgmt_lvl::text(200)                                                       as mgmt_lvl
    , json:mgr_assgn_number::text(200)                                               as mgr_assgn_number
    , json:mgr_full_name::text(200)                                                  as mgr_full_name
    , json:mgr_person_number::text(200)                                              as mgr_person_number
    , json:per_system_status::text(200)                                              as per_system_status
    , json:real_estate_code::text(200)                                               as real_estate_code
    , json:region::text(200)                                                         as region
    , json:sector::text(200)                                                         as sector
    , json:system_person_type::text(200)                                             as system_person_type
    , json:tenure_in_years::int                                                      as tenure_in_years
    , json:action_name::text(200)                                                    as action_name
    , json:action_reason_code::text(200)                                             as action_reason_code
    , json:dflt_expense_acct::text(200)                                              as cost_num
    , json:gender::text(200)                                                         as gender
    , json:people_grp::text(200)                                                     as people_group
    , json:source::text(200)                                                         as source
    , json:start_count::int                                                          as start_count
    , json:end_count::int                                                            as end_count
    , json:new_count::int                                                            as new_count
    , json:term_count::int                                                           as term_count
    , json:integration_id::text(200)                                                 as integration_id
    , to_timestamp(json:w_insert_dt::text , 'MM/DD/YYYY HH12:MI:SS AM')              as w_insert_dt
    , json:acct_id::int                                                              as acct_id
    , json:is_mth_end::int                                                           as is_month_end
    , to_timestamp(json:first_day_of_mth::text , 'MM/DD/YYYY HH12:MI:SS AM')         as first_day_of_month
    , to_timestamp(json:last_day_of_mth::text , 'MM/DD/YYYY HH12:MI:SS AM')          as last_day_of_month
    , json:assignment_id::int                                                        as assignment_id
    , json:age_band::text(200)                                                       as age_band
    , json:action_description::text(200)                                             as action_description
    , json:invol_term_event_ind::int                                                 as in_vol_term_event_ind
    , json:term_event_ind::int                                                       as term_event_ind
    , json:rehire_event_ind::int                                                     as rehire_event_ind
    , json:vol_term_event_ind::int                                                   as vol_term_event_ind
    , json:job_name::text(200)                                                       as job_name
    , json:job_change_ind::int                                                       as job_change_ind
    , json:hire_event_ind::int                                                       as hire_event_ind
    , json:cal_day_id::int                                                           as cal_day_id
    , json:transfer_event_ind::int                                                   as transfer_event_ind

    , effective_date::date                                                           as effective_date
    , {{ col_is_head(reference=source('oracle','faw_census'),
        reference_date_col='effective_date',
        source_date_col='effective_date') }}
    , _created_at::datetime                                                          as _created_at
    , _id::int                                                                       as _id
from {{ source('oracle', 'faw_census') }}
