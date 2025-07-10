{% set src = source('cambak', 'cbiproductrating') %}
select
    iproductratingid::int       as i_product_rating_id
    , ratingdate::timestamp_ntz as rating_date
    , ratingnote::text          as rating_note
    , recommendationid::int     as recommendation_id
    , guidanceid::int           as guidance_id
    , iproductid::int           as i_product_id
    , firmid::int               as firm_id
    , userid::int               as user_id
    , sponsorid::int            as sponsor_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                           as _extracted_at
    , file_type::text           as file_type
    , _created_at::timestamp    as _created_at
    , _source_file::text        as _source_file
from {{ src }}
