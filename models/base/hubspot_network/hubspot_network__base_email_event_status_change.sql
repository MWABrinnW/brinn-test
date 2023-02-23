select *
from {{ source('hubspot_network', 'email_event_status_change') }}