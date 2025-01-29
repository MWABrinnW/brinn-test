select
    json:scope::text(100)       as scope
    , json:scope_key::text(100) as scope_key
    , json:start_date::date     as start_date
    , json:end_date::date       as end_date
    , json:comments::text(2000) as comments
    --, json:system_key::text(1000)  as system_key
    , json:pms_key::text(1000)  as _system_key
    , _created_at::timestamp    as _created_at
    , _box_file_id::text(200)   as _box_file_id
from {{ source('aux', 'rules_source_of_truth') }}
