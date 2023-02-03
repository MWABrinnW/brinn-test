select
    id
    , subject
    , "FROM"                as from_address
    , reply_to              as reply_to_address
    , cc                    as cc_address
    , bcc                   as bcc_address
    , _fivetran_synced
from {{ source('hubspot_network', 'email_event_sent') }}