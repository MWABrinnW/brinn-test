{% set src = source('pontera', 'prices') %}
select
    _data:"security id"::text(200)        as security_id
    , _data:"effective date"::date        as price_effective_date
    , _data:"asset price"::number(19 , 5) as asset_price

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
