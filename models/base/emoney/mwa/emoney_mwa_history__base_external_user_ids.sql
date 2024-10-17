{% set src = source('emoney_mwa', 'external_user_ids') %}
select
    _data:"role"::text(200)             as role
    , _data:"externaluserid"::text(200) as external_user_id
    , _data:"userid"::text(200)         as user_id
    , _data:"domain"::text(200)         as domain

    , effective_date::date              as effective_date
    , _created_at::timestamp            as _created_at
    , _source_file::text(200)           as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
