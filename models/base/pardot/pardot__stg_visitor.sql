select
    id
  , prospect_id
  , page_view_count
  , ip_address
  , campaign_parameter
  , medium_parameter
  , source_parameter
  , content_parameter
  , term_parameter
  , created_at
  , updated_at
  , hostname
  , _fivetran_synced
from {{ source('pardot', 'visitor') }}