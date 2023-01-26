select
    company_id
    , engagement_id
    , _fivetran_synced
from {{ source('hubspot_network', 'engagement_company') }}