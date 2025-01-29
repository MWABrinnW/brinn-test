select
    'orion'                                        as system_name
    , 'mwa'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , asofdate
    , birthdate
    , city
    , closeddate
    , email
    , faxphone
    , firmid
    , firstname
    , fullname
    , homephone
    , householdcashvalue
    , householdid
    , householdvalue
    , isactive
    , lastname
    , mobilephone
    , opendate
    , performanceasofdate
    , performanceday
    , performancemtd
    , performanceoneyear
    , performanceqtd
    , performancethreeyear
    , performanceytd
    , repid
    , reportname
    , salutation
    , ssn
    , state
    , statementdelivery
    , street
    , title
    , website
    , workphone
    , zip
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'households')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mwa_bulk', 'households') }}
