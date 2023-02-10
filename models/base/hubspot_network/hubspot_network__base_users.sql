select *
from {{ source('hubspot_network', 'users') }}