select
    id
  , visitor_id
  , prospect_id
  , visitor_page_view_count
  , first_visitor_page_view_at
  , last_visitor_page_view_at
  , duration_in_seconds
  , campaign_parameter
  , medium_parameter
  , source_parameter
  , content_parameter
  , term_parameter
  , created_at
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'visit') }}