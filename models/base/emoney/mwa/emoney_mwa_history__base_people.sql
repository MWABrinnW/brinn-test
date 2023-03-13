select
    clientid
  , peopleid
  , facttypename
  , firstname
  , lastname
  , gender
  , maritalstatus
  , citizenship
  , spousefirstname
  , spouselastname
  , spousegender
  , spousecitizenship
  , parentid
  , isfrompreviousmarraige
  , isfinanciallydependent
  , skipperson
  , hasspecialneeds
  , isingoodhealth
  , effective_date
  , record_datetime
  , record_date
  , dateofbirth
  , spousedateofbirth  , {{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_people'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_people') }}