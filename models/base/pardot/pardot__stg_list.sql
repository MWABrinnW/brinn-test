select
    id
  , name
  , is_public
  , is_dynamic
  , title
  , description
  , is_crm_visible
  , created_at
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'list') }}