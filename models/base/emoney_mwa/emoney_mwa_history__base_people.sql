select
    _data:clientid::text(200)                              as clientid
    , _data:peopleid::text(200)                            as peopleid
    , _data:facttypename::text(200)                        as facttypename
    , _data:firstname::text(200)                           as firstname--noqa: RF04
    , _data:lastname::text(200)                            as lastname--noqa: RF04
    , nullif(_data:gender , '')::text(200)                 as gender
    , nullif(_data:maritalstatus , '')::text(200)          as maritalstatus
    , nullif(_data:citizenship , '')::text(200)            as citizenship
    , nullif(_data:dateofbirth , '')::date                 as dateofbirth
    , nullif(_data:spousefirstname , '')::text(200)        as spousefirstname
    , nullif(_data:spouselastname , '')::text(200)         as spouselastname
    , nullif(_data:spousegender , '')::text(200)           as spousegender
    , nullif(_data:spousecitizenship , '')::text(200)      as spousecitizenship
    , nullif(_data:spousedateofbirth , '')::date           as spousedateofbirth
    , nullif(_data:parentid , '')::text(200)               as parentid
    , nullif(_data:isfrompreviousmarraige , '')::text(200) as isfrompreviousmarraige
    , nullif(_data:isfinanciallydependent , '')::text(200) as isfinanciallydependent
    , nullif(_data:skipperson , '')::text(200)             as skipperson
    , nullif(_data:hasspecialneeds , '')::boolean          as hasspecialneeds
    , nullif(_data:isingoodhealth , '')::boolean           as isingoodhealth
    , _created_at::date                                    as record_date
    , _created_at::timestampntz                            as record_datetime
    , effective_date::date                                 as effective_date
    , _created_at::timestampntz                            as _created_at
    , _source_file::text(200)                              as _source_file
    , _id::int                                             as _id
    , {{ col_is_head(reference=source('emoney_mwa', 'people')) }}
from {{ source('emoney_mwa','people') }}
