{% macro copilot_product_id_to_type(col='product::int') -%}
case {{ col }}
    when 0
        then 'CASH'
    when  1
        then 'EQ'
    when 2
        then 'MUT'
    when 3
        then 'UNKNOWN'
    when 4
        then 'FI'
    when 5
        then 'OPT'
    else null
    end::text(200) as product_type
{%- endmacro %}