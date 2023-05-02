select
    'orion' as pms
    , 'mwa' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , accounttype
    , asofdate
    , birthdate
    , clientid
    , firmid
    , firstname
    , fullname
    , investmentamount
    , isactive
    , lastname
    , netincome
    , networth
    , registrationid
    , risktolerance
    , ssn
    , stockpercent
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'registrations')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('orion_mwa_bulk', 'registrations') }}