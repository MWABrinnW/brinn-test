select
    id
  , opportunity_id
  , account_to_id
  , role
  , is_primary
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , is_deleted
  , reverse_partner_id
  , _fivetran_synced
from {{ source('salesforce_compass', 'opportunity_partner') }}