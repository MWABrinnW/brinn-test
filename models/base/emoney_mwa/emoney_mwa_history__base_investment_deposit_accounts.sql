select
    _data:clientid::text(200)                                                        as clientid
    , _data:accountid::text(200)                                                     as accountid
    , _data:accountname::text(200)                                                   as accountname
    , _data:totalvalue::dec(20 , 2)                                                  as totalvalue
    , to_timestamp_ntz((_data:"amountasof"::text(200)) , 'MM/DD/YYYY HH12:MI:SS AM') as amountasof
    , nullif(_data:institutionname , '')::text(200)                                  as institutionname
    , nullif(_data:holdingsvalue , '')::dec(20 , 2)                                  as holdingsvalue
    , nullif(_data:cashbalance , '')::dec(20 , 2)                                    as cashbalance
    , nullif(_data:marginbalance , '')::dec(20 , 2)                                  as marginbalance
    , nullif(_data:costbasis , '')::dec(20 , 2)                                      as costbasis
    , _data:facttypename::text(200)                                                  as facttypename
    , _data:type::text(200)                                                          as type--noqa: RF04
    , nullif(_data:subtype , '')::text(200)                                          as subtype
    , nullif(_data:included , '')::int                                               as included
    , _data:connected::int                                                           as connected
    , nullif(_data:underourmanagement , '')::text(200)                               as underourmanagement
    , nullif(_data:country , '')::text(200)                                          as country
    , nullif(_data:isemployeebenefit , '')::text(200)                                as isemployeebenefit
    , nullif(_data:deferredtaxrate , '')::text(200)                                  as deferredtaxrate
    , nullif(_data:dateestablished , '')::text(200)                                  as dateestablished
    , nullif(_data:establishedtype , '')::text(200)                                  as establishedtype
    , nullif(_data:establishedvalue , '')::text(200)                                 as establishedvalue
    , _created_at::date                                                              as record_date
    , _created_at::timestampntz                                                      as record_datetime
    , effective_date::date                                                           as effective_date
    , _created_at::timestampntz                                                      as _created_at
    , _source_file::text(200)                                                        as _source_file
    , _id::int                                                                       as _id
    , {{ col_is_head(reference=source('emoney_mwa', 'investment_deposit_accounts')) }}
from {{ source('emoney_mwa','investment_deposit_accounts') }}
