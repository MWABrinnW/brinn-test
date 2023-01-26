select
    id
    , ip_address
    , user_agent
    , browser
    , location
    , duration
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_open') }}