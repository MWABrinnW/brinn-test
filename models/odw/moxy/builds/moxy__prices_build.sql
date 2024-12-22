with cte_securities as (
    select
        sec_type
        , symbol
        , price
        , is_intraday_import
        , effective_date
        , row_number() over (
            partition by symbol , sec_type
            order by price desc
        ) as rn
    from {{ ref('moxy__int_securities_build') }}
)

select
    left(sec_type , 2)                           as "type"
    , 'USD'                                      as "iso"
    , left(upper(symbol)::text, 24)              as "symbol"
    , max(price)                                 as "price"
    , is_intraday_import                         as is_intraday_import
    -- price date aka effective_date
    , to_char(effective_date::date , 'YYYYMMDD') as "stdate"
from cte_securities
where rn = 1
group by all
order by 3
