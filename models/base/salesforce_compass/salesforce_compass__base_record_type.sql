select
    id
  , name
  , developer_name
  , namespace_prefix
  , description
  , business_process_id
  , sobject_type
  , is_active
  , created_by_id
  , created_date
  , last_modified_by_id
  , last_modified_date
  , system_modstamp
  , _fivetran_synced
  , _fivetran_deleted
from {{ source('salesforce_compass', 'record_type') }}