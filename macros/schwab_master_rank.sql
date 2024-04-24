{% macro schwab_master_rank(col='firm_source') -%}
    case {{ col }}
    when '08438162' -- orion
        then 1
    when '08109543' -- fixed income
        then 2
    when '08315101' -- non-orion
        then 3
    when '08355335' -- mps
        then 4
    when '08051423' -- swag
        then 5
    else 6
    end
{%- endmacro %}
