with cte_securities as (
    select
        symbol
        , sec_type
        , cusip
        , price
        , product_name
        , iso_cfi
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
    symbol               as "Symbol"
    , sec_type           as "Type"
    , iso_cfi            as iso
    , product_name       as "Name"
    , cusip              as "Cusip"
    , is_intraday_import as is_intraday_import
from cte_securities
where is_new = 1
    and rn = 1
