select
    'axys' as pms
    , 'granite' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , securitytype
    , quantity
    , symbol
    , securityname
    , cusip
    , costbasis
    , price
    , marketvalue
    , portfoliocode
    , asofdate
    , accountnumber
    , {{ col_is_head(reference=source('axys_granite', 'holdings_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('axys_granite', 'holdings_monthly') }}