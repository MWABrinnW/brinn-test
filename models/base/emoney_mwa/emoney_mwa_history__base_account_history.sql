{% set src = source('emoney_mwa', 'account_history') %}
select
    try_to_number(_data:"value"::text , 28 , 10)::int                     as value
    , _data:"clientid"::text(200)                                         as client_id
    , _data:"accountid"::text(200)                                        as account_id
    , try_to_timestamp(_data:"asofdate"::text , 'MM/DD/YYYY HH:MI:SS AM') as as_of_date

    , effective_date::date                                                as effective_date
    , _created_at::timestamp                                              as _created_at
    , _source_file::text(200)                                             as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
