select
    content:alclientid::integer             as fkalclient
  , content:pkuser::integer                 as pkuser
  , content:userid::varchar(250)            as userid
  , content:entityenum::integer             as entityenum
  , content:entitydesc::varchar(50)         as entitydesc
  , content:activedate::timestamp           as activedate
  , content:inactivedate::timestamp         as inactivedate
  , content:isactive::boolean::int          as isactive
  , content:userkey::integer                as userkey
  , content:fkgroup::integer                as fkgroup
  , content:isreset::boolean::int           as isreset
  , content:lastlogin::timestamp            as lastlogin
  , content:legacylastlogin::timestamp      as legacylastlogin
  , content:lastpasswordchange::timestamp   as lastpasswordchange
  , content:usercreatedby::varchar(150)     as usercreatedby
  , content:usercreateddate::timestamp      as usercreateddate
  , content:editedby::varchar(150)          as editedby
  , content:editeddate::timestamp           as editeddate
  , content:isactivedirectory::boolean::int as isactivedirectory
  , content:fkpersonal::integer             as fkpersonal
  , content:fkpartnerapp::integer           as fkpartnerapp
  , content:createddate::timestamp          as createddate
  , a.effective_at::date                    as effective_date
  , a._pk::varchar(200)                     as _pk
  , a._client::int                          as _client
  , a._extracted_at                         as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_user'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                         as _is_full
  , a._created_at                           as _created_at
  , a._source_file                          as _source_file
  , a._checksum                             as _checksum
from {{ source('orion', 'vw_user') }} a
