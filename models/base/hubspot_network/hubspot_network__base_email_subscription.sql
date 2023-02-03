select
    id
    , portal_id
    , name
    , description
    , active
    , _fivetran_synced
from {{ source('hubspot_network', 'email_subscription') }}