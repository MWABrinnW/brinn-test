select
    id
  , campaign_id
  , created_by_id
  , updated_by_id
  , email_template_id
  , tracker_domain_id
  , client_type
  , subject
  , name
  , html_message
  , text_message
  , is_deleted
  , is_paused
  , is_sent
  , operational_email
  , created_at
  , sent_at
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'list_email') }}