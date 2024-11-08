{% macro any_rap_in_scope() %}
    {#
    Return true if there is at least one view in the selected resources that uses
    a row access policy.
    #}

    {% set target_model = "model.data_engineering." ~ model_name %}

    {# Need to use a namespace because jinja resets vars from for loop to the outer scope. #}
    {% set has_children = namespace(value=false) %}

    {# Iterate through the selected models to check for children of the target model #}
    {{ log("Checking for use of row access policies within the selected views", info=true) }}
    {% for model in selected_resources %}

        {# Pull up the node from the graph #}
        {% set node = graph.nodes.get(model) %}

        {% if node.config.materialized == "view" %}


            {% set meta_objects = get_meta_objects(node_unique_id=model, meta_key="row_access_policy") %}
            {% if meta_objects | length > 0 %}
                {{ return(true) }}
            {% endif %}

        {% endif %}

    {% endfor %}

    {{ log("No views in scope use row access policies", info=true) }}
    {{ return(false) }}

{% endmacro %}
