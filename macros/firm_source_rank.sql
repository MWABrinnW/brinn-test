{% macro firm_source_rank(col='firm_source') -%}
    case {{ col }}
    when 'mwa' then 1
    when 'mps' then 2
    when 'swag' then 3
    when 'baystate' then 4
    when 'network' then 5
    when 'other' then 6
    when 'unknown' then 7
    else 8
    end
{%- endmacro %}
