{% macro col_is_head(reference, reference_date_col='effective_date', source_date_col='effective_date') -%}
case 
    when {{source_date_col}} = (select max({{reference_date_col}}) from {{ reference }}) 
    then 1 else 0 
    end as is_head
{%- endmacro %}