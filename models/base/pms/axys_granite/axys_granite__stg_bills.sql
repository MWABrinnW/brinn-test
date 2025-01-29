select
  'axys'                                         as system_name
  , 'granite'                                    as system_instance
  , concat(system_name , '__' , system_instance) as system_key
  , 'mwa'                                        as firm_source
  , json:"Acct"::varchar(200)                    as account
  , json:"Amount"::number(20,5)                  as amount
  , json:"Comments"::varchar(200)                as comments
  , json:"Covoff"::varchar(200)                  as covoff
  , json:"Date"::date                            as date
  , json:"Invoice"::varchar(200)                 as invoice
  , json:"Portfolio"::varchar(200)               as portfolio
  , json:"Security"::varchar(200)                as security
  , json:"Tran"::varchar(200)                    as tran
  , json:"description"::varchar(200)             as description
  , json:"etag"::varchar(200)                    as etag
  , _id::int                                     as _id
  , _created_at::timestampntz                    as _created_at
  , _box_file_id::varchar(200)                   as _box_file_id
  , _box_file_name::varchar(200)                 as _box_file_name
  , _box_meta::variant                           as _box_meta
from {{ source('axys_granite', 'bills') }}
