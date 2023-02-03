select
    label
    , property_id
    , value
    , display_order
    , double_data
    , hidden
    , read_only
    , _fivetran_synced
from {{ source('hubspot_network', 'property_option') }}