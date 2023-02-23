select *
from {{ source('hubspot_network', 'marketing_email_contact') }}