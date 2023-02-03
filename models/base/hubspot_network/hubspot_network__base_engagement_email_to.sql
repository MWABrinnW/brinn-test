select
    email
    , engagement_id
    , first_name
    , last_name
    , _fivetran_synced
from {{ source('hubspot_network', 'engagement_email_to') }}