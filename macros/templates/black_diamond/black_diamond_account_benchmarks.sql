{%- macro black_diamond_account_benchmarks(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}

select
    'black_diamond'::text(200)                     as system_name
    , '{{ instance }}'::text(200)                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , '{{ firm_source }}'::text(200)               as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::text(200)              as account_number
    , benchmark.value:Name::text(500)              as benchmark_name
    , a.record_id                                  as record_id
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                            as _source_loaded_at
    {%- if extra_columns -%}
    {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
, table(flatten(a.json , 'Benchmarks')) as benchmark
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}