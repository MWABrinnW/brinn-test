
select
    json:id::int                                                          as id
  , json:job:value::varchar(100)                                          as job
  , json:job:id::int                                                      as job_id
  , to_timestamp(json:updateddate::varchar(100), 'yyyy-mm-dd hh12:mi am') as updated_date
  , json:addresses[0]:addresscity::varchar(100)                           as address_city
  , json:addresses[0]:entry::int                                          as entry
  , json:addresses[0]:addresszip::varchar(100)                            as zip_code
  , json:addresses[0]:addressstate:id::varchar(100)                       as address_state_id
  , json:addresses[0]:addressesstate:abbrev::varchar(10)                  as address_state_abbrev
  , json:addresses[0]:addressstate:value::varchar(100)                    as address_state
  , json:addresses[0]:addresscountry:id::varchar(100)                     as address_country_id
  , json:addresses[0]:addresscountry:abbrev::varchar(10)                  as address_country_abbrev
  , json:addresses[0]:addresscountry:value::varchar(100)                  as address_country
  , json:addresses[0]:addresstype:id::varchar(100)                        as address_type_id
  , json:addresses[0]:addresstype:value::varchar(100)                     as address_type
  , json:addresses[0]:addressstreet1::varchar(100)                        as address_street_1
  , json:addresses[0]:primary::varchar(10)                                as address_primary
  , json:firstname::varchar(100)                                          as first_name
  , json:middlename::varchar(100)                                         as middle_name
  , json:lastname::varchar(100)                                           as last_name
  , json:education[0]:entry::int                                          as education_entry
  , json:education[0]:major:id::varchar(100)                              as major_id
  , json:education[0]:major:value::varchar(100)                           as major
  , json:education[0]:school:id::varchar(100)                             as school_id
  , json:education[0]:school:value::varchar(100)                          as school
  , json:education[0]:degree:id::varchar(100)                             as degree_id
  , json:education[0]:degree:value::varchar(100)                          as degree
  , json:education[0]:gpa::decimal(4, 3)                                  as gpa
  , json:education[0]:graduationdate::date                                as graduation_date
  , json:education[0]:educationstartdate::date                            as education_start_date
  , json:race::varchar(100)                                               as race
  , json:gender::varchar(100)                                             as gender
  , json:veteran::varchar(100)                                            as veteran
  , json:phones[0]:phonetype:id::varchar(100)                             as phone_type_id
  , json:phones[0]:phonetype:value::varchar(100)                          as phone_type
  , json:phones[0]:entry::int                                             as phone_entry
  , json:phones[0]:phonenumber::varchar(100)                              as phone_number
  , json:phones[0]:primary::varchar(10)                                   as primary_phone
  , json:sourcename::varchar(100)                                         as source_name
  , json:source::varchar(100)                                             as source
  , json:sourcedevice::varchar(100)                                       as source_device
  , json:sourceportal::varchar(100)                                       as source_portal
  , json:sourcechannel::varchar(100)                                      as source_channel
  , json:folder:id::varchar(100)                                          as folder_id
  , json:folder:value::varchar(100)                                       as folder
  , json:supervisor:value::varchar(100)                                   as supervisor
  , json:supervisor:id::int                                               as supervisor_id
  , json:email::varchar(100)                                              as email
  , json:hiredate::date                                                   as hire_date
  , json:postartdate::date                                                as position_start_date
  , json:startdate::date                                                  as start_date
  , record_datetime
from {{ source('icims', 'json_data') }}
where 1 = 1
  and object_type = 'people'
