select *
from {{ source('hubspot_network', 'property') }}