{% macro generate_schema_name(custom_schema_name=none, node=none) -%}

  {%- if target.name == 'dev' -%}

    {{ target.schema }}

  {%- elif target.name in ['prod', 'test'] and custom_schema_name is not none -%}

    {{ custom_schema_name | trim }}

  {%- elif target.name in ['prod', 'test'] and custom_schema_name is none -%}

    {% set node_name = node.name %}

    {%- if '__' in node_name -%}
      {% set split_name = node_name.split('__') %}
      {{ split_name[0] | trim }}
    {%- else -%}
      {{ target.schema }}
    {%- endif -%}

  {%- else -%}
    {{ target.schema }}

  {%- endif -%}

{%- endmacro %}