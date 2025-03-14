select
    benchmarkslistid::int                       as benchmarks_list_id
    , parententityid::int                       as parent_entity_id
    , parententitytypeid::int                   as parent_entity_typeid
    , parentclientid::int                       as parent_client_id
    , to_boolean(isprimarybenchmark::text)::int as is_primary_benchmark
    , benchmarkid::int                          as benchmark_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                           as _extracted_at
    , file_type::text                           as file_type
    , _created_at::timestamp                    as _created_at
    , _source_file::text                        as _source_file
from {{ source('cambak', 'cbbenchmarkslist') }}
