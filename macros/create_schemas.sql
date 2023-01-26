{% macro create_schemas() %}
    /*
      https://docs.getdbt.com/blog/configuring-grants#is-there-still-a-place-for-hooks
      Note: This is pseudo code only, for demonstration purposes
      For every role that can access at least one object in a schema,
      grant 'usage' on that schema to the role.
      That way, users with the role can run metadata queries showing objects
      in that schema (a common need for BI tools)
    */
  {% set schema_grants = {} %}
  {% if execute %}
    {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}
      {% set grants = node.config.get('grants') %}
      {% set select_roles = grants['select'] if grants else [] %}
      {% if select_roles %}
        {% set database_schema = node.database ~ "." ~ node.schema %}
        {% if database_schema in database_schemas %}
          {% do schema_grants[database_schema].add(select_roles) %}
        {% else %}
          {% do schema_grants.update({database_schema: set(select_roles)}) %}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% endif %}
  {% set grant_list %}
    {% for schema in schema_grants %}
      {% if schema_grants[schema] | length > 0 %}
        {{ dbt_utils.log_info("Creating schema if not exists " ~ schema) }}
        create schema if not exists {{ schema }};
      {% endif %}
    {% endfor %}
  {% endset %}
  {{ return(grant_list) }}
{% endmacro %}