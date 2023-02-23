select *
from {{ source('hubspot_network', 'line_item_property_history') }}