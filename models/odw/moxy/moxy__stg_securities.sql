with cte_positions as (
    select
        sec_key
        , count(*) as position_count
    from {{ ref('moxy__stg_positions') }}
    where is_head = 1
    group by sec_key
)

select
    upper(_data:symbol::text(200))    as symbol
    , _data:ismanaged::int            as is_managed
    , _data:sectype::text(200)        as sec_type
    , left(_data:sectype , 2)         as type
    , right(_data:sectype , 2)        as iso
    , se._data:seckey::int            as sec_key
    , _created_at::timestamp_ntz      as _created_at
    -- Consider the number of portfolios holding a given version of a security
    --   when assigning row number. Undefined securities are lowest priority.
    , row_number() over (
        partition by _created_at , symbol , is_managed::int
        order by
            case
                when left(sec_type , 1) <> 'x'
                    then coalesce(po.position_count , 0)
                else -1
            end desc
            , sec_type
    )                                 as rn
    , coalesce(po.position_count , 0) as position_count
    , {{ col_is_head(reference=source('moxy', 'securities'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz') }}
from {{ source('moxy', 'securities') }} as se
left join cte_positions as po
    on se._data:seckey::int = po.sec_key
