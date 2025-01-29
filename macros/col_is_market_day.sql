{% macro col_is_market_day(date_col) -%}
case 
    when {{ date_col }}::date in (select date_key from {{ ref('dates') }} where is_market_day = 1) 
    then 1 else 0 
    end as is_market_day
{%- endmacro %}
