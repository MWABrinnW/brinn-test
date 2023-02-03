select
    id
  , owner_id
  , is_deleted
  , name
  , record_type_id
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , last_viewed_date
  , last_referenced_date
  , approved_custodian_c
  , is_qualified_c
  , sort_order_c
  , text_value_1_c
  , _fivetran_synced
  , occupation_type_c
  , keywords_c
  , occupation_subtype_c
from {{ source('salesforce_compass', 'mh_dynamic_list_c') }}