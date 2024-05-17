{% set src = source('black_diamond_uhnw', 'accounts') %}

select
    'black_diamond'                                as system_name
    , 'uhnw'                                       as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , benchmark.value:Name::string                 as benchmark_name
    , a.record_id                                  as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , a.record_datetime                            as _source_loaded_at
from {{ src }} as a
, table(flatten(a.json , 'Benchmarks')) as benchmark
