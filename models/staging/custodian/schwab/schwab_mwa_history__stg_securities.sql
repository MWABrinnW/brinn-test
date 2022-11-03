
select
    securitysymbol
    ,securitytype
    ,securitydesc1
    ,securitydesc2
    ,securitydesc3
    ,securitydesc4
    ,price
    ,pricedate
    ,valuationunit
    ,effective_date
    ,record_datetime
    ,record_date
from {{ source('schwab_mwa', 'securities') }}