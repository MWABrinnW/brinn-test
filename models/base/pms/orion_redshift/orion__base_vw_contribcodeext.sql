select
    ci.clientname                           as clientname
    , ci.system_name                        as system_name
    , ci.system_instance                    as system_instance
    , ci.system_key                         as system_key
    , ci.firm_source                        as firm_source
    , a.content:fkalclient::integer         as fkalclient
    , a.content:fkcontribcode::integer      as fkcontribcode
    , a.content:displayvalue::varchar(50)   as displayvalue
    , a.content:code::varchar(50)           as code
    , a.content:purchasetype::varchar(3)    as purchasetype
    , a.content:purchasesubtype::varchar(3) as purchasesubtype
    , a.content:isprioryear::boolean::int   as isprioryear
    , a.content:isira::boolean::int         as isira
    , a.effective_at::date                  as effective_date
    , a._pk::varchar(200)                   as _pk

    , a._extracted_at::timestamp_ntz        as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_contribcodeext'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                       as _is_full
    , a._created_at::timestamp_ntz          as _created_at
    , a._source_file                        as _source_file
    , a._checksum                           as _checksum
from {{ source('orion', 'vw_contribcodeext') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
