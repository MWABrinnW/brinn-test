select
    _data:clientid::text(200)                                          as clientid
    , to_timestamp_ntz((_data:"amountasof"::text(200)) , 'YYYY-MM-DD') as amountasof
    , _data:assetvalue::dec(20 , 2)                                    as assetvalue
    , _data:liabilityvalue::dec(20 , 2)                                as liabilityvalue
    , _data:investiblevalue::dec(20 , 2)                               as investiblevalue
    , _created_at::date                                                as record_date
    , _created_at::timestampntz                                        as record_datetime
    , effective_date::date                                             as effective_date
    , _created_at::timestampntz                                        as _created_at
    , _source_file::text(200)                                          as _source_file
    , _id::int                                                         as _id
    , {{ col_is_head(reference=source('emoney_mwa', 'net_worth_history')) }}
from {{ source('emoney_mwa','net_worth_history') }}
