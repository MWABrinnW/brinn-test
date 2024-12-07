select
    ci.clientname                                     as clientname
    , ci.system_name                                  as system_name
    , ci.system_instance                              as system_instance
    , ci.system_key                                   as system_key
    , ci.firm_source                                  as firm_source
    , a.content:fkalclient::integer                   as fkalclient
    , a.content:pkproductclass::integer               as pkproductclass
    , a.content:name::varchar(60)                     as name
    , a.content:description::varchar(300)             as description
    , a.content:category::varchar(30)                 as category
    , a.content:subcategory::varchar(60)              as subcategory
    , a.content:isdefault::boolean::int               as isdefault
    , a.content:riskscore::double precision           as riskscore
    , a.content:color::varchar(60)                    as color
    , a.content:classlevel::integer                   as classlevel
    , a.content:sortorder1::integer                   as sortorder1
    , a.content:sortorder2::integer                   as sortorder2
    , a.content:fkproductcategory::integer            as fkproductcategory
    , a.content:externalid::varchar(60)               as externalid
    , a.content:fkproductdescriptionprovider::integer as fkproductdescriptionprovider
    , a.content:rebalancepriority::integer            as rebalancepriority
    , a.content:rebalancesellpriority::integer        as rebalancesellpriority
    , a.content:createddate::timestamp                as createddate
    , a.effective_at::date                            as effective_date
    , a._pk::varchar(200)                             as _pk

    , a._extracted_at::timestamp_ntz                  as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_productclass'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                 as _is_full
    , a._created_at::timestamp_ntz                    as _created_at
    , a._source_file                                  as _source_file
    , a._checksum                                     as _checksum
from {{ source('orion', 'vw_productclass') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
