select
    campaign_id
    , marketing_email_id
    , _fivetran_synced
from {{ source('hubspot_network', 'marketing_email_campaign') }}