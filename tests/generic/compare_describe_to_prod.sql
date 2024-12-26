{% test compare_describe_to_prod(
    model,
    state_database,
    state_schema,
    state_name,
    summarize = False,
    include_columns = None,
    exclude_columns = None,
    where_clause = None
    ) -%}
    {{ config(enabled = (target.name != "prod")) }}

    {% if execute -%}
    {# Currently no known way to retrieve the state graph and lookup the prod relation automatically.
        Until then, we must provide the three parts in the test config.
    #}
    {% set prod_relation = adapter.get_relation(
        database = state_database,
        schema = state_schema,
        identifier = state_name
    ) -%}

    {# Ideally, we could know before now whether or not we need to test a dev model against
    an existing prod model (do they both exist?). I could not find a a way to determine
    that beforehand so here we return a fake test that will succeed.
    This mainly only matters if `dbt test` is used on a model because if `dbt build`
    captures a model then it will build the model and then test it, meaning it will
    then exist in the dev/ci environment. #}

    {% if prod_relation is none -%}
        {{ log("No prod relation available for comparison. Is this is a new model?", info=true) }}
        select 1 as test where 1=2
    {% elif (model | lower | replace('"', '')) == (prod_relation | lower | replace('"', '')) -%}
        {{ log("No dev relation available for comparison. Is it deferred? "
             ~ model ~ " vs " ~ prod_relation | lower | replace('"', ''), info=true) }}
        select 1 as test where 1=2
    {% else -%}
        {% set dev_query = describe_model_flat_unpivoted(
            model=model, where_clause=where_clause, include_columns=include_columns, exclude_columns=exclude_columns
            ) -%}
        {% set prod_query = describe_model_flat_unpivoted(
            model=prod_relation, where_clause=where_clause, include_columns=include_columns, exclude_columns=exclude_columns
            ) -%}
        {{ compare_queries(
            a_query = prod_query,
            b_query = dev_query,
            summarize = summarize
        ) }}
        order by 2, 1
    {% endif -%}

{% endif -%}

{% endtest -%}
