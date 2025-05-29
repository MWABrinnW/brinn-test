{% macro create_masking_policies() %}
    {%- set do_mp = str_to_bool(env_var('DBT_MP', true)) %}

    {%- if execute -%}
        {% if do_mp %}

            {% if any_mp_in_scope() or cvar('force_create_policies') %}

                {{ log("Creating/altering masking policies (DBT_MP=" ~ do_mp ~ ")", info=true) }}

                {# CREATE ROW ACCESS POLICIES #}
                {%- set sql -%}
                {{ mp_client_pii_text() }}
                {{ mp_client_pii_date() }}
                {{ mp_client_pii_number() }}
                {{ mp_client_pii_float() }}

                {{ mp_associate_pii_text() }}
                {{ mp_associate_pii_date() }}
                {%- endset -%}

                {% set results = run_query(sql) %}

            {% endif %}

        {%- else -%}

            {{ log("Not creating masking policies (DBT_MP=" ~ do_mp ~ ")", info=true) }}

        {% endif %}
    {%- endif -%}
{% endmacro %}
