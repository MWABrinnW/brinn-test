select
    domain
  , userid
  , externalid
  , effective_date
  , record_datetime
  , record_date
  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_user'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_user') }}