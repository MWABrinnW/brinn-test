{% set src = source('emoney_mwa', 'client_group_members') %}
select
    _data:"clientid"::text(200)  as client_id
    , _data:"groupid"::text(200) as group_id

    , effective_date::date       as effective_date
    , _created_at::timestamp     as _created_at
    , _source_file::text(200)    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
