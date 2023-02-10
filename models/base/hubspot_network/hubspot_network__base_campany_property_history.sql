select *
from {{ source('hubspot_network', 'company_property_history') }}