{% macro col_is_head_for_day(partition_col='effective_date', max_date_col='_created_at') %}

    case 
        when {{ max_date_col }} = max({{ max_date_col }}) 
        over (
            {% if partition_col is not none %}
                partition by {{ partition_col }}::date
            {% endif %}
        ) 
        then 1 
        else 0 
    end::int as is_head_for_day

{% endmacro %}
k