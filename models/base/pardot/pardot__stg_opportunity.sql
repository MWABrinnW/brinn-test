select
    id
  , name
  , value
  , probability
  , type
  , stage
  , status
  , created_at
  , updated_at
  , closed_at
  , campaign_id
  , _fivetran_synced
from {{ source('pardot', 'opportunity') }}