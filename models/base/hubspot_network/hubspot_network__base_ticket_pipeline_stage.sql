select *
from {{ source('hubspot_network', 'ticket_pipeline_stage') }}