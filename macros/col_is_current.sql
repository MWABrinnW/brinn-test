{% macro col_is_current(date_col) -%}
case 
    when {{ date_col }}::date = (select prior_market_date from {{ ref('dates') }} where date_key = current_date()) 
    then 1 else 0 
    end as is_current
{%- endmacro %}