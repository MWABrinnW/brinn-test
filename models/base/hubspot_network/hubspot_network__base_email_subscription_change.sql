select
    _fivetran_id
    , recipient
    , change
    , change_type
    , portal_id
    , source
    , caused_by_event_id
    , timestamp
    , email_subscription_id
    , _fivetran_synced
from {{ source('hubspot_network', 'email_subscription_change') }}