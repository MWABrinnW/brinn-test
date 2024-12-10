{% macro col_is_head_with_partition(reference, partition_col=None, reference_date_col='effective_date', source_date_col='effective_date') -%}
case
    when {{source_date_col}} = max({{reference_date_col}}) over (
        {% if partition_col is not none %}
        partition by {{partition_col}}
        {% endif %}
        order by {{reference_date_col}} desc
    ) 
    then 1 else 0 
    end as is_head
{%- endmacro %}
