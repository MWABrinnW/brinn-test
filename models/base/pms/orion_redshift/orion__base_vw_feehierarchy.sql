select
    ci.clientname                              as clientname
  , content:fkalclient::integer                as fkalclient
  , content:pkfeehierarchy::integer            as pkfeehierarchy
  , content:pkfeehierarchycollectfrom::integer as pkfeehierarchycollectfrom
  , content:entityname::varchar(300)           as entityname
  , content:entityid::integer                  as entityid
  , content:entityenum::integer                as entityenum
  , content:status::boolean::int               as status
  , content:fkbillentity::integer              as fkbillentity
  , content:fkbillschedule::integer            as fkbillschedule
  , content:fkcustodian::integer               as fkcustodian
  , content:fkfeehierarchyglobal::integer      as fkfeehierarchyglobal
  , content:producttype::integer               as producttype
  , content:feehierarchytype::integer          as feehierarchytype
  , content:feehierarchytypename::varchar(50)  as feehierarchytypename
  , content:methodtype::integer                as methodtype
  , content:softdeletekey::integer             as softdeletekey
  , content:sleevetype::integer                as sleevetype
  , content:sleevetypename::varchar(50)        as sleevetypename
  , content:level::integer                     as level
  , content:levelname::varchar(50)             as levelname
  , content:fkbillentitycollectfrom::integer   as fkbillentitycollectfrom
  , content:createddate::timestamp             as createddate
  , a.effective_at::date                       as effective_date
  , a._pk::varchar(200)                        as _pk
  , a._client::int                             as _client
  , a._extracted_at                            as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_feehierarchy'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                            as _is_full
  , a._created_at                              as _created_at
  , a._source_file                             as _source_file
  , a._checksum                                as _checksum
from {{ source('orion', 'stg_vw_feehierarchy') }} a
join {{ ref('orion__base_vw_clientinfo') }}       ci
     on a._client::int = ci.pkalclient
