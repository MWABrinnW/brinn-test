select
    json:system_key::text         as system_key
    , json:effective_date::date   as effective_date
    , json:is_excluded::int       as is_excluded
    , json:excluded_reasons::text as excluded_reasons
    , _created_at::datetime       as _created_at
    , _box_file_id::text          as _box_file_id
    , _box_file_name::text        as _box_file_name
    , _box_meta::variant          as _box_meta
    , _id::int                    as _id
from {{ source('aux', 'masters_variance_accounts') }}
