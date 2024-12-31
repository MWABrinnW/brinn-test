{% macro generate_alias_name(custom_alias_name=none, node=none) -%}

  {%- if (target.name == 'dev' and custom_alias_name is none) or node.package_name == 'dbt_artifacts' -%}

    {{ node.name }}

  {%- elif target.name == 'dev' and custom_alias_name is not none -%}

    {{ custom_alias_name | trim }}

  {%- elif target.name in ['prod', 'ci'] and custom_alias_name is not none and node.resource_type != 'test' -%}

    {{ custom_alias_name | trim }}

  {%- elif target.name in ['prod', 'ci'] and custom_alias_name is none and node.resource_type != 'test' -%}

    {% set node_name = node.name %}

    {%- if '__' in node_name -%}

      {% set split_name = node_name.split('__') %}
      {{ split_name[1] | trim }}

    {%- else -%}

      {{ node.name }}

    {%- endif -%}

  {%- else -%}

    {{ node.name }}

  {%- endif -%}

{%- endmacro %}