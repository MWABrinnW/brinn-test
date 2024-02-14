{% macro flyer_env() -%}
  {%- if target.name == 'prod' -%}

    {{ 'prod' }}

  {%- else -%}

    {{ 'uat' }}

  {%- endif -%}
{%- endmacro %}