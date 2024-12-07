select
    a.content:fkproduct::int           as fkproduct
    , a.content:factor::double         as factor
    , a.content:factordate::date       as factordate
    , a.content:createddate::timestamp as createddate
    , a._pk::varchar(200)              as _pk
    , a._extracted_at::timestamp_ntz   as _extracted_at
    , a._is_full::int                  as _is_full
    , a._created_at::timestamp_ntz     as _created_at
    , a._source_file                   as _source_file
    , a._checksum                      as _checksum
from {{ source('orion', 'vw_productpricefactor') }} as a
