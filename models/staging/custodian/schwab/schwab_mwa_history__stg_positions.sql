
select
    securitysymbol
    ,accountnumber
    ,accounttype
    ,longshort
    ,units
    ,effective_date
    ,record_datetime
    ,record_date
from {{ source('schwab_mwa', 'positions') }}