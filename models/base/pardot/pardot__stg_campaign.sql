select
    id
  , name
  , cost
  , _fivetran_deleted
  , _fivetran_synced
from {{ source('pardot', 'campaign') }}