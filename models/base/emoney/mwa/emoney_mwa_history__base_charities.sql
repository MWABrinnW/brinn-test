{% set src = source('emoney_mwa', 'charities') %}
select
    _data:"type"::text(200)       as type
    , _data:"name"::text(200)     as name
    , _data:"clientid"::text(200) as client_id
    , _data:"factid"::text(200)   as fact_id
    , _data:"typecode"::text(200) as type_code

    , effective_date::date        as effective_date
    , _created_at::timestamp      as _created_at
    , _source_file::text(200)     as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
