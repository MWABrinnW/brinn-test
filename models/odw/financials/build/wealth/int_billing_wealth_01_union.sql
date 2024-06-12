{%- set source_models =
    [
        'nml_bills_salesforce_compass'
        ,'nml_bills_addepar_corbenic'
        ,'nml_bills_black_diamond_houston'
        ,'nml_bills_sei_manasquan'
        ,'nml_bills_axys_granite'
        ,'nml_bills_orion_san_jose'
    ] -%}

{% for model in source_models -%}
    select * from {{ ref(model) }}
    {%- if not loop.last %} union all {% endif -%}
{% endfor %}
