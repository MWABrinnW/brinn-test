select
    company_id
    , name
    , timestamp
    , value
    , source_id
    , source
    , _fivetran_synced
    , _fivetran_start
    , _fivetran_end
    , _fivetran_active
from {{ source('hubspot_network', 'company_property_history') }}