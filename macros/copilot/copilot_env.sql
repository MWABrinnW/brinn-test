{% macro copilot_env() -%}
  {%- if target.name == 'prod' or env_var('COPILOT_ENV', '') == 'prod' -%}

    {{ 'prod' }}

  {%- else -%}

    {{ 'uat' }}

  {%- endif -%}
{%- endmacro %}