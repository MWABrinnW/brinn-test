select
    id
  , email
  , first_name
  , last_name
  , job_title
  , role
  , account
  , created_at
  , updated_at
  , _fivetran_synced
from {{ source('pardot', 'user') }}