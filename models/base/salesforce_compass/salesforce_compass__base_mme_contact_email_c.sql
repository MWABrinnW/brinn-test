select
    id
  , is_deleted
  , name
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , mme_contact_c
  , mme_email_c
  , _fivetran_synced
from {{ source('salesforce_compass', 'mme_contact_email_c') }}