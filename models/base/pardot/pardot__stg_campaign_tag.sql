select
    campaign_id
  , tag_id
  , _fivetran_synced
from {{ source('pardot', 'campaign_tag') }}