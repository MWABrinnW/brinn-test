select
    stage_id
    , pipeline_id
    , label
    , active
    , display_order
    , probability
    , closed_won
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'deal_pipeline_stage') }}