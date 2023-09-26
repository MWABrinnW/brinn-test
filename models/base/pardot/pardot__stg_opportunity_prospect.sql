select
    opportunity_id
  , prospect_id
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'opportunity_prospect') }}