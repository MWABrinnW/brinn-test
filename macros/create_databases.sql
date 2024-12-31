{% macro create_databases() %}
    /*
      This macro creates any databases required for dbt models.
    */

    {% set databases = [] %}

    {% if execute %}
        {{ log("Evaluating if there are any databases that need to be created") }}

        {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}
            {% if node.unique_id in selected_resources %}

                {% set database_name = node.database %}

                {% if database_name not in databases %}
                    {% do databases.append(database_name) %}
                {% endif %}

            {% endif %}
        {% endfor %}
    {% endif %}

    {% set sql %}
        {% for database in databases %}
            {{ log("Creating database if not exists " ~ database, info=True) }}
            create database if not exists {{ database }};
        {% endfor %}
    {% endset %}

    {{ return(sql) }}
{% endmacro %}
