select
    owner_id
    , team_id
    , _fivetran_deleted
    , is_team_primary
    , _fivetran_synced
from {{ source('hubspot_network', 'owner_team') }}