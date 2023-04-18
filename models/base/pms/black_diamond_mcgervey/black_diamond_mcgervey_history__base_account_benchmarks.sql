{% set src = source('black_diamond_mcgervey', 'accounts') %}

select
  'black_diamond'                            as pms
  , 'mcgervey'                                    as pms_location
  , 'mwa'                                    as firm_source
  , EFFECTIVE_DATE as effective_date
  , JSON:AccountNumber::string as account_number
  , benchmark.value:Name::string as benchmark_name
  , RECORD_ID as record_id
  , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime as _source_loaded_at
from {{ src }},
  table(flatten(JSON, 'Benchmarks')) AS benchmark
