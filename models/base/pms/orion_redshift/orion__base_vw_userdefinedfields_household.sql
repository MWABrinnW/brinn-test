select
    ci.clientname                        as clientname
  , content:fkhousehold::integer         as fkhousehold
  , content:fkproduct::integer           as fkproduct
  , content:description::varchar(1000)   as description
  , content:code::varchar(200)           as code
  , content:fieldvalue::varchar(65535)   as fieldvalue
  , content:fieldvaluemask::varchar(255) as fieldvaluemask
  , content:createddate::timestamp       as createddate
  , a.effective_at::date                 as effective_date
  , a._pk::varchar(200)                  as _pk
  , a._client::int                       as _client
  , a._extracted_at                      as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_userdefinedfields_household'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                      as _is_full
  , a._created_at                        as _created_at
  , a._source_file                       as _source_file
  , a._checksum                          as _checksum
from {{ source('orion', 'vw_userdefinedfields_household') }} a
join {{ ref('orion__base_vw_clientinfo') }}                  ci
     on a._client::int = ci.pkalclient
