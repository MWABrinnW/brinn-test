select
    _data:portid::text                          as port_id
    , _data:postype::int                        as pos_type
    , _data:preallocpos::decimal(19 , 6)        as pre_alloc_pos
    , _data:preallocvaluebasis::decimal(19 , 6) as pre_alloc_value_basis
    , _data:allocpos::decimal(19 , 6)           as alloc_pos
    , _data:allocvaluebasis::decimal(19 , 6)    as alloc_value_basis
    , _data:openpos::decimal(19 , 6)            as open_pos
    , _data:openvaluebasis::decimal(19 , 6)     as open_value_basis
    , to_timestamp_tz(
        _data:positiondate::text , 'MM/DD/YYYY HH12:MI:SS AM'
    )::date                                     as position_date
    , _data:pledgeid::text                      as pledge_id
    , _data:iszeromv::int                       as is_zero_mv
    , _data:seckey::int                         as sec_key
    , _created_at                               as _created_at
    , _source_file                              as _source_file
    , _id                                       as _id
    , {{ col_is_head(reference=source('moxy', 'positions'),
        source_date_col='_created_at',
        reference_date_col='_created_at') 
    }}
from {{ source('moxy', 'positions') }}
where coalesce(port_id , '') <> ''
