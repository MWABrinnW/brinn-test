select
    left(sec_type , 2)        as "type"
    , 'USD'                   as "iso"
    , left(symbol, 24)        as "symbol"
    , left(cusip, 15)         as "cusip"
    , left(product_name, 43)  as "name"
    , is_intraday_import      as is_intraday_import
from {{ ref('moxy__int_securities_build') }}
where is_new = 1
