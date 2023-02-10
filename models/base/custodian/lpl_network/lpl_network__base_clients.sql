
select
    clientid::int                       as client_id
  , repid                               as rep_id
  , subscriberid::varchar(5)            as subscriber_id
  , ssntin                              as ssn_tin
  , isssn                               as is_ssn
  , to_date(birthdate, 'MM/DD/YYYY')    as birth_date
  , firstname                           as first_name
  , middlename                          as middle_name
  , lastname                            as last_name
  , address1                            as address_1
  , address2                            as address_2
  , address3                            as address_3
  , city                                as city
  , state                               as state
  , zipcode                             as zip_code
  , homephoneno                         as home_phone_no
  , businessphoneno                     as business_phone_no
  , emailaddress                        as email_address
  , to_date(createdate, 'MM/DD/YYYY')   as create_date
  , to_date(modifieddate, 'MM/DD/YYYY') as modified_date
  , mobilephoneno                       as mobile_phone_no
  , marketvalue::decimal(20, 2)         as market_value
  , isforeign::int                      as is_foreign
  , {{ col_is_head(reference=source('lpl_network', 'client')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                as effective_date
  , _created_at::timestamp              as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'client') }}