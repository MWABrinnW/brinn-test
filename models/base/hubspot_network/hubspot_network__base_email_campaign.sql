select *
from {{ source('hubspot_network', 'email_campaign') }}