select
    list_id
  , tag_id
  , _fivetran_synced
from {{ source('pardot', 'list_tag') }}