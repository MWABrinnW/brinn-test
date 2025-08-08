select
    json:employee_num::text                            as employee_num
    , json:properties_to_exclude::text                 as properties_to_exclude
    , try_to_boolean(json:exclude_entirely::text)::int as exclude_entirely
    , json:notes::text                                 as notes
    , _box_file_id::text                               as _box_file_id
    , _box_file_name::text                             as _box_file_name
    , _box_meta::text                                  as _box_meta
    , _created_at::timestamp_ntz                       as _created_at
from {{ source('aux', 'active_directory_sync_exclusions') }}
