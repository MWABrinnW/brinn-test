{% set src = source('emoney_mwa', 'nexus_deleted_investment_transactions') %}
select
    _data                     as raw_data

    , effective_date::date    as effective_date
    , _created_at::timestamp  as _created_at
    , _source_file::text(200) as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
