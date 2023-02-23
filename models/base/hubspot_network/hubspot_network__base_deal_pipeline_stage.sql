select *
from {{ source('hubspot_network', 'deal_pipeline_stage') }}