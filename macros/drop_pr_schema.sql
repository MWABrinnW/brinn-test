{% macro drop_pr_schema() %}
    {% set sql = "drop schema if exists " ~ target.database ~ "." ~ target.schema %}
    {{ dbt_utils.log_info("Executing: " ~ sql) }}
    {% set results = run_query(sql) %}
    {{ dbt_utils.log_info("Execution complete: " ~ results.columns[0].values()) }}
{% endmacro %}
