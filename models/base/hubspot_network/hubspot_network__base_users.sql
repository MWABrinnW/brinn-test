select
    id
    , email
    , _fivetran_deleted
    , role_id
    , primary_team_id
    , _fivetran_synced
from {{ source('hubspot_network', 'users') }}