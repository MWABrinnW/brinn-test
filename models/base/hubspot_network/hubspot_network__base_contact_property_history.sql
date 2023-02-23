select *
from {{ source('hubspot_network', 'contact_property_history') }}