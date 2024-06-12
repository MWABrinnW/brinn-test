select
    json:"SYSTEM_KEY"::varchar(200)          as system_key
    , json:"FEE_TYPE"::varchar(200)          as fee_type
    , json:"REVENUE_CATEGORY"::varchar(200)  as revenue_category
    , json:"BILLING_FREQUENCY"::varchar(200) as billing_frequency
    , _created_at::datetime                  as _created_at
    , _box_file_id::varchar(100)             as _box_file_id
    , _box_file_name::varchar(100)           as _box_file_name
    , _box_meta::variant                     as _box_meta
    , _id::int                               as _id
from {{ source('aux', 'financials_fee_type') }}
order by system_key , fee_type , revenue_category
