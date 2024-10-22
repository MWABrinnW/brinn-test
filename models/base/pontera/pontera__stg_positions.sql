{% set src = source('pontera', 'positions') %}
select
    _data:"account id"::text(200)         as account_id
    , _data:"security id"::text(200)      as security_id
    , _data:"quantity"::number(19 , 6)    as quantity
    , _data:"total value"::number(19 , 2) as total_value
    , _data:"effective date"::date        as position_effective_date

    , effective_date::date                as effective_date
    , _created_at::timestamp              as _created_at
    , _source_file::text(200)             as _source_file
    , dense_rank() over (
        partition by effective_date order by _created_at desc
    )                                     as is_head_for_day
    , case
        when is_head_for_day = 1
            and effective_date = (select max(effective_date) from {{ src }})
            then 1
        else 0
    end::int                              as is_head
from {{ src }}
