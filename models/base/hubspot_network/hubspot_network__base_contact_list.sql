select *
from {{ source('hubspot_network', 'contact_list') }}