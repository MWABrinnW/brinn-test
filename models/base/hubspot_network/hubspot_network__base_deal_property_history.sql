select *
from {{ source('hubspot_network', 'deal_property_history') }}