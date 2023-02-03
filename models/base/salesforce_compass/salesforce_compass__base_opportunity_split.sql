select
    id
  , is_deleted
  , split
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , opportunity_id
  , split_owner_id
  , split_percentage
  , split_note
  , split_type_id
  , split_amount
  , _fivetran_synced
from {{ source('salesforce_compass', 'opportunity_split') }}