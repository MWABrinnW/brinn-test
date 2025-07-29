{{ config(enabled = false) }}
select
    * rename
    update_started                 as update_started_at
    ,"SCHEMA"                      as schema_name
    ,"TABLE"                       as table_name
    ,"START"                       as start_at
    ,done                          as done_at
from {{ source('hubspot_network', 'fivetran_audit') }}