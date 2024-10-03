select
    _data:advisorid::text(200)                      as advisorid
    , _data:firstname::text(200)                    as firstname--noqa: RF04
    , _data:lastname::text(200)                     as lastname--noqa: RF04
    , nullif(_data:companyname , '')::text(200)     as companyname
    , nullif(_data:address1 , '')::text(200)        as address1
    , nullif(_data:address2 , '')::text(200)        as address2
    , nullif(_data:city , '')::text(200)            as city
    , nullif(_data:stateorprovince , '')::text(200) as stateorprovince
    , nullif(_data:postalcode , '')::text(200)      as postalcode
    , nullif(_data:businessphone , '')::text(200)   as businessphone
    , nullif(_data:cellphone , '')::text(200)       as cellphone
    , nullif(_data:fax , '')::text(200)             as fax
    , _data:email::text(200)                        as email--noqa: RF04
    , _data:officeid::text(200)                     as officeid
    , _created_at::date                             as record_date
    , _created_at::timestampntz                     as record_datetime
    , effective_date::date                          as effective_date
    , _created_at::timestampntz                     as _created_at
    , _source_file::text(200)                       as _source_file
    , _id::int                                      as _id
    , {{ col_is_head(reference=source('emoney_mwa', 'advisors')) }}
from {{ source('emoney_mwa', 'advisors') }}
