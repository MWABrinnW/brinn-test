select
    clientid
  , accountid
  , accountname
  , institutionname
  , facttypename
  , type
  , subtype
  , included
  , connected
  , underourmanagement
  , country
  , isemployeebenefit
  , deferredtaxrate
  , dateestablished
  , establishedtype
  , establishedvalue
  , filename
  , total_value
  , holdingsvalue
  , cashbalance
  , marginbalance
  , costbasis
  , amountasof
  , effective_date
  , record_datetime
  , record_date
  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_investment_deposit_accounts'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_investment_deposit_accounts') }}