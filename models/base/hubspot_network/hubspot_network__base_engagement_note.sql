select
    engagement_id
    , body
    , _fivetran_synced
from {{ source('hubspot_network', 'engagement_note') }}