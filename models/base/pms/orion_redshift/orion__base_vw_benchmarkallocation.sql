select
    ci.clientname                          as clientname
  , content:fkalclient::integer            as fkalclient
  , content:fkindexblend::integer          as fkindexblend
  , content:fkproduct::integer             as fkproduct
  , content:asofdate::date                 as asofdate
  , content:fkentity::integer              as fkentity
  , content:blendname::varchar(200)        as blendname
  , content:color::varchar(20)             as color
  , content:rebalanceinterval::varchar(50) as rebalanceinterval
  , content:benchmarktype::varchar(50)     as benchmarktype
  , content:entityenum::integer            as entityenum
  , content:blendweight::double precision  as blendweight
  , content:target::double precision       as target
  , content:createddate::timestamp         as createddate
  , a.effective_at::date                   as effective_date
  , a._pk::varchar(200)                    as _pk
  , a._client::int                         as _client
  , a._extracted_at                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_benchmarkallocation'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                        as _is_full
  , a._created_at                          as _created_at
  , a._source_file                         as _source_file
  , a._checksum                            as _checksum
from {{ source('orion', 'stg_vw_benchmarkallocation') }} a
join {{ ref('orion__base_vw_clientinfo') }}              ci
     on a._client::int = ci.pkalclient
