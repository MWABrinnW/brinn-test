{% macro get_project_var(var_name) -%}
    
    {%- if var_name == 'db_datalake_src' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = 'datalake_dev' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = 'datalake' -%}
        {%- else -%}
            {%- set var_value = 'datalake' -%}
        {%- endif -%}

    {%- elif var_name == 'db_datalake_dest' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = 'datalake_test' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = 'datalake' -%}
        {%- else -%}
            {%- set var_value = 'datalake_test' -%}
        {%- endif -%}

    {%- elif var_name == 'db_edw_dest' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = 'edw_test' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = 'edw' -%}
        {%- else -%}
            {%- set var_value = 'edw_test' -%}
        {%- endif -%}

    {%- elif var_name == 'db_devops_src' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = 'devops' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = 'devops' -%}
        {%- else -%}
            {%- set var_value = 'devops' -%}
        {%- endif -%}

    {%- elif var_name == 'lookback_days' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = '4' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = '4' -%}
        {%- else -%}
            {%- set var_value = '4' -%}
        {%- endif -%}

    {%- elif var_name == 'lookback_offset' -%}
        {%- if target.name == 'dev' -%}
            {%- set var_value = '0' -%}
        {%- elif target.name == 'prod' -%}
            {%- set var_value = '0' -%}
        {%- else -%}
            {%- set var_value = '0' -%}
        {%- endif -%}
    {%- else -%}
        {{ exceptions.raise_compiler_error("Invalid var_name provided") }}
    {%- endif -%}

    {% do log("var " ~ var_name ~ ": " ~ var_value, info=True) %}
    {{ return(var_value) }}

{%- endmacro %}