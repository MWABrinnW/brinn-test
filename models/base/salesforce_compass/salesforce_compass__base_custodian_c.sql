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
  , last_activity_date
  , last_viewed_date
  , last_referenced_date
  , contact_name_c
  , email_address_c
  , mailing_address_c
  , phone_c
  , statement_delivery_c
  , statement_delivery_notification_c
  , average_date_data_available_c
  , data_source_c
  , bo_reconciliation_frequency_c
  , legal_name_c
  , legal_address_c
  , legal_city_c
  , legal_state_c
  , legal_zip_code_c
  , qualified_custodian_c
  , qualified_legal_name_c
  , _fivetran_synced
from {{ source('salesforce_compass', 'custodian_c') }}