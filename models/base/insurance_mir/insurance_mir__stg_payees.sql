select
    nullif(json:"Name" , '')::text        as name
    , nullif(json:"ID" , '')::text        as id
    , nullif(json:"Role" , '')::text      as role
    , nullif(json:"Market(s)" , '')::text as markets
    , _created_at::datetime               as _created_at
    , _box_file_id::text                  as _box_file_id
    , _box_file_name::text                as _box_file_name
    , _box_meta::variant                  as _box_meta
    , {{ col_is_head_with_partition(reference 
        , partition_col='_box_file_name'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('insurance_mir', 'payees') }}
