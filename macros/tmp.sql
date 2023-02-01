{%- set src = ref('int_adp_employees_initial') -%}

{% set qry_check_for_new_data %}
select
    case
        when (select count(*) from {{ this }}) = 0
            then 1
        when (select top 1 1
              from {{ src }}
              where _created_at > (select max(_created_at) from {{ this }})
              ) = 1
            then 1
        else 0
        end
{% endset %}

{% set results = run_query(qry_check_for_new_data) %}

{% if execute %}
  {% set result = results.columns[0].values[0] %}
{% else %}
  {% set result = 0 %}
{% endif %}