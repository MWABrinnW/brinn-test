select
    a.content:pkproducttype::integer        as pkproducttype
    , a.content:producttype::integer        as producttype
    , a.content:productsubtype::varchar(50) as productsubtype
    , a.content:isalternative::integer      as isalternative
    , a.effective_at::date                  as effective_date
    , a._pk::varchar(200)                   as _pk

    , a._extracted_at::timestamp_ntz        as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_productsubtype'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                       as _is_full
    , a._created_at::timestamp_ntz          as _created_at
    , a._source_file                        as _source_file
    , a._checksum                           as _checksum
from {{ source('orion', 'vw_productsubtype') }} as a
