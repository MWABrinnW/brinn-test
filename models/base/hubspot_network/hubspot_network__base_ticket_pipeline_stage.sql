select
    stage_id
    , pipeline_id
    , label
    , active
    , display_order
    , is_closed
    , ticket_state
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'ticket_pipeline_stage') }}