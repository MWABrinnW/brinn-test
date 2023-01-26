select
    id
    , name
    , deleteable
    , dynamic
    , portal_id
    , updated_at
    , created_at
    , metadata_last_processing_state_change_at
    , metadata_processing
    , metadata_last_size_change_at
    , metadata_error
    , metadata_size
    , offset
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'contact_list') }}