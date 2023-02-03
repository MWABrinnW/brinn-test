select
    contact_id
    , form_id
    , timestamp
    , portal_id
    , page_id
    , _fivetran_synced
from {{ source('hubspot_network', 'contact_form_submission') }}