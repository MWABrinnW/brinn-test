{%- macro black_diamond_account_tags(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}
select
    'black_diamond'::text(200)                     as system_name
    , '{{ instance }}'::text(200)                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , '{{ firm_source }}'::text(200)               as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , h.value:Name::string                         as tag_name
    , h.value:Value::string                        as tag_value
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
, lateral flatten(input => a.json:Tags) as h
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}