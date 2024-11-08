{% macro snowflake__create_or_replace_view() %}
  {%- set identifier = model['alias'] -%}

  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
  {%- set exists_as_view = (old_relation is not none and old_relation.is_view) -%}

  {%- set target_relation = api.Relation.create(
      identifier=identifier, schema=schema, database=database,
      type='view') -%}
  {%- set grant_config = config.get('grants') -%}

  {{ run_hooks(pre_hooks) }}

  -- If there's a table with the same name and we weren't told to full refresh,
  -- that's an error. If we were told to full refresh, drop it. This behavior differs
  -- for Snowflake and BigQuery, so multiple dispatch is used.
  {%- if old_relation is not none and not old_relation.is_view -%}
    {{ handle_existing_table(should_full_refresh(), old_relation) }}
  {%- endif -%}

  {# ============================================ #}

  {%- set fqn = database ~ '.' ~ schema ~ '.' ~ identifier %}

  {# Get model meta info to determine if it has any policies that need applied #}
  {# Row access policy columns #}
  {%- set rap_columns = get_meta_objects(model.unique_id, meta_key='row_access_policy') -%}

  {# Column masking columns #}
  {% set mp_columns = get_meta_objects(model.unique_id, meta_key='masking_policy') %}

  {# Get the initial sql that dbt would default generate #}
  {%- set initial_sql -%}
    {{ get_create_view_as_sql(target_relation, sql) }}
  {%- endset -%}

  {# Use string parsing to update the default view sql that is generated #}
  {# Add row access policies and masking policies #}

  {%- set sql_with_row_access_policies -%}
    {{ add_row_access_policy_to_view(
        fqn=fqn,
        initial_sql=initial_sql,
        target_columns=rap_columns
        ) }}
  {%- endset -%}

  {%- set sql_with_row_access_policies_and_masking -%}
    {{ add_column_masking_policy_to_view(
        fqn=fqn,
        initial_sql=sql_with_row_access_policies,
        target_columns=mp_columns
        ) }}
  {%- endset -%}

  {%- set sql_with_policies %}
  {{ sql_with_row_access_policies_and_masking }}
  {%- endset -%}


  {# ============================================ #}

  -- build model
  {%- call statement('main') -%}
    {{ sql_with_policies }}
  {%- endcall -%}

  {%- set should_revoke = should_revoke(exists_as_view, full_refresh_mode=True) -%}
  {%- do apply_grants(target_relation, grant_config, should_revoke=should_revoke) -%}

  {{ run_hooks(post_hooks) }}

  {{ return({'relations': [target_relation]}) }}

{% endmacro %}



{%- macro add_row_access_policy_to_view(fqn, initial_sql, target_columns) %}
  {# Start with the initial SQL for creating the view #}
  {%- set sql = initial_sql %}

  {# Add row access policies if any are defined #}
  {%- if target_columns and target_columns | length > 0 -%}
    {# Define where to inject the WITH ROW ACCESS POLICY clause #}
    {%- set insert_point = "view " ~ fqn -%}
    {# {{ log(insert_point, info=true) }} #}
    {%- set index = sql.find(insert_point) -%}
    {# {{ log(index, info=true) }} #}

    {# If the AS keyword is found, inject the policy clauses before it #}
    {%- if index != -1 -%}
      {# Move the index to the end of the found location #}
      {%- set index = index + insert_point | length -%}
      {# Append the policy clauses #}
      {%- set policy_clause = "WITH ROW ACCESS POLICY " ~ var('common_policy_db') ~ "." ~ var('common_policy_schema') ~ "." ~ target_columns[0][1] ~ " ON (" ~ target_columns[0][0] ~ ")" -%}
      {%- set sql = sql[:index] ~ " " ~ policy_clause ~ sql[index:] -%}
    {%- else %}
      {# Log an error or handle the case where the AS keyword isn't found #}
      {{ log("unable to add row access policies.", error=true) }}
    {%- endif -%}
  {%- endif -%}

  {{ sql }}
{%- endmacro -%}

{%- macro add_column_masking_policy_to_view(fqn, initial_sql, target_columns) %}
  {# Need to use a namespace because jinja resets vars from for loop to the outer scope. #}
  {%- set modified_sql = namespace(value=initial_sql) %}

  {# Add row access policies if any are defined #}
  {%- if target_columns and target_columns | length > 0 -%}

    {%- for col in target_columns -%}
      {# Define where to inject the WITH ROW ACCESS POLICY clause #}
      {%- set insert_point = '"' ~ col[0] ~ '"' | upper -%}
      {# {{ log(insert_point, info=true) }} #}
      {%- set index = modified_sql.value.find(insert_point | upper) -%}
      {# {{ log(index, info=true) }} #}

      {# If the column is found, inject the policy clause #}
      {%- if index != -1 -%}
        {# Move the index to the end of the found location #}
        {%- set index = index + insert_point | length -%}
        {# Append the policy clauses #}
        {%- set policy_clause = "WITH MASKING POLICY " ~ var('common_policy_db') ~ "." ~ var('common_policy_schema') ~ "." ~ col[1] -%}
        {%- set modified_sql.value = modified_sql.value[:index] ~ " " ~ policy_clause ~ modified_sql.value[index:] -%}
      {%- else %}
        {# Log an error or handle the case where the AS keyword isn't found #}
        {{ log("unable to add column masking policy " ~ col[1], error=true) }}
      {%- endif -%}
    {%- endfor -%}

  {%- endif -%}

  {{ modified_sql.value }}
{%- endmacro -%}
