select
    _data:clientid::text(200)            as clientid
    , _data:accountid::text(200)         as accountid
    , _data:interestid::text(200)        as interestid
    , _data:interestownertype::text(200) as interestownertype
    , _data:interesttype::text(200)      as interesttype
    , _data:interestpercent::dec(20 , 2) as interestpercent
    , _created_at::date                  as record_date
    , _created_at::timestampntz          as record_datetime
    , effective_date::date               as effective_date
    , _created_at::timestampntz          as _created_at
    , _source_file::text(200)            as _source_file
    , _id::int                           as _id
from {{ source('emoney_mwa','entity_interests') }}
