select
    ci.clientname                             as clientname
  , content:fkalclient::integer               as fkalclient
  , content:pkwholesaler::integer             as pkwholesaler
  , content:fkpersonal::integer               as fkpersonal
  , content:startdate::date                   as startdate
  , content:enddate::date                     as enddate
  , content:importkey::varchar(60)            as importkey
  , content:importdate::date                  as importdate
  , content:fkwholesalerglobal::integer       as fkwholesalerglobal
  , content:whcreateddate::date               as whcreateddate
  , content:whcreatedby::varchar(50)          as whcreatedby
  , content:editeddate::date                  as editeddate
  , content:editedby::varchar(50)             as editedby
  , content:timestampwholesaler::varchar(200) as timestampwholesaler
  , content:createddate::timestamp            as createddate
  , a.effective_at::date                      as effective_date
  , a._pk::varchar(200)                       as _pk
  , a._client::int                            as _client
  , a._extracted_at                           as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_wholesaler'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'stg_vw_wholesaler') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
