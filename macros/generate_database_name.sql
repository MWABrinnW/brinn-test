{% macro generate_database_name(custom_database_name=none, node=none) -%}
    {%- set default_database = target.database -%}
    {%- if target.name == 'dev' -%}
        {{ default_database }}
    {%- elif target.name in ['prod', 'test'] and custom_database_name is not none -%}
        {{ custom_database_name }}
    {%- else -%}
        {{ default_database }}
    {%- endif -%}
{%- endmacro %}