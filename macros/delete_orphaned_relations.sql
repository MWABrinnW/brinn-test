--instructions
--
--If you want to simply see which tables/views exist in Snowflake, that are not in the dbt graph:
--dbt run-operation delete_orphaned_relations --args "{dry_run: True}"
--
--if you want to actually drop those tables/views:
--dbt run-operation delete_orphaned_relations --args "{dry_run: False}"
--
--Note by default this macro will look in the database specified in your default target, as defined in your profiles.yml.
--you can be explicit about the database, by specifying a different target (add --target argument),
--but you will need to set up targets per database, i.e. not just dev/prod, but for example:
--  dev
--  dev-raw
--  dev-analytics
--  prod
--
--so then you might run for example:
--dbt run-operation delete_orphaned_relations --args "{dry_run: True}" --target dev-analytics

{% macro delete_orphaned_relations(dry_run=True) %}
  {% set database_list = ['datalake'] %}
  {% set dbt_dbs_to_exclude = ['fivetran', 'reporting'] %}

  {% do log("", True) %}
  {% do log("Searching for orphaned tables/views...", True) %}
  {% do log("Using target profile: " ~ target.name ~ " (database: " ~ target.database ~ ").", True) %}

  {# Get all databases #}
  {% set models = [] %}
  {% set databases = {} %}
  {%- for node in (graph.nodes.values() | selectattr("resource_type", "equalto", "model") | list
                + graph.nodes.values() | selectattr("resource_type", "equalto", "seed")  | list
                + graph.sources.values() | selectattr("resource_type", "equalto", "source") | list) %}
    {%- if node.database in database_list -%}
        {%- set database = node.database -%}
        {%- set schema = node.schema -%}
        {%- if node.resource_type == 'source' -%}
            {%- set alias = node.name -%}
        {%- else -%}
            {%- set alias = node.alias -%}
        {%- endif -%}

        {%- set relation = {'database': database, 'schema': schema, 'alias': alias} -%}
        
        {%- do models.append(relation) -%}

        {%- if database in databases %}
            {% if schema not in databases[database] %}
                {% do databases.update({database: databases[database] + [schema]}) %}
            {% endif %}
        {%- else %}
            {# Add database and schema because neither exist #}
            {{ dbt_utils.log_info('Adding database ' ~ database ~ ' to dict') }}
            {% do databases.update({database: [schema]}) %}
        {%- endif %}
    {%- endif -%}

  {%- endfor %}

  {#
    {% do log(schema_query, True) %}
  #}

{% do log("", True) %}

{% set query %}
with cte_all_existing_relations as
(
    {% for key, value in databases.items() %}
    SELECT
         upper(table_catalog)   as database_name
        ,upper(table_schema)    as schema_name
        ,upper(table_name)      as ref_name
        ,case
            when table_type = 'VIEW'
                then 'view'
            when table_type = 'BASE TABLE'
                then 'table'
            else null
            end          as ref_type
    FROM {{key}}.information_schema.tables
    where table_schema not in ('INFORMATION_SCHEMA')

    {% if not loop.last -%} UNION ALL {% endif -%}

    {% endfor %}
)
,cte_dbt_relations as 
(
    {%- for node in models-%}
        {%- if node.database | lower not in dbt_dbs_to_exclude -%}
        {%- set db = "upper('" ~ node.database ~ "')" -%}
        {%- set sch = "upper('" ~ node.schema ~ "')" -%}
        {%- set rel = "upper('" ~ node.alias ~ "')" %}
        SELECT
              {{db.ljust(49)}}  as database_name
            , {{sch.ljust(50)}} as schema_name
            , {{rel.ljust(50)}} as ref_name
        {% if not loop.last %} UNION ALL {% endif %}
        {%- endif -%}
    {%- endfor %}
)

SELECT   c.database_name as database_name
        ,c.schema_name   as schema_name
        ,c.ref_name      as ref_name
        ,c.ref_type      as ref_type
FROM cte_all_existing_relations c
LEFT JOIN cte_dbt_relations desired
    on c.database_name = desired.database_name
    and c.schema_name = desired.schema_name
    and c.ref_name = desired.ref_name
WHERE desired.ref_name is null
{% endset %}


{{ dbt_utils.log_info(query) }}

{#
{%- set result = run_query(query) -%}
{% if result %}
    {%- for to_delete in result -%}
    {%- if dry_run -%}
        {%- do log('To be dropped: ' ~ to_delete[2] ~ ' ' ~ to_delete[0] ~ '.' ~ to_delete[1], True) -%}
    {%- else -%}
        {% set drop_command = 'DROP ' ~ to_delete[2] ~ ' IF EXISTS ' ~ to_delete[0] ~ '.' ~ to_delete[1] ~ ' CASCADE;' %}
        {% do run_query(drop_command) %}
        {%- do log('Dropped ' ~ to_delete[2] ~ ' ' ~ to_delete[0] ~ '.' ~ to_delete[1], True) -%}
    {%- endif -%}
    {%- endfor -%}
{% else %}
{% do log('No orphan tables to clean.', True) %}
{% endif %}
#}

{% endmacro %}