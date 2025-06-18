select
    'portfoliocenter'::varchar(200)                              as system_name
    , 'tcea'::varchar(200)                                       as system_instance
    , CONCAT(system_name , '__' , system_instance)::varchar(200) as system_key
    , 'mwa'::varchar(200)                                        as firm_source
    , GET(json , '"Billable" Value')::number(20 , 5)             as billable_value
    , json:"Account Code"::varchar(200)                          as account_code
    , json:"Account Number"::varchar(200)                        as account_number
    , json:"Amount"::number(20 , 5)                              as amount
    , json:"Collected"::date                                     as collected
    , json:"Custodian"::varchar(200)                             as custodian
    , json:"Date"::date                                          as date
    , json:"Notes"::varchar(200)                                 as notes
    , json:"Portfolio Description"::varchar(200)                 as portfolio_description
    , _id::int                                                   as _id
    , _created_at::timestampntz                                  as _created_at
    , _box_file_id::varchar(200)                                 as _box_file_id
    , _box_file_name::varchar(200)                               as _box_file_name
    , _box_meta::variant                                         as _box_meta
from {{ source('portfoliocenter_tcea', 'bills') }}
where json:"Account Number" is not null
