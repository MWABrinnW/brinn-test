select
    id
    , app_id
    , app_name
    , content_id
    , name
    , num_included
    , num_queued
    , sub_type
    , subject
    , type
    , _fivetran_synced
from {{ source('hubspot_network', 'email_campaign') }}