{% macro generate_base_models_pms(pms, pms_location, table_name, firm_source='mwa', leading_commas=False, case_sensitive_cols=False, materialized=None) %}

{%- set source_name = pms + '_' + pms_location -%}
{%- set source_relation = source(source_name , table_name) -%}

{%- set columns = adapter.get_columns_in_relation(source_relation) -%}
{% set column_names=columns | map(attribute='name') %}
{% set base_model_sql %}

{%- if materialized is not none -%}
    {{ "{{ config(materialized='" ~ materialized ~ "') }}" }}
{%- endif %}

select
    {{ "'" ~ pms ~ "' as pms" }}
    {{ ", '" ~ pms_location ~ "' as pms_location" }}
    {{ ", '" ~ firm_source ~ "' as firm_source" }}
    {{ ", effective_date" }}
    {%- for column in column_names if not (column | lower in ['effective_date', 'record_datetime', 'record_date']) %}
    {{", "}}{% if not case_sensitive_cols %}{{ column | lower }}{% elif target.type == "bigquery" %}{{ column }}{% else %}{{ "\"" ~ column ~ "\"" }}{% endif %}
    {%- endfor %}
    {{", {{ col_is_head(reference=source('" ~ source_name ~ "', '" ~ table_name ~ "')) }}"}}
    {{", {{ col_is_current(date_col='effective_date') }}"}}
    {{", record_datetime as _source_loaded_at"}}
from {% raw %}{{ source({% endraw %}'{{ source_name }}', '{{ table_name }}'{% raw %}) }}{% endraw %}

{% endset -%}

{% if execute -%}

{{ log(base_model_sql, info=True) }}
{% do return(base_model_sql) -%}

{% endif -%}
{% endmacro -%}
