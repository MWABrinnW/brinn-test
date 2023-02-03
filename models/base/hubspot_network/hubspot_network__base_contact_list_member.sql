select
    contact_id
    , contact_list_id
    , added_at
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'contact_list_member') }}