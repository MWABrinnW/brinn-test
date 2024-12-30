with cte_securities as (
    select
        symbol
        , sec_type
        , cusip
        , price
        , product_name
        , is_intraday_import
        , is_new
        -- Mitigates having multiple securities of the same type with different prices
        , row_number() over (
            partition by symbol , sec_type
            order by price desc
        ) as rn
    from {{ ref('moxy__int_securities_build') }}
)

select
    left(sec_type , 2)        as "type"
    , 'USD'                   as "iso"
    , left(symbol, 24)        as "symbol"
    , left(cusip, 15)         as "cusip"
    , left(product_name, 43)  as "name"
    , is_intraday_import      as is_intraday_import
from cte_securities
where is_new = 1
    and rn = 1
