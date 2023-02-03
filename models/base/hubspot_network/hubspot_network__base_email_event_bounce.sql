select
    id
    , response
    , category
    , status
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_bounce') }}