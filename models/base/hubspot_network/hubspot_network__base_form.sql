select
    guid
    , portal_id
    , name
    , action
    , method
    , css_class
    , redirect
    , submit_text
    , follow_up_id
    , notify_recipients
    , lead_nurturing_campaign_id
    , form_type
    , created_at
    , updated_at
    , _fivetran_deleted
    , _fivetran_synced
from {{ source('hubspot_network', 'form') }}