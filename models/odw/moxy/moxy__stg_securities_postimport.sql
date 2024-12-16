select
    upper(_data:symbol::text(200)) as symbol
    , _data:ismanaged::int         as is_managed
    , _data:sectype::text(200)     as sec_type
    , left(_data:sectype , 2)      as type
    , right(_data:sectype , 2)     as iso
    , _data:seckey::int            as sec_key
    , _created_at::timestamp_ntz   as _created_at
    , row_number() over (
        partition by _created_at , symbol , is_managed::int
        order by case when left(sec_type , 1) <> 'x' then 1 else 2 end , sec_type
    )                              as rn
    , {{ col_is_head(reference=source('moxy', 'securities_postimport'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz') }}
from {{ source('moxy', 'securities_postimport') }}
