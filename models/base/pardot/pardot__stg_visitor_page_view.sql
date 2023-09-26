select
    id
  , url
  , title
  , visit_id
  , created_at
  , _fivetran_synced
from {{ source('pardot', 'visitor_page_view') }}
