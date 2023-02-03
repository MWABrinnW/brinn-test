select
    _fivetran_id
    , hubspot_object
    , name
    , label
    , description
    , group_name
    , type
    , field_type
    , calculated
    , hubspot_defined
    , _fivetran_synced
from {{ source('hubspot_network', 'property') }}