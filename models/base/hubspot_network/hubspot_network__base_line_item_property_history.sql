select
    line_item_id
    , name
    , timestamp
    , value
    , selected
    , _fivetran_synced
    , _fivetran_start
    , _fivetran_end
    , _fivetran_active
from {{ source('hubspot_network', 'line_item_property_history') }}