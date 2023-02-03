select
    pipeline_id
    , label
    , active
    , display_order
    , object_type_id
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'ticket_pipeline') }}