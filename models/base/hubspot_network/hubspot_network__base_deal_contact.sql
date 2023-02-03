select
    contact_id
    , deal_id
    , _fivetran_synced
from {{ source('hubspot_network', 'deal_contact') }}