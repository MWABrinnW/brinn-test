select
    symbol         as "Symbol"
    , sec_type     as "Type"
    , iso_cfi      as iso
    , product_name as "Name"
    , cusip        as "Cusip"
from {{ ref('moxy__int_securities_build') }}
where is_new = 1
