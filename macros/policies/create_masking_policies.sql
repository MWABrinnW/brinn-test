{% macro create_masking_policies() %}
    {%- set do_mp = env_var('DBT_MP', True) | as_bool %}
    {%- if execute -%}
        {% if do_mp %}

            {% if any_mp_in_scope() == true %}

                {{ log("Creating/altering masking policies (DBT_MP=" ~ do_mp ~ ")", info=true) }}

                -- CREATE ROW ACCESS POLICIES
                {{ mp_client_pii_text() }}
                {{ mp_client_pii_date() }}
                {{ mp_client_pii_number() }}
                {{ mp_client_pii_float() }}

                {{ mp_associate_pii_text() }}
                {{ mp_associate_pii_date() }}

            {% endif %}

        {%- else -%}

            {{ log("Not creating any masking policies (DBT_MP=" ~ do_mp ~ ")", info=true) }}

        {% endif %}
    {%- endif -%}
{% endmacro %}
