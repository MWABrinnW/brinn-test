select
    _data:domain::text(200)       as domain--noqa: RF04
    , _data:userid::text(200)     as userid
    , _data:externalid::text(200) as externalid
    , _created_at::date           as record_date
    , _created_at::timestampntz   as record_datetime
    , effective_date::date        as effective_date
    , _created_at::timestampntz   as _created_at
    , _source_file::text(200)     as _source_file
    , _id::int                    as _id
from {{ source('emoney_mwa','user') }}
