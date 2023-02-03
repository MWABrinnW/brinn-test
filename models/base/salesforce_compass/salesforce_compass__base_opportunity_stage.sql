select
    id
  , master_label
  , api_name
  , is_active
  , sort_order
  , is_closed
  , is_won
  , forecast_category
  , forecast_category_name
  , default_probability
  , description
  , created_by_id
  , created_date
  , last_modified_by_id
  , last_modified_date
  , system_modstamp
  , _fivetran_synced
  , _fivetran_deleted
from {{ source('salesforce_compass', 'opportunity_stage') }}