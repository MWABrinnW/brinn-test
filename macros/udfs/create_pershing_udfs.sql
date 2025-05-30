{%- macro create_pershing_udfs() -%}

{%- if execute and flags.WHICH in ('run', 'build', 'clone') -%}

    {{ log('Creating udf--> ' ~ target.schema ~ '.signed_to_numeric()', info=true) }}
    {{ log('Creating udf--> ' ~ target.schema ~ '.yyyyddd_to_date()', info=true) }}
    {% set sql -%}
    create schema if not exists {{target.schema}};

    {{create_f_signed_to_numeric()}};

    {{create_f_yyyyddd_to_date()}};
    {% endset %}

    {% set results = run_query(sql) %}

{%- endif -%}

{%- endmacro -%}
