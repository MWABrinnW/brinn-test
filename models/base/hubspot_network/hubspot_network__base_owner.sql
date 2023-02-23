select *
from {{ source('hubspot_network', 'owner') }}