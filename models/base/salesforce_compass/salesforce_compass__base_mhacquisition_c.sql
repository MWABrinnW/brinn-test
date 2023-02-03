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
  , acquired_date_c
  , comments_c
  , firm_c
  , mhlocation_c
  , type_c
  , goal_clients_c
  , goal_assets_c
  , _fivetran_synced
  , client_manager_c
  , goal_revenue_c
  , igodeal_id_c
  , adp_employee_source_c
from {{ source('salesforce_compass', 'mhacquisition_c') }}