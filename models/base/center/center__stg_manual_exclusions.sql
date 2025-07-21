select
    nullif(json:"EMPLOYEE_NUM"::varchar , '') as employee_num
    , nullif(json:"FIRST_NAME"::varchar , '') as first_name
    , nullif(json:"LAST_NAME"::varchar , '')  as last_name
    , _created_at::timestamp_ntz              as _created_at
    , _box_file_id::varchar                   as _box_file_id
    , _box_meta::variant                      as _box_meta

from {{ source('center', 'manual_exclusions') }}
