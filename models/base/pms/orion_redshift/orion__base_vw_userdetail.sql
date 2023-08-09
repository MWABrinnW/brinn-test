select
    ci.clientname                       as clientname
  , content:alclientid::integer         as fkalclient
  , content:fkuser::integer             as fkuser
  , content:fkloginentity::integer      as fkloginentity
  , content:entitydesc::varchar(50)     as entitydesc
  , content:userkey::integer            as userkey
  , content:isuserdefault::boolean::int as isuserdefault
  , content:usercreatedby::varchar(50)  as usercreatedby
  , content:usercreateddate::timestamp  as usercreateddate
  , content:editedby::varchar(50)       as editedby
  , content:editeddate::timestamp       as editeddate
  , content:fkrole::integer             as fkrole
  , content:createddate::timestamp      as createddate
  , a.effective_at::date                as effective_date
  , a._pk::varchar(200)                 as _pk
  , a._client::int                      as _client
  , a._extracted_at                     as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_userdetail'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                     as _is_full
  , a._created_at                       as _created_at
  , a._source_file                      as _source_file
  , a._checksum                         as _checksum
from {{ source('orion', 'stg_vw_userdetail') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
