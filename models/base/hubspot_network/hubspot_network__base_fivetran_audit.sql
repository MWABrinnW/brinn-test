select
    id
    , "MESSAGE"                     as message
    , update_started                as update_started_at
    , update_id
    , "SCHEMA"                      as schema_name
    , "TABLE"                       as table_name
    , "START"                       as start_at
    , done                          as done_at
    , rows_updated_or_inserted
    , status
    , progress
    , _fivetran_synced
from {{ source('hubspot_network', 'fivetran_audit') }}