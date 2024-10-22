{% set src = source('pontera', 'securities') %}
select
    _data:"category"::text(200)        as category
    , _data:"security id"::text(200)   as security_id
    , _data:"ticker"::text(200)        as ticker
    , _data:"security type"::text(200) as security_type
    , _data:"name"::text(200)          as name

    , effective_date::date             as effective_date
    , _created_at::timestamp           as _created_at
    , _source_file::text(200)          as _source_file
    , dense_rank() over (
        partition by effective_date order by _created_at desc
    )                                  as is_head_for_day
    , case
        when is_head_for_day = 1
            and effective_date = (select max(effective_date) from {{ src }})
            then 1
        else 0
    end::int                           as is_head
from {{ src }}
