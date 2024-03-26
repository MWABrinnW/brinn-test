{{ config(enabled = false) }}
{%- if execute -%}
    {%- set qry -%}
    create schema if not exists {{target.schema}};
    {{create_f_get_fidelity_taxlots()}};
    {% endset %}

    {{ log('Creating function via create_f_get_fidelity_taxlots', info=true) }}
    {%- set results = run_query(qry) -%}
{%- endif -%}
select 1 as _dummy
