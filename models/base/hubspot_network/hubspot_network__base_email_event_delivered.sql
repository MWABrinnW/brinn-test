select
    id
    , response
    , smtp_id
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_delivered') }}