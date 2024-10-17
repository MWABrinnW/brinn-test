{% set src = source('emoney_mwa', 'notes') %}
select
    _data:"text"::text(200)        as text
    , _data:"date"::text(200)      as date
    , _data:"editor"::text(200)    as editor
    , _data:"clientid"::text(200)  as client_id
    , _data:"noteid"::text(200)    as note_id
    , _data:"accountid"::text(200) as account_id
    , _data:"null"::variant        as null_column_name

    , effective_date::date         as effective_date
    , _created_at::timestamp       as _created_at
    , _source_file::text(200)      as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
