{{ config(enabled=false) }}
select
     'schwab'                       as custodian
    ,securitysymbol                 as security_symbol
    ,securitytype                   as security_type
    ,securitydesc1                  as security_description_1
    ,securitydesc2                  as security_description_2
    ,securitydesc3                  as security_description_3
    ,securitydesc4                  as security_description_4
    ,price                          as price
    ,pricedate                      as price_date
    ,valuationunit                  as valuation_unit
    ,effective_date::date           as effective_date
    , {{ col_is_head(reference=source('schwab_mps', 'securities')) }}
    , {{ col_is_current(date_col='effective_date') }}
    ,record_datetime::timestamp     as record_datetime
    ,record_date::date              as record_date
    ,record_datetime::timestamp     as _source_loaded_at
from {{ source('schwab_mps', 'securities') }}