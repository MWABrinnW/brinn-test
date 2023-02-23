select *
from {{ source('hubspot_network', 'email_event_open') }}