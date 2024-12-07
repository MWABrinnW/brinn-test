select
    a.content:alclientid::integer               as fkalclient
    , a.content:pkuser::integer                 as pkuser
    , a.content:userid::varchar(250)            as userid
    , a.content:entityenum::integer             as entityenum
    , a.content:entitydesc::varchar(50)         as entitydesc
    , a.content:activedate::timestamp           as activedate
    , a.content:inactivedate::timestamp         as inactivedate
    , a.content:isactive::boolean::int          as isactive
    , a.content:userkey::integer                as userkey
    , a.content:fkgroup::integer                as fkgroup
    , a.content:isreset::boolean::int           as isreset
    , a.content:lastlogin::timestamp            as lastlogin
    , a.content:legacylastlogin::timestamp      as legacylastlogin
    , a.content:lastpasswordchange::timestamp   as lastpasswordchange
    , a.content:usercreatedby::varchar(150)     as usercreatedby
    , a.content:usercreateddate::timestamp      as usercreateddate
    , a.content:editedby::varchar(150)          as editedby
    , a.content:editeddate::timestamp           as editeddate
    , a.content:isactivedirectory::boolean::int as isactivedirectory
    , a.content:fkpersonal::integer             as fkpersonal
    , a.content:fkpartnerapp::integer           as fkpartnerapp
    , a.content:createddate::timestamp          as createddate
    , a.effective_at::date                      as effective_date
    , a._pk::varchar(200)                       as _pk

    , a._extracted_at::timestamp_ntz            as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_user'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                           as _is_full
    , a._created_at::timestamp_ntz              as _created_at
    , a._source_file                            as _source_file
    , a._checksum                               as _checksum
from {{ source('orion', 'vw_user') }} as a
