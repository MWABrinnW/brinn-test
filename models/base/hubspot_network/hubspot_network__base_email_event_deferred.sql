select
    id
    , response
    , attempt
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_deferred') }}