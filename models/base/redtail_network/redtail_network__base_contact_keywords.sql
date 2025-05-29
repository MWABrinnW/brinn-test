select
    json:id::int                   as id
    , json:keyword_id::int         as keyword_id
    , json:contact_id::int         as contact_id
    , json:name::varchar(200)      as name
    , json:deleted::int            as is_deleted
    , json:created_at::timestamp   as created_at
    , json:updated_at::timestamp   as updated_at
    , {{ col_is_head(
        reference=source('redtail_network', 'contact_udfs'),
        reference_date_col='_effective_at::date',
        source_date_col='_effective_at::date'
        ) }}
    , _effective_at::timestamp_ltz as effective_at
    , _created_at::timestamp_ltz   as _source_loaded_at
    , _source_file::varchar(200)   as _source_file
from {{ source('redtail_network', 'contact_keywords') }}
