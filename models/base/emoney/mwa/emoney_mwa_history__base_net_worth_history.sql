select
    clientid
  , effective_date
  , record_datetime
  , record_date
  , asofdate
  , assetvalue
  , liabilityvalue
  , investiblevalue
  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_net_worth_history'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_net_worth_history') }}