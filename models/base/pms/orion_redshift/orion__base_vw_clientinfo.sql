select
    a.content:pkalclient::int          as pkalclient
  , a.content:clientname::varchar(200) as clientname
  , a.effective_at::date               as effective_date
  , a._pk::varchar(200)                as _pk
  , a.content:pkalclient::int          as _client
  , a._extracted_at                    as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_clientinfo'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                    as _is_full
  , a._created_at                      as _created_at
  , a._source_file                     as _source_file
  , a._checksum                        as _checksum
from {{ source('orion', 'vw_clientinfo') }} a
