
select
    'lpl'                               as custodian
  , subscriberid::varchar(5)            as subscriber_id
  , case
        when subscriberid::varchar(5) in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                as firm_source
  , clientid::int                       as client_id
  , repid::varchar(200)                 as rep_id
  , ssntin::varchar(200)                as ssn_tin
  , isssn::varchar(200)                 as is_ssn
  , to_date(birthdate, 'MM/DD/YYYY')    as birth_date
  , firstname::varchar(200)             as first_name
  , middlename::varchar(200)            as middle_name
  , lastname::varchar(200)              as last_name
  , address1::varchar(200)              as address_1
  , address2::varchar(200)              as address_2
  , address3::varchar(200)              as address_3
  , city::varchar(200)                  as city
  , state::varchar(200)                 as state
  , zipcode::varchar(200)               as zip_code
  , homephoneno::varchar(200)           as home_phone_no
  , businessphoneno::varchar(200)       as business_phone_no
  , emailaddress::varchar(200)          as email_address
  , to_date(createdate, 'MM/DD/YYYY')   as create_date
  , to_date(modifieddate, 'MM/DD/YYYY') as modified_date
  , mobilephoneno::varchar(200)                       as mobile_phone_no
  , marketvalue::decimal(20, 2)         as market_value
  , isforeign::int                      as is_foreign
  , {{ col_is_head(reference=source('lpl_network', 'client')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                as effective_date
  , _created_at::timestamp              as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'client') }}