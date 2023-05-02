select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , security_id
    , cusip
    , ticker
    , pricing_custodian
    , price_date
    , price
    , {{ col_is_head(reference=source('envestnet_mwa', 'securityprice_firm_security_price')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'securityprice_firm_security_price') }}


