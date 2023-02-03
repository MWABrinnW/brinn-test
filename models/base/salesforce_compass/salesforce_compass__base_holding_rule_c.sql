select
    id
  , is_deleted
  , name
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , last_viewed_date
  , last_referenced_date
  , financial_account_c
  , aum_classification_c
  , description_c
  , rule_end_date_c
  , rule_start_date_c
  , security_identifier_c
  , _fivetran_synced
  , identifier_type_c
  , active_c
  , financial_account_number_c
  , orion_account_id_c
from {{ source('salesforce_compass', 'holding_rule_c') }}