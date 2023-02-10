select *
from {{ source('hubspot_network', 'merged_deal') }}