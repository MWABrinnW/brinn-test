select
    contact_list_id
    , marketing_email_id
    , is_mailing_list_included
    , _fivetran_synced
from {{ source('hubspot_network', 'marketing_email_contact_list') }}