select
    id
  , name
  , custom_type
  , custom_assigned_to
  , custom_created_at
  , custom_updated_at
  , _fivetran_synced
from {{ source('pardot', 'prospect_account') }}