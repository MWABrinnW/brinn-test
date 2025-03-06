with cte_securities as (
    -- Mitigates having multiple securities of the same type with different prices
    select
        effective_date            as effective_date
        , symbol                  as symbol
        , sec_type                as sec_type
        , iso_cfi                 as iso_cfi
        , max(price)              as price
        , max(is_intraday_import) as is_intraday_import
    from {{ ref('moxy__int_securities_build') }}
    group by all
)

select
    left(sec_type , 2)                           as type
    , 'USD'                                      as iso
    , left(upper(symbol)::text , 24)             as symbol
    , max(price)                                 as price
    , is_intraday_import                         as is_intraday_import
    -- price date aka effective_date
    , to_char(effective_date::date , 'YYYYMMDD') as stdate
from cte_securities
group by all
order by 3
