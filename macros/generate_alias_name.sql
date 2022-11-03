{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
  {%- if target.name == 'dev' and custom_alias_name is none -%}
    {{ node.name }}
  {%- elif target.name == 'dev' and custom_alias_name is not none -%}
    {{ custom_alias_name | trim }}
  {%- elif target.name == 'prod' and custom_alias_name is not none -%}
    {{ custom_alias_name | trim }}
  {%- elif target.name == 'prod' and custom_alias_name is none -%}
    {% set node_name = node.name %}
    {% set split_name = node_name.split('__') %}
    {{ split_name[1] | trim }}
  {%- else -%}
    {{ node.name }}
  {%- endif -%}
{%- endmacro %}