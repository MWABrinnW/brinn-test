select
    id
  , is_deleted
  , developer_name
  , language
  , master_label
  , namespace_prefix
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , is_active
  , split_entity
  , split_field
  , description
  , is_total_validated
  , split_data_status
  , _fivetran_synced
from {{ source('salesforce_compass', 'opportunity_split_type') }}