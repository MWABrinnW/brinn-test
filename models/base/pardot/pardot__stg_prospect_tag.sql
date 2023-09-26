select
    prospect_id
  , tag_id
  , _fivetran_synced
from {{ source('pardot', 'prospect_tag') }}