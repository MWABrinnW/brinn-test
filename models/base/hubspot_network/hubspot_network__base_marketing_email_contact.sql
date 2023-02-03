select
    contact_id
    , marketing_email_id
    , is_contact_included
    , _fivetran_synced
from {{ source('hubspot_network', 'marketing_email_contact') }}