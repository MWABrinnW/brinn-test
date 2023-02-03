select
    id
    , source
    , requested_by
    , portal_subscription_status
    , subscriptions
    , bounced
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_status_change') }}