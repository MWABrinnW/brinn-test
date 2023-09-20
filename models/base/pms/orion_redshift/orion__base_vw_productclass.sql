select
    ci.clientname                                 as clientname
  , content:fkalclient::integer                   as fkalclient
  , content:pkproductclass::integer               as pkproductclass
  , content:name::varchar(60)                     as name
  , content:description::varchar(300)             as description
  , content:category::varchar(30)                 as category
  , content:subcategory::varchar(60)              as subcategory
  , content:isdefault::boolean::int               as isdefault
  , content:riskscore::double precision           as riskscore
  , content:color::varchar(60)                    as color
  , content:classlevel::integer                   as classlevel
  , content:sortorder1::integer                   as sortorder1
  , content:sortorder2::integer                   as sortorder2
  , content:fkproductcategory::integer            as fkproductcategory
  , content:externalid::varchar(60)               as externalid
  , content:fkproductdescriptionprovider::integer as fkproductdescriptionprovider
  , content:rebalancepriority::integer            as rebalancepriority
  , content:rebalancesellpriority::integer        as rebalancesellpriority
  , content:createddate::timestamp                as createddate
  , a.effective_at::date                          as effective_date
  , a._pk::varchar(200)                           as _pk
  , a._client::int                                as _client
  , a._extracted_at                               as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_productclass'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                               as _is_full
  , a._created_at                                 as _created_at
  , a._source_file                                as _source_file
  , a._checksum                                   as _checksum
from {{ source('orion', 'vw_productclass') }} a
join {{ ref('orion__base_vw_clientinfo') }}       ci
     on a._client::int = ci.pkalclient
