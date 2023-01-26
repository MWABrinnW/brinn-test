select
    id
  , owner_id
  , is_deleted
  , name
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , last_viewed_date
  , last_referenced_date
  , contact_c
  , estate_item_c
  , role_c
  , sort_order_c
  , beneficiary_share_percentage_c
  , _fivetran_synced
  , role_filter_c
from {{ source('salesforce_compass', 'estate_item_contact_link_c') }}