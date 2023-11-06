{%- macro create_udfs() -%}

{%- if execute -%}

create schema if not exists {{target.schema}};

{{ dbt_utils.log_info('Creating udf--> ' ~ target.schema ~ ' signed_to_numeric()')}}
{{create_f_signed_to_numeric()}};

{{ dbt_utils.log_info('Creating udf--> ' ~ target.schema ~ ' yyyyddd_to_date()')}}
{{create_f_yyyyddd_to_date()}};

{%- endif -%}

{%- endmacro -%}