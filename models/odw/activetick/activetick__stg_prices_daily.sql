with cte as (
    select
        content:tm::timestamp                                                     as at_timestamp
        , _created_at                                                             as _created_at
        , row_number() over (partition by at_timestamp order by _created_at desc) as rn
    from {{ source('activetick', 'prices_daily') }}
    group by 1 , 2
)

select
    a.content:symbol::text(200)                   as activetick_symbol
    , split(a.content:symbol , '_')[0]::text(200) as symbol
    , a.content:o::decimal(18 , 2)                as open_price
    , a.content:c::decimal(18 , 2)                as close_price
    , a.content:h::decimal(18 , 2)                as high_price
    , a.content:l::decimal(18 , 2)                as low_price
    , a.content:v::int                            as volume
    , a.content:t::int                            as trade_count
    , a.content:tm::timestamp                     as at_timestamp
    , case when a.content:symbol like '%_I%'
            then 1
        else 0
    end                                           as is_index
    , a._created_at::timestamp                    as _created_at
    , case when b.rn = 1 then 1 else 0 end        as is_latest
from {{ source('activetick', 'prices_daily') }} as a
left join cte as b
    on a.content:tm = b.at_timestamp
    and a._created_at = b._created_at
