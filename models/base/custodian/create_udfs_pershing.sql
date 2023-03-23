{%- if execute -%}
    {%- set qry -%}
    create schema if not exists {{target.schema}};
    {{create_f_signed_to_numeric()}};
    {{create_f_yyyyddd_to_date()}};
    {% endset %}

    {{ dbt_utils.log_info('Creating function via create_f_signed_to_numeric') }}
    {{ dbt_utils.log_info('Creating function via create_f_yyyyddd_to_date') }}
    {%- set results = run_query(qry) -%}
{%- endif -%}
select 1 as _dummy
