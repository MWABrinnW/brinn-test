select
    clientfeeid::int           as client_fee_id
    , billingdefinitionid::int as billing_definition_id
    , q1annual::number(20 , 2) as q1_annual
    , q1fee::number(20 , 2)    as q1_fee
    , q2annual::number(20 , 2) as q2_annual
    , q2fee::number(20 , 2)    as q2_fee
    , q3annual::number(20 , 2) as q3_annual
    , q3fee::number(20 , 2)    as q3_fee
    , q4annual::number(20 , 2) as q4_annual
    , q4fee::number(20 , 2)    as q4_fee
    , year::int                as year

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                          as _extracted_at
    , file_type::text          as file_type
    , _created_at::timestamp   as _created_at
    , _source_file::text       as _source_file
from {{ source('cambak', 'cbclientfees') }}
