select
    id
    , portal_id
    , active
    , owner_id
    , type
    , activity_type
    , created_at
    , last_updated
    , timestamp
    , _fivetran_synced
from {{ source('hubspot_network', 'engagement') }}