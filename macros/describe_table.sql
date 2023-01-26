{% macro can_sum(field) %}
  {{return(field.dtype.lower() in ('integer', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal'))}}
{% endmacro %}

{% macro can_percentile(field) %}
  {{return(field.dtype.lower() in ('integer', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal', 'timestamp', 'timestamptz'))}}
{% endmacro %}

{% macro describe_model(model, where_clause=none) %}
  {# Calculates descriptive statistics for each field in model. Model should be a
      ref() to a dbt model (views work fine) #}
  {%- set where_clause_text = 'where ' ~ where_clause %}
  {{ log("Running some_macro: " ~ model ~ ", " ~ where_clause) }}
  {%- if not execute -%}
      {{ return('') }}
  {% endif %}

  {%- if model.name -%}
      {%- set schema_name, table_name = model.schema, model.name -%}
  {%- else -%}
    {%- set part_count = (model | string).split(".") | count -%}
    {%- if part_count == 3 -%}
      {%- set database_name, schema_name, table_name = (model | string).split(".") -%}
      {%- set database_name = database_name ~ "." -%}
    {%- else -%}
      {%- set schema_name, table_name = (model | string).split(".") -%}
      {%- set database_name = '' -%}
    {%- endif -%}
  {%- endif -%}

  {%- set fields = adapter.get_columns_in_relation(model) -%}

  with stats as (
  {% for field in fields -%}
    select
      '{{schema_name}}.{{table_name}}' as relation
      ,'{{field.column}}' as field
      ,'{{field.dtype}}' as dtype
      ,count(*) as count_all
      ,sum(case when {{field.column}} is not null then 1 else 0 end) as count_not_null
      ,sum(case when {{field.column}} is null then 1 else 0 end) as count_null
      ,count(distinct {{field.column}}) as count_distinct
      ,{% if can_sum(field) -%}
        sum({{field.column}})::float
      {%- else -%}
      null::float
      {%- endif %} as sum_all
      ,{% if can_sum(field) -%}
        avg({{field.column}})::float
      {%- else -%}
      null::float
      {%- endif %} as mean
      ,{% if can_sum(field) -%}
        stddev({{field.column}})::float
      {%- else -%}
      null::float
      {%- endif %} as stddev
      ,min({{field.column}})::varchar(100) as min
      ,{% if can_percentile(field) -%}
        PERCENTILE_CONT ( 0.25 )
        WITHIN GROUP (ORDER BY {{field.column}})::varchar(100)
      {%- else -%}
      null::varchar(100)
      {%- endif %} as percentile_25
      ,{% if can_percentile(field) -%}
        PERCENTILE_CONT ( 0.5 )
        WITHIN GROUP (ORDER BY {{field.column}})::varchar(100)
      {%- else -%}
      null::varchar(100)
      {%- endif %} as median
      ,{% if can_percentile(field) -%}
        PERCENTILE_CONT ( 0.75 )
        WITHIN GROUP (ORDER BY {{field.column}})::varchar(100)
      {%- else -%}
      null::varchar(100)
      {%- endif %} as percentile_75
      ,max({{field.column}})::varchar(100) as max
    from {{model.database}}.{{schema_name}}.{{table_name}}
    {% if where_clause is not none -%}
    where true
      and {{ where_clause }}
    {% endif %}

    {%- if not loop.last %}
    UNION ALL
    {% endif %}
  {%- endfor -%}
  )
  {# REDSHIFT DOESN'T ALLOW COUNT DISTINCT AND PERCENTILE_CONT IN THE SAME QUERY
  ,distinct_counts as (
    {% for field in fields %}
      select
        '{{field.column}}' as field,
        count(distinct {{field.column}}) as count_distinct
      from {{model.database}}.{{schema_name}}.{{table_name}}
      {% if where_clause is not none -%}
      where true
        and {{ where_clause }}
      {%- endif -%}

      {%- if not loop.last %}
      UNION ALL
      {%- endif -%}

    {%- endfor -%}
  )
  #}
  select s.* {# ,dc.count_distinct #}
  from stats s
  {#
  join distinct_counts dc
    on s.field = dc.field
  #}
{% endmacro %}