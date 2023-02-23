select *
from {{ source('hubspot_network', 'deal_contact') }}