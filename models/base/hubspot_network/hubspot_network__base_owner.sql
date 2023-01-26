select
    owner_id
    , first_name
    , last_name
    , email
    , created_at
    , updated_at
    , active_user_id
    , is_active
    , _fivetran_synced
from {{ source('hubspot_network', 'owner') }}