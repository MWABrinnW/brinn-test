select
    id
  , name
  , created_at
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'tag') }}