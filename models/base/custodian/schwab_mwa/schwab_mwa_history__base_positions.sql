
select
    securitysymbol                  as security_symbol
    ,accountnumber                  as account_number
    ,accounttype                    as account_type
    ,longshort                      as long_short
    ,units                          as units
    ,'mwa'                          as firm_source
    ,effective_date::date           as effective_date
    ,{{ col_is_head(reference=source('schwab_mwa', 'positions')) }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,record_datetime::timestamp     as record_datetime
    ,record_date::date              as record_date
    ,record_datetime::timestamp     as _source_loaded_at
from {{ source('schwab_mwa', 'positions') }}