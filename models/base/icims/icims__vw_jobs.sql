
select
    json:jobid::varchar(100)                                              as id
  , to_timestamp(json:updateddate::varchar(100), 'yyyy-mm-dd hh12:mi am') as updated_date
  , json:updatedby:value::varchar(100)                                    as updated_by
  , json:updatedby:id::int                                                as updated_by_id
  , json:jobtitle::varchar(100)                                           as job_title
  , json:hiringmanager:profile::varchar(100)                              as hiring_manager_profile
  , json:hiringmanager:value::varchar(100)                                as hiring_manager
  , json:hiringmanager:id::int                                            as hiring_manager_id
  , json:numberofpositions::int                                           as number_of_positions
  , json:joblocation:value::varchar(100)                                  as job_location
  , json:joblocation:id::int                                              as job_location_id
  , json:positioncategory:value::varchar(100)                             as position_category
  , json:positioncategory:id::varchar(50)                                 as position_category_id
  , json:positioncategory:soccode::int                                    as position_category_soccode
  , json:recruiter:profile::varchar(100)                                  as recruiter_profile
  , json:recruiter:id::int                                                as recruiter_id
  , json:recruiter:value::varchar(100)                                    as recruiter
  , json:folder:value::varchar(100)                                       as folder
  , json:folder:id::varchar(100)                                          as folder_id
  , json:startdate::date                                                  as start_date
  , json:jobtype:value::varchar(100)                                      as job_type
  , json:jobtype:id::varchar(100)                                         as job_type_id
  , json:eeocategory:value::varchar(100)                                  as eeocategory
  , json:eeocategory:id::varchar(100)                                     as eeocategory_id
  , json:jobnumber::varchar(100)                                          as job_number
  , json:positiontype:value::varchar(100)                                 as position_type
  , json:positiontype:id::varchar(100)                                    as position_type_id
  , json:createdby:value::varchar(100)                                    as profile
  , json:createdby:id::varchar(100)                                       as profile_id
  , json:hiretype:value::varchar(100)                                     as hire
  , json:hiretype:id::varchar(100)                                        as hire_id
  , json:joblocation:companyid::varchar(100)                              as company_id
  , json:joblocation:address::varchar(100)                                as company_address
  , json:minimumsalary:timeframe::varchar(100)                            as minimum_salary_timeframe
  , json:minimumsalary:amount::int                                        as minimum_salary_amount
  , json:minimumsalary:currency::varchar(100)                             as minimum_salary_currency
  , json:maximumsalary:timeframe::varchar(100)                            as maximum_salary_timeframe
  , json:maximumsalary:amount::int                                        as maximum_salary_amount
  , json:maximumsalary:currency::string                                   as maximum_salary_currency
  , json:overview::varchar(5000)                                          as overview
  , json:responsibilities::varchar(20000)                                 as responsibilities
  , record_datetime
from {{ source('icims', 'json_data') }}
where 1 = 1
  and object_type = 'jobs'
