select
    id
  , list_id
  , prospect_id
  , opted_out
  , created_at
  , updated_at
  , _fivetran_deleted
  , _fivetran_synced
from {{ source('pardot', 'list_membership') }}