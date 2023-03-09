select
    clientid
  , accountid
  , accountname
  , institutionname
  , facttypename
  , type
  , subtype
  , homevalue
  , address1
  , address2
  , city
  , state
  , postalcode
  , purchaseyear
  , country
  , effective_date
  , record_datetime
  , record_date
  , totalvalue
  , holdingsvalue
  , cashbalance
  , marginbalance
  , costbasis
  , amountasof
  , purchaseamount
  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_real_estate_assets'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_real_estate_assets') }}