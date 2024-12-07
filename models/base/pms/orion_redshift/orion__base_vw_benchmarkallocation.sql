select
    ci.clientname                              as clientname
    , ci.system_name                           as system_name
    , ci.system_instance                       as system_instance
    , ci.system_key                            as system_key
    , ci.firm_source                           as firm_source
    , a.content:fkalclient::integer            as fkalclient
    , a.content:fkindexblend::integer          as fkindexblend
    , a.content:fkproduct::integer             as fkproduct
    , a.content:asofdate::date                 as asofdate
    , a.content:fkentity::integer              as fkentity
    , a.content:blendname::varchar(200)        as blendname
    , a.content:color::varchar(20)             as color
    , a.content:rebalanceinterval::varchar(50) as rebalanceinterval
    , a.content:benchmarktype::varchar(50)     as benchmarktype
    , a.content:entityenum::integer            as entityenum
    , a.content:blendweight::double precision  as blendweight
    , a.content:target::double precision       as target
    , a.content:createddate::timestamp         as createddate
    , a.effective_at::date                     as effective_date
    , a._pk::varchar(200)                      as _pk

    , a._extracted_at::timestamp_ntz           as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_benchmarkallocation'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                          as _is_full
    , a._created_at::timestamp_ntz             as _created_at
    , a._source_file                           as _source_file
    , a._checksum                              as _checksum
from {{ source('orion', 'vw_benchmarkallocation') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
