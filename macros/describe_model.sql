{%- macro can_sum(field) -%}
  {{return(field.dtype.lower() in ('integer', 'int', 'number', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal'))}}
{%- endmacro -%}

{%- macro can_percentile(field) -%}
  {{return(field.dtype.lower() in ('integer', 'bigint', 'double precision', 'float', 'real', 'numeric', 'decimal', 'timestamp', 'timestamptz'))}}
{%- endmacro -%}

{%- macro get_filtered_columns_in_relation(relation, include_columns=None, exclude_columns=None) -%}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}

    {%- if include_columns is not none and include_columns | length > 0 -%}
        {# Normalize column names and filter case-insensitively for inclusion #}
        {%- set include_columns_clean = include_columns | map('upper') | list -%}
        {%- set columns = columns | selectattr('name', 'in', include_columns_clean) -%}
    {%- elif exclude_columns is not none and exclude_columns | length > 0 -%}
        {# Normalize column names and filter case-insensitively for exclusion #}
        {%- set exclude_columns_clean = exclude_columns | map('upper') | list -%}
        {%- set columns = columns | rejectattr('name', 'in', exclude_columns_clean) -%}
    {%- endif -%}

    {{ return(columns) }}
{%- endmacro -%}


{%- macro describe_model(model, where_clause=None, include_columns=None, exclude_columns=None) -%}
  {%- if not execute -%}
      {{ return('') }}
  {%- endif %}

  {%- set fields = get_filtered_columns_in_relation(model, include_columns=include_columns, exclude_columns=exclude_columns) -%}

  with stats as (
  {% for field in fields -%}
    select
      '{{ model | lower | replace('"', '') }}' as relation
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
      ,min({{field.column}})::varchar(100) as min
      ,max({{field.column}})::varchar(100) as max
    from {{ model }}
    {% if where_clause | length > 4 -%}
    where {{ where_clause }}
    {% endif %}

    {%- if not loop.last %}
    UNION ALL
    {% endif %}
  {%- endfor -%}
  )

  select s.*
  from stats s

{%- endmacro -%}

{%- macro describe_model_flat_unpivoted(model, where_clause=None, include_columns=None, exclude_columns=None) -%}
  {%- if not execute -%}
      {{ return('') }}
  {% endif %}

  {%- set fields = get_filtered_columns_in_relation(model, include_columns=include_columns, exclude_columns=exclude_columns) -%}
  {# Need to use a namespace because jinja resets vars from for loop to the outer scope. #}
  {%- set fields_to_unpivot = namespace(value=[]) %}

  with stats as (
    select
      count(*) as count_all

      {% for field in fields -%}
      ,sum(case when {{field.column}} is not null then 1 else 0 end)::text as {{field.column}}__count_not_null
      ,sum(case when {{field.column}} is null then 1 else 0 end)::text as {{field.column}}__count_null
      {% if not can_sum(field) -%}
      ,count(distinct {{field.column}})::text as {{field.column}}__count_distinct
      {% endif -%}
      {% if field.dtype not in ['OBJECT', 'ARRAY', 'VARIANT'] -%}
      ,min({{field.column}})::text as {{field.column}}__min
      ,max({{field.column}})::text as {{field.column}}__max
      {% endif -%}
      {% if can_sum(field) -%}
      ,sum({{field.column}})::text as {{field.column}}__sum_all
      ,avg({{field.column}})::text as {{field.column}}__mean
      {% endif -%}

      {%- do fields_to_unpivot.value.append(field.column ~ "__count_not_null") -%}
      {%- do fields_to_unpivot.value.append(field.column ~ "__count_null") -%}
      {% if not can_sum(field) -%}
      {%- do fields_to_unpivot.value.append(field.column ~ "__count_distinct") -%}
      {% endif -%}
      {% if field.dtype not in ['OBJECT', 'ARRAY', 'VARIANT'] -%}
      {%- do fields_to_unpivot.value.append(field.column ~ "__min") -%}
      {%- do fields_to_unpivot.value.append(field.column ~ "__max") -%}
      {% endif -%}
      {%- if can_sum(field) -%}
        {%- do fields_to_unpivot.value.append(field.column ~ "__sum_all") -%}
        {%- do fields_to_unpivot.value.append(field.column ~ "__mean") -%}
      {% endif -%}
    {% endfor -%}
    from {{ model }}
    {% if (where_clause or "") | length > 4 -%}
    where {{ where_clause }}
    {% endif -%}
    group by all
  )

  select stat, value
  from stats
    unpivot include nulls (value for stat in ({% for field in fields_to_unpivot.value %}{{ field }}{% if not loop.last %},{% endif %}{% endfor %}))

{%- endmacro -%}
