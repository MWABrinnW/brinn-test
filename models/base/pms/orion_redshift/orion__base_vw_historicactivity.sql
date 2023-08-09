select
    ci.clientname                         as clientname
  , content:fkalclient::integer           as fkalclient
  , content:fkasset::integer              as fkasset
  , content:asofdate::date                as asofdate
  , content:_2::double precision          as _2
  , content:_4::double precision          as _4
  , content:_8::double precision          as _8
  , content:_1::double precision          as _1
  , content:_16::double precision         as _16
  , content:_32::double precision         as _32
  , content:_128::double precision        as _128
  , content:_256::double precision        as _256
  , content:_512::double precision        as _512
  , content:_1024::double precision       as _1024
  , content:_2048::double precision       as _2048
  , content:_4096::double precision       as _4096
  , content:_8192::double precision       as _8192
  , content:_16384::double precision      as _16384
  , content:_32768::double precision      as _32768
  , content:_65536::double precision      as _65536
  , content:_131072::double precision     as _131072
  , content:_536870912::double precision  as _536870912
  , content:_1073741824::double precision as _1073741824
  , content:createddate::timestamp        as createddate
  , a.effective_at::date                  as effective_date
  , a._pk::varchar(200)                   as _pk
  , a._client::int                        as _client
  , a._extracted_at                       as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_historicactivity'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                       as _is_full
  , a._created_at                         as _created_at
  , a._source_file                        as _source_file
  , a._checksum                           as _checksum
from {{ source('orion', 'stg_vw_historicactivity') }} a
join {{ ref('orion__base_vw_clientinfo') }}           ci
     on a._client::int = ci.pkalclient
