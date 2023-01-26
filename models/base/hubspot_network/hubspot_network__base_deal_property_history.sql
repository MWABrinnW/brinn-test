select
    deal_id
    , name
    , timestamp
    , value
    , source_id
    , source
    , _fivetran_synced
    , _fivetran_start
    , _fivetran_end
    , _fivetran_active
from {{ source('hubspot_network', 'deal_property_history') }}