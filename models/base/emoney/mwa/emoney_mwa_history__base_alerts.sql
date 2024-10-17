{% set src = source('emoney_mwa', 'alerts') %}
select
    _data:"clientid"::text(200)                      as client_id
    , try_to_boolean(_data:"messageread"::text)::int as message_read
    , _data:"messagesubject"::text(200)              as message_subject
    , _data:"triggeredon"::text(200)                 as triggered_on
    , _data:"alertname"::text(200)                   as alert_name
    , _data:"messagebody"::text(200)                 as message_body
    , _data:"alertid"::text(200)                     as alert_id
    , _data:"triggered"::text(200)                   as triggered
    , _data:"enabled"::text(200)                     as enabled

    , effective_date::date                           as effective_date
    , _created_at::timestamp                         as _created_at
    , _source_file::text(200)                        as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
