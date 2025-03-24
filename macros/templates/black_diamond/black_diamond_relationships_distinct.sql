{% macro black_diamond_relationships_distinct(instance, columns) %}
  select 
    effective_date,
    account_id,
    is_head,
    {% for column in columns %}
      listagg(distinct {{ column }}, '; ') as {{ column }}
      {% if not loop.last %}, {% endif %}
    {% endfor %}
  from {{ ref('black_diamond_' ~ instance ~ '__base_relationships') }}
  group by all
{% endmacro %}
