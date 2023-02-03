select
    id
  , is_deleted
  , parent_id
  , created_by_id
  , created_date
  , field
  , data_type
  , old_value
  , new_value
  , _fivetran_synced
from {{ source('salesforce_compass', 'mhacquisition_history') }}