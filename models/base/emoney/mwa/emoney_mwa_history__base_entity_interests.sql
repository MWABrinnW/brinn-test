select
    clientid
  , accountid
  , interestid
  , interestownertype
  , interesttype
  , effective_date
  , record_datetime
  , record_date
  , interestpercent
  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_entity_interests'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_entity_interests') }}