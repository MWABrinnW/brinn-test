select
    id
  , is_deleted
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , account_id
  , contact_id
  , role
  , is_primary
  , _fivetran_synced
from {{ source('salesforce_compass', 'account_contact_role') }}