select
    ci.clientname                                   as clientname
  , content:fkalclient::integer                     as fkalclient
  , content:pkregistrationtype::integer             as pkregistrationtype
  , content:sregcode::varchar(60)                   as sregcode
  , content:sregdesc::varchar(255)                  as sregdesc
  , content:isqual::boolean::int                    as isqual
  , content:isira::boolean::int                     as isira
  , content:is403b::boolean::int                    as is403b
  , content:plantype::varchar(10)                   as plantype
  , content:isdefault::boolean::int                 as isdefault
  , content:externalcode::varchar(10)               as externalcode
  , content:socialcode::varchar(3)                  as socialcode
  , content:commoncode::varchar(10)                 as commoncode
  , content:category::integer                       as category
  , content:bentypes::varchar(200)                  as bentypes
  , content:isbira::boolean::int                    as isbira
  , content:includeinrmd::boolean::int              as includeinrmd
  , content:excludefromrmdaggregation::boolean::int as excludefromrmdaggregation
  , content:proposalcode::varchar(20)               as proposalcode
  , content:taxtype::integer                        as taxtype
  , content:createddate::timestamp                  as createddate
  , a.effective_at::date                            as effective_date
  , a._pk::varchar(200)                             as _pk
  , a._client::int                                  as _client
  , a._extracted_at                                 as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_registrationtype'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                 as _is_full
  , a._created_at                                   as _created_at
  , a._source_file                                  as _source_file
  , a._checksum                                     as _checksum
from {{ source('orion', 'stg_vw_registrationtype') }} a
join {{ ref('orion__base_vw_clientinfo') }}           ci
     on a._client::int = ci.pkalclient
