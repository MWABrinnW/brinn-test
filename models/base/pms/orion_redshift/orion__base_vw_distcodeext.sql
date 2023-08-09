select
    ci.clientname                  as clientname
  , content:fkalclient::integer    as fkalclient
  , content:fkdistcode::integer    as fkdistcode
  , content:pkdistcodeext::integer as pkdistcodeext
  , content:distcode::varchar(50)  as distcode
  , content:taxcode::varchar(50)   as taxcode
  , content:distdesc::varchar(50)  as distdesc
  , content:transcode::varchar(50) as transcode
  , content:transdesc::varchar(50) as transdesc
  , content:subcode::varchar(3)    as subcode
  , content:phxtaxcode::varchar(3) as phxtaxcode
  , content:isqual::boolean::int   as isqual
  , a.effective_at::date           as effective_date
  , a._pk::varchar(200)            as _pk
  , a._client::int                 as _client
  , a._extracted_at                as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_distcodeext'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                as _is_full
  , a._created_at                  as _created_at
  , a._source_file                 as _source_file
  , a._checksum                    as _checksum
from {{ source('orion', 'stg_vw_distcodeext') }} a
join {{ ref('orion__base_vw_clientinfo') }}      ci
     on a._client::int = ci.pkalclient
