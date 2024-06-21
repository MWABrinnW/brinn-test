select
    json:age_in_years::int                                                              as age_in_years
    , json:assignment_number::varchar(200)                                              as assignment_number
    , json:assignment_status_name::varchar(200)                                         as assignment_status_name
    , json:business_unit_name::varchar(200)                                             as business_unit_name
    , to_timestamp(json:calendar_date::varchar(200) , 'MM/DD/YYYY HH12:MI:SS AM')::date as calendar_date
    , to_timestamp(json:date_start::varchar(200) , 'MM/DD/YYYY HH12:MI:SS AM')::date    as date_start
    , json:department_name::varchar(200)                                                as department_name
    , json:division::varchar(200)                                                       as division
    , json:employee_reporting_id::varchar(200)                                          as employee_reporting_id
    , json:ethnicity_name::varchar(200)                                                 as ethnicity_name
    , json:fte::int                                                                     as fte
    , json:full_name::varchar(200)                                                      as full_name
    , json:full_part_time_flag::varchar(200)                                            as full_part_time_flag
    , json:job_family_code::varchar(200)                                                as job_family_code
    , json:job_family_name::varchar(200)                                                as job_family_name
    , json:job_function_name::varchar(200)                                              as job_function_name
    , json:job_id::varchar(200)                                                         as job_id
    , json:legal_employer_name::varchar(200)                                            as legal_employer_name
    , json:location_code::varchar(200)                                                  as location_code
    , json:location_name::varchar(200)                                                  as location_name
    , json:mgmt_lvl::varchar(200)                                                       as mgmt_lvl
    , json:mgr_assgn_number::varchar(200)                                               as mgr_assgn_number
    , json:mgr_full_name::varchar(200)                                                  as mgr_full_name
    , json:mgr_person_number::varchar(200)                                              as mgr_person_number
    , json:per_system_status::varchar(200)                                              as per_system_status
    , json:person_number::varchar(200)                                                  as person_number
    , json:real_estate_code::varchar(200)                                               as real_estate_code
    , json:region::varchar(200)                                                         as region
    , json:sector::varchar(200)                                                         as sector
    , json:system_person_type::varchar(200)                                             as system_person_type
    , json:tenure_in_years::int                                                         as tenure_in_years
    , effective_date::date                                                              as effective_date
    , _created_at::datetime                                                             as _created_at
    , _id::int                                                                          as _id
from {{ source('oracle', 'faw_census') }}
