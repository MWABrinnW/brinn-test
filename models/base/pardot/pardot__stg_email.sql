select
    id
  , list_email_id
  , name
  , subject
  , prospect_id
  , list_id
  , created_by_id
  , campaign_id
  , client_type
  , created_at
  , _fivetran_synced
from {{ source('pardot', 'email') }}