select
    team_id
    , user_id
    , is_secondary_user
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'team_user') }}