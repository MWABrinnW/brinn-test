select
    id
    , user_agent
    , ip_address
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_spam_report') }}