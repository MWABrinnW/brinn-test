select
    email_id
  , tag_id
  , _fivetran_synced
from {{ source('pardot', 'email_tag') }}