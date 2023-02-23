
select
    securitysymbol
    ,accountnumber
    ,accounttype
    ,longshort
    ,units
    ,case when effective_date::date = (select max(effective_date::date) from {{ source('schwab_mwa', 'positions') }}) then 1 else 0 end as is_current
    ,effective_date::date           as effective_date
    ,record_datetime::timestamp     as record_datetime
    ,record_datetime::timestamp     as _source_loaded_at
    ,record_date::date              as record_date
from {{ source('schwab_mwa', 'positions') }}