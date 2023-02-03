select
    id
    , name
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'team') }}