select
    ci.clientname                             as clientname
  , content:fkalclient::integer               as fkalclient
  , content:pkuserdefinedef::integer          as pkuserdefinedef
  , content:entityenum::integer               as entityenum
  , content:type::integer                     as type
  , content:description::varchar(50)          as description
  , content:mask::varchar(255)                as mask
  , content:defaultvalue::varchar(65535)      as defaultvalue
  , content:sequence::integer                 as sequence
  , content:code::varchar(25)                 as code
  , content:category::varchar(30)             as category
  , content:customobject::varchar(255)        as customobject
  , content:controlproperties::varchar(65535) as controlproperties
  , content:securitycode::varchar(38)         as securitycode
  , content:istimesensitive::boolean::int     as istimesensitive
  , content:fkparent::integer                 as fkparent
  , content:fieldvalue::varchar(65535)        as fieldvalue
  , content:fieldvaluemask::varchar(255)      as fieldvaluemask
  , content:effectivedate::date               as effectivedate
  , content:createddate::timestamp            as createddate
  , a.effective_at::date                      as effective_date
  , a._pk::varchar(200)                       as _pk
  , a._client::int                            as _client
  , a._extracted_at                           as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_userdefinedfields'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'vw_userdefinedfields') }} a
join {{ ref('orion__base_vw_clientinfo') }}        ci
     on a._client::int = ci.pkalclient
