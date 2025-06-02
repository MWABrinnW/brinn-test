{%- set history_relation = 'flyer__int_orders_allocations_history' %}
{%- set fresh_relation = 'flyer__int_orders_allocations_fresh' %}

{%- set column_names = dbt_utils.get_filtered_columns_in_relation(from=ref(fresh_relation)) %}

with fresh_data as (
    select a.*
    from {{ ref(fresh_relation) }} as a
)

select
{% for column_name in column_names %}
{{ column_name }},
{% endfor %}
from {{ ref(history_relation) }} as a
where 1 = 1
    and a.trading_session_date not in (select distinct trading_session_date from fresh_data)

union all

select
{% for column_name in column_names %}
{{ column_name }},
{% endfor %}
from fresh_data
