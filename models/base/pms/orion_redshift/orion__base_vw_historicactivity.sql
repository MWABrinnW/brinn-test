select
    ci.clientname                             as clientname
    , ci.system_name                          as system_name
    , ci.system_instance                      as system_instance
    , ci.system_key                           as system_key
    , ci.firm_source                          as firm_source
    , a.content:fkalclient::integer           as fkalclient
    , a.content:fkasset::integer              as fkasset
    , a.content:asofdate::date                as asofdate
    , a.content:_2::double precision          as _2
    , a.content:_4::double precision          as _4
    , a.content:_8::double precision          as _8
    , a.content:_1::double precision          as _1
    , a.content:_16::double precision         as _16
    , a.content:_32::double precision         as _32
    , a.content:_128::double precision        as _128
    , a.content:_256::double precision        as _256
    , a.content:_512::double precision        as _512
    , a.content:_1024::double precision       as _1024
    , a.content:_2048::double precision       as _2048
    , a.content:_4096::double precision       as _4096
    , a.content:_8192::double precision       as _8192
    , a.content:_16384::double precision      as _16384
    , a.content:_32768::double precision      as _32768
    , a.content:_65536::double precision      as _65536
    , a.content:_131072::double precision     as _131072
    , a.content:_536870912::double precision  as _536870912
    , a.content:_1073741824::double precision as _1073741824
    , a.content:createddate::timestamp        as createddate
    , a.effective_at::date                    as effective_date
    , a._pk::varchar(200)                     as _pk

    , a._extracted_at::timestamp_ntz          as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_historicactivity'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                         as _is_full
    , a._created_at::timestamp_ntz            as _created_at
    , a._source_file                          as _source_file
    , a._checksum                             as _checksum
from {{ source('orion', 'vw_historicactivity') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
