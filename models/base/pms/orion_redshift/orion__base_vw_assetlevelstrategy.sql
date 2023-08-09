select
    ci.clientname                         as clientname
  , content:fkalclient::integer           as fkalclient
  , content:pkassetlevelstrategy::integer as pkassetlevelstrategy
  , content:itemkey::varchar(20)          as itemkey
  , content:assetstrategy::varchar(150)   as assetstrategy
  , content:color::varchar(60)            as color
  , content:sortorder::integer            as sortorder
  , content:fkplatform::integer           as fkplatform
  , content:fkproductclass::integer       as fkproductclass
  , content:alscreateddate::date          as alscreateddate
  , content:alscreatedby::varchar(60)     as alscreatedby
  , content:editeddate::date              as editeddate
  , content:editedby::varchar(60)         as editedby
  , content:createddate::timestamp        as createddate
  , a.effective_at::date                  as effective_date
  , a._pk::varchar(200)                   as _pk
  , a._client::int                        as _client
  , a._extracted_at                       as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_assetlevelstrategy'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                       as _is_full
  , a._created_at                         as _created_at
  , a._source_file                        as _source_file
  , a._checksum                           as _checksum
from {{ source('orion', 'stg_vw_assetlevelstrategy') }} a
join {{ ref('orion__base_vw_clientinfo') }}             ci
     on a._client::int = ci.pkalclient
