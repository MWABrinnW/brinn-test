select
    ci.clientname                                  as clientname
    , ci.system_name                               as system_name
    , ci.system_instance                           as system_instance
    , ci.system_key                                as system_key
    , ci.firm_source                               as firm_source
    , a.content:fkalclient::integer                as fkalclient
    , a.content:pkfeehierarchy::integer            as pkfeehierarchy
    , a.content:pkfeehierarchycollectfrom::integer as pkfeehierarchycollectfrom
    , a.content:entityname::varchar(300)           as entityname
    , a.content:entityid::integer                  as entityid
    , a.content:entityenum::integer                as entityenum
    , a.content:status::boolean::int               as status
    , a.content:fkbillentity::integer              as fkbillentity
    , a.content:fkbillschedule::integer            as fkbillschedule
    , a.content:fkcustodian::integer               as fkcustodian
    , a.content:fkfeehierarchyglobal::integer      as fkfeehierarchyglobal
    , a.content:producttype::integer               as producttype
    , a.content:feehierarchytype::integer          as feehierarchytype
    , a.content:feehierarchytypename::varchar(50)  as feehierarchytypename
    , a.content:methodtype::integer                as methodtype
    , a.content:softdeletekey::integer             as softdeletekey
    , a.content:sleevetype::integer                as sleevetype
    , a.content:sleevetypename::varchar(50)        as sleevetypename
    , a.content:level::integer                     as level
    , a.content:levelname::varchar(50)             as levelname
    , a.content:fkbillentitycollectfrom::integer   as fkbillentitycollectfrom
    , a.content:createddate::timestamp             as createddate
    , a.effective_at::date                         as effective_date
    , a._pk::varchar(200)                          as _pk

    , a._extracted_at::timestamp_ntz               as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_feehierarchy'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                              as _is_full
    , a._created_at::timestamp_ntz                 as _created_at
    , a._source_file                               as _source_file
    , a._checksum                                  as _checksum
from {{ source('orion', 'vw_feehierarchy') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
