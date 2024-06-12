{% macro can_sum(field) %}
    {{ return(field.dtype.lower() in ('integer', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal', 'number')) }}
{% endmacro %}

{% macro can_percentile(field) %}
    {{ return(field.dtype.lower() in ('integer', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal', 'number', 'timestamp', 'timestamptz')) }}
{% endmacro %}

{% macro get_filtered_columns_in_relation(relation, excluded_columns) %}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}
    {%- if excluded_columns is not none -%}
        {%- set columns = columns | rejectattr('name', 'in', excluded_columns) -%}
    {%- endif -%}
    {{ return(columns) }}
{% endmacro %}

{# date partition field is grouped by month, only allows for date type, must be month end #}
{% macro describe_model(model, where_clause=none, date_partition=none, excluded_columns=[]) %}
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

    {%- set fields = get_filtered_columns_in_relation(model, excluded_columns) -%}

  with stats as (
  {% for field in fields -%}
    select
      '{{ schema_name }}.{{ table_name }}' as relation
      , a.system_key as system_key
      ,'{{ field.column }}' as field
      ,'{{ field.dtype }}' as dtype
      
      , last_day(date_trunc('month',a.{{ date_partition }})) as month_end_date

      ,count(*) as count_all
           
      ,sum(case when {{ field.column }} is null then 1 else 0 end) as count_null
      
      ,count(distinct {{ field.column }}) as distinct_values

      , case when count_all = distinct_values then true
      else false end::boolean as is_distinct

      ,{% if can_sum(field) -%}
        sum({{ field.column }})::number(18,2)
      {%- else -%}
        null::number(18,2)
    {%- endif %} as sum
      
      ,{% if field.dtype != 'VARCHAR' -%}
          MIN({{ field.column }})::varchar(200) AS min
      {%- else -%}
        NULL::varchar(200) AS min
    {%- endif %}

      ,{% if field.dtype != 'VARCHAR' -%}
          max({{ field.column }})::varchar(200) AS max
      {%- else -%}
        NULL::varchar(200) AS max
    {%- endif %}
      
      ,{% if field.dtype == 'VARCHAR' -%}
        mode({{ field.column }}) as mode
    {%- else -%}
        NULL::VARCHAR(4) AS mode
    {%- endif %}

   
    ,{% if field.dtype == 'VARCHAR' %}
        listagg::varchar(500) as distinct_values_limited
    {% else %}
        null::varchar(500) as distinct_values_limited
    {% endif %}
    
      , {% if field.dtype == 'VARCHAR' -%}
        max(len({{ field.column }}))::int AS value_max_length
       {%- else -%}
        NULL::int AS value_max_length
    {%- endif %}

    from {{ model.database }}.{{ schema_name }}.{{ table_name }} as a
    {% if field.dtype == 'VARCHAR' %}
    LEFT JOIN (
    SELECT 
        sub_b.system_key,
        sub_b.month_end_date,
        LISTAGG({{ field.column }}, ' | ') WITHIN GROUP (ORDER BY {{ field.column }}) AS listagg
    FROM (
        SELECT
            sub_a.system_key,
            sub_a.{{ date_partition }} AS month_end_date,
            sub_a.{{ field.column }},
            ROW_NUMBER() OVER (PARTITION BY sub_a.system_key, sub_a.{{ date_partition }} ORDER BY sub_a.{{ field.column }}) AS num
        FROM {{ model.database }}.{{ schema_name }}.{{ table_name }} AS sub_a
        WHERE TRUE
            AND last_day(date_trunc('month', sub_a.{{ date_partition }})) >= LAST_DAY(DATEADD(MONTH, -12, CURRENT_DATE))
            AND last_day(date_trunc('month', sub_a.{{ date_partition }})) <= LAST_DAY(DATEADD(MONTH, 2, CURRENT_DATE))
        GROUP BY
            sub_a.system_key,
            sub_a.{{ date_partition }},
            sub_a.{{ field.column }}
        QUALIFY num <= 10
    ) AS sub_b
    GROUP BY
        sub_b.system_key,
        sub_b.month_end_date
    ORDER BY
        sub_b.system_key,
        sub_b.month_end_date
    
    ) AS sub_listagg
    ON a.system_key = sub_listagg.system_key
    AND last_day(date_trunc('month',a.{{ date_partition }})) = sub_listagg.month_end_date
    {% endif %}

    where true
     and last_day(date_trunc('month',a.{{ date_partition }})) >= LAST_DAY(DATEADD(MONTH, -13, CURRENT_DATE))
     and last_day(date_trunc('month',a.{{ date_partition }})) <= LAST_DAY(DATEADD(MONTH, 2, CURRENT_DATE))
    {%- if where_clause is not none %}
     and {{ where_clause }}
    {%- endif %}
    group by all
    {%- if not loop.last %}
    UNION ALL
    {% endif %}
{%- endfor %}
  )

  select s.*
  from stats s
  order by relation, system_key, field, month_end_date


{% endmacro %}
