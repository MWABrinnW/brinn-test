select *
from {{ source('hubspot_network', 'deal') }}