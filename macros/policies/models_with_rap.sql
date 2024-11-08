{% macro models_with_rap() %}
    {#
    Return all view models that have a row access policy.
    #}

    {% for model in graph.nodes %}

        {% set node = graph.nodes.get(model) %}
        {% if node.config.materialized == "view" %}


            {% set meta_objects = get_meta_objects(node_unique_id=node.unique_id, meta_key="row_access_policy") %}
            {% if meta_objects | length > 0 %}
                {{ print(node.name) }}
            {% endif %}

        {% endif %}

    {% endfor %}

{% endmacro %}
