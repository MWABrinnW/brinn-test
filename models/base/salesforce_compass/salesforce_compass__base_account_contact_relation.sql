select
    id
  , account_id
  , contact_id
  , roles
  , is_direct
  , is_active
  , start_date
  , end_date
  , is_deleted
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , sort_order_c
  , statement_mailing_preference_c
  , _fivetran_synced
from {{ source('salesforce_compass', 'account_contact_relation') }}