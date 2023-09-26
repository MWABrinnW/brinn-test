select
    user_id
  , tag_id
  , _fivetran_synced
from {{ source('pardot', 'user_tag') }}