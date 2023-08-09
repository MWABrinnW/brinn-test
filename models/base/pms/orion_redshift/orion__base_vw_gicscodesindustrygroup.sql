select
    ci.clientname                                    as clientname
  , content:pkproductgicscodesindustrygroup::integer as fkalclient
  , content:gicscode::integer                        as gicscode
  , content:gicsdescription::varchar(100)            as gicsdescription
  , content:createddate::timestamp                   as createddate
  , a.effective_at::date                             as effective_date
  , a._pk::varchar(200)                              as _pk
  , a._client::int                                   as _client
  , a._extracted_at                                  as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_gicscodesindustrygroup'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                  as _is_full
  , a._created_at                                    as _created_at
  , a._source_file                                   as _source_file
  , a._checksum                                      as _checksum
from {{ source('orion', 'stg_vw_gicscodesindustrygroup') }} a
join {{ ref('orion__base_vw_clientinfo') }}                 ci
     on a._client::int = ci.pkalclient
