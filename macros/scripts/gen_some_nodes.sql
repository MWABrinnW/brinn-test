

{%- for node in (graph.nodes.values() | selectattr("resource_type", "equalto", "model") | list
            + graph.nodes.values() | selectattr("resource_type", "equalto", "seed")  | list
            + graph.sources.values() | selectattr("resource_type", "equalto", "source") | list) %}

    {{ node }}

{%- endfor %}

