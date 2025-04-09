select
    lower(json:system_name::varchar(200))            as system_name
    , lower(json:tax_office_name::varchar(200))      as tax_office_name
    , json:coa_segment_3_accounting_id::varchar(200) as coa_segment_3_accounting_id
    , json:start_date::date                          as start_date
    , json:end_date::date                            as end_date
    , json:_box_file_id::varchar(100)                as _box_file_id
    , json:_box_meta::variant                        as _box_meta
    , json:_box_file_name::varchar(200)              as _box_file_name
    , _created_at::datetime                          as _created_at
    , _id::int                                       as _id
    , row_number() over (
        partition by system_name , tax_office_name
        order by _id desc
    )                                                as rn
-- returns one 'tax_office_name' per 'system_name', apply filter in downstream models for deduplication
from {{ source('aux', 'tax_location_mapping') }}
