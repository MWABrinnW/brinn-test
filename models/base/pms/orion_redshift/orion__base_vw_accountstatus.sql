select
    ci.clientname                               as clientname
  , content:fkalclient::integer                 as fkalclient
  , content:pkaccountstatus::integer            as pkaccountstatus
  , content:status::varchar(50)                 as status
  , content:statusdesc::varchar(200)            as statusdesc
  , content:sortorder::integer                  as sortorder
  , content:isvisible::boolean::int             as isvisible
  , content:includeinbusmetrics::boolean::int   as includeinbusmetrics
  , content:isdownloading::boolean::int         as isdownloading
  , content:isdemo::boolean::int                as isdemo
  , content:state::integer                      as state
  , content:isdefaultformanualadd::boolean::int as isdefaultformanualadd
  , content:createddate::timestamp              as createddate
  , a.effective_at::date                        as effective_date
  , a._pk::varchar(200)                         as _pk
  , a._client::int                              as _client
  , a._extracted_at                             as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_accountstatus'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                             as _is_full
  , a._created_at                               as _created_at
  , a._source_file                              as _source_file
  , a._checksum                                 as _checksum
from {{ source('orion', 'vw_accountstatus') }} a
join {{ ref('orion__base_vw_clientinfo') }}    ci
     on a._client::int = ci.pkalclient
