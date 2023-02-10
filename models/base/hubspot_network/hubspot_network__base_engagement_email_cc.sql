select *
from {{ source('hubspot_network', 'engagement_email_cc') }}