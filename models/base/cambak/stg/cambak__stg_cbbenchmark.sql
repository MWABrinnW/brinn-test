select
    benchmarkid::int                           as benchmark_id
    , benchmarkname::text                      as benchmark_name
    , firmid::int                              as firm_id
    , region::int                              as region
    , assetclass::int                          as asset_class
    , assetcategory::int                       as asset_category
    , markettype::int                          as market_type
    , to_boolean(issharedbenchmark::text)::int as is_shared_benchmark

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                          as _extracted_at
    , file_type::text                          as file_type
    , _created_at::timestamp                   as _created_at
    , _source_file::text                       as _source_file
from {{ source('cambak', 'cbbenchmark') }}
