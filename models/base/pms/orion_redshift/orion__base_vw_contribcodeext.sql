select
    ci.clientname                       as clientname
  , content:fkalclient::integer         as fkalclient
  , content:fkcontribcode::integer      as fkcontribcode
  , content:displayvalue::varchar(50)   as displayvalue
  , content:code::varchar(50)           as code
  , content:purchasetype::varchar(3)    as purchasetype
  , content:purchasesubtype::varchar(3) as purchasesubtype
  , content:isprioryear::boolean::int   as isprioryear
  , content:isira::boolean::int         as isira
  , a.effective_at::date                as effective_date
  , a._pk::varchar(200)                 as _pk
  , a._client::int                      as _client
  , a._extracted_at                     as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_contribcodeext'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                     as _is_full
  , a._created_at                       as _created_at
  , a._source_file                      as _source_file
  , a._checksum                         as _checksum
from {{ source('orion', 'stg_vw_contribcodeext') }} a
join {{ ref('orion__base_vw_clientinfo') }}         ci
     on a._client::int = ci.pkalclient
