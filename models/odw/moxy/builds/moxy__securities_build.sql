select
    left(sec_type , 2)   as "type"
    , 'USD'              as "iso"
    , symbol             as "symbol"
    , cusip              as "cusip"
    , product_name       as "name"
    , is_intraday_import as is_intraday_import
from {{ ref('moxy__int_securities_build') }}
where is_new = 1
