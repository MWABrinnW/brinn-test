{% macro has_children_in_scope(model_name, macro_name) %}
    {#
    model_name = The model you want to use as the dependency.
                If any selected resources are found that depend
                on model_name then the macro_name will be exectued.
    macro_name = The macro to execute if any selected resources
                depend on the model_name provided.
    #}

    {% set target_model = "model.data_engineering." ~ model_name %}

    {# Need to use a namespace because jinja resets vars from for loop to the outer scope. #}
    {% set has_children = namespace(value=false) %}

    {# Iterate through the selected models to check for children of the target model #}
    {{ log("Iterating selected models to check for children of " ~ target_model, info=true) }}
    {% for model in selected_resources if has_children.value == false %}

        {# Pull up the node from the graph #}
        {% set node = graph.nodes.get(model) %}

        {% if target_model in node.depends_on.nodes %}
            {% set has_children.value = true | as_bool %}
        {% endif %}

    {% endfor %}

    {# If the target model has children in the current run, execute another macro #}
    {% if has_children.value %}
        {{ log("Attempting to run macro " ~ macro_name, info=true) }}
        {% set macro_to_exec = context.get(macro_name) %}
        {% do macro_to_exec() %}
    {% endif %}

{% endmacro %}
