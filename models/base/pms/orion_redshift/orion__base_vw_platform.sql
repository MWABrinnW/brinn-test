select
    ci.clientname                          as clientname
  , content:fkalclient::integer            as fkalclient
  , content:pkplatform::integer            as pkplatform
  , content:name::varchar(150)             as name
  , content:abbreviation::varchar(150)     as abbreviation
  , content:description::varchar(300)      as description
  , content:rankorder::integer             as rankorder
  , content:isdefault::boolean::int        as isdefault
  , content:isactive::boolean::int         as isactive
  , content:fkips::integer                 as fkips
  , content:color::varchar(15)             as color
  , content:fkplatformtype::integer        as fkplatformtype
  , content:objective::varchar(1000)       as objective
  , content:editeddate::date               as editeddate
  , content:editedby::varchar(60)          as editedby
  , content:platformcreateddate::date      as platformcreateddate
  , content:platformcreatedby::varchar(60) as platformcreatedby
  , content:iswrapfeeprogram::boolean::int as iswrapfeeprogram
  , content:fkmodelagg::integer            as fkmodelagg
  , content:createddate::timestamp         as createddate
  , a.effective_at::date                   as effective_date
  , a._pk::varchar(200)                    as _pk
  , a._client::int                         as _client
  , a._extracted_at                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_platform'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                        as _is_full
  , a._created_at                          as _created_at
  , a._source_file                         as _source_file
  , a._checksum                            as _checksum
from {{ source('orion', 'vw_platform') }} a
join {{ ref('orion__base_vw_clientinfo') }}   ci
     on a._client::int = ci.pkalclient
