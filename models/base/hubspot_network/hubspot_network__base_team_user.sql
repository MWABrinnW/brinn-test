select *
from {{ source('hubspot_network', 'team_user') }}