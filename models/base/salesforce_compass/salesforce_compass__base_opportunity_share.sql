select
    id
  , opportunity_id
  , user_or_group_id
  , opportunity_access_level
  , row_cause
  , last_modified_date
  , last_modified_by_id
  , is_deleted
  , _fivetran_synced
from {{ source('salesforce_compass', 'opportunity_share') }}