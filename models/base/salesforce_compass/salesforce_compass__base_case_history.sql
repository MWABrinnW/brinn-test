select
    id::varchar(18)                     as id
    , is_deleted::boolean               as is_deleted
    , case_id::varchar(18)              as case_id
    , created_by_id::varchar(18)        as created_by_id
    , created_date::timestamp_tz(9)     as created_date
    , field::varchar(765)               as field
    , data_type::varchar(120)           as data_type
    , old_value::varchar(765)           as old_value
    , new_value::varchar(765)           as new_value
    , _fivetran_deleted::boolean        as _fivetran_deleted
    , _fivetran_synced::timestamp_tz(9) as _fivetran_synced
from {{ source('salesforce_compass_fivetran', 'case_history') }}
