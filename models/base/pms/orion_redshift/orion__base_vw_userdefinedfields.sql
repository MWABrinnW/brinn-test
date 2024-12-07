select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:fkalclient::integer               as fkalclient
    , a.content:pkuserdefinedef::integer          as pkuserdefinedef
    , a.content:entityenum::integer               as entityenum
    , a.content:type::integer                     as type
    , a.content:description::varchar(50)          as description
    , a.content:mask::varchar(255)                as mask
    , a.content:defaultvalue::varchar(65535)      as defaultvalue
    , a.content:sequence::integer                 as sequence
    , a.content:code::varchar(25)                 as code
    , a.content:category::varchar(30)             as category
    , a.content:customobject::varchar(255)        as customobject
    , a.content:controlproperties::varchar(65535) as controlproperties
    , a.content:securitycode::varchar(38)         as securitycode
    , a.content:istimesensitive::boolean::int     as istimesensitive
    , a.content:fkparent::integer                 as fkparent
    , a.content:fieldvalue::varchar(65535)        as fieldvalue
    , a.content:fieldvaluemask::varchar(255)      as fieldvaluemask
    , a.content:effectivedate::date               as effectivedate
    , a.content:createddate::timestamp            as createddate
    , a.effective_at::date                        as effective_date
    , a._pk::varchar(200)                         as _pk

    , a._extracted_at::timestamp_ntz              as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_userdefinedfields'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                             as _is_full
    , a._created_at::timestamp_ntz                as _created_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_userdefinedfields') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
