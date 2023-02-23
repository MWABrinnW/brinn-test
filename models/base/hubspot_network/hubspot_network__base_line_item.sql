select *
from {{ source('hubspot_network', 'line_item') }}