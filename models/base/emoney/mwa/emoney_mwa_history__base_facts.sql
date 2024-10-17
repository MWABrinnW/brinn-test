{% set src = source('emoney_mwa', 'facts') %}
select
    _data:"clientid"::text(200)     as client_id
    , _data:"factid"::text(200)     as fact_id
    , _data:"typecode"::text(200)   as type_code
    , _data:"amountasof"::text(200) as amount_as_of
    , _data:"type"::text(200)       as type
    , _data:"name"::text(200)       as name

    , effective_date::date          as effective_date
    , _created_at::timestamp        as _created_at
    , _source_file::text(200)       as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
