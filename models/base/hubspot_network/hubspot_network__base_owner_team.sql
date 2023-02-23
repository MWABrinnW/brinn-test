select *
from {{ source('hubspot_network', 'owner_team') }}