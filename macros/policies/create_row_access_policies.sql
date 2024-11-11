{% macro create_row_access_policies() %}
    {%- set do_rap = str_to_bool(env_var('DBT_RAP', true)) %}

    {%- if execute -%}
        {% if do_rap %}

            {% if any_rap_in_scope() %}

                {{ log("Creating/altering row access policies (DBT_RAP=" ~ do_rap ~ ")", info=true) }}

                -- CREATE ROW ACCESS POLICIES
                {{ rap_firm_source() }}
                {{ rap_tradeops_venue() }}

            {% endif %}

        {%- else -%}

            {{ log("Not creating row access policies (DBT_RAP=" ~ do_rap ~ ")", info=true) }}

        {% endif %}
    {%- endif -%}
{% endmacro %}
