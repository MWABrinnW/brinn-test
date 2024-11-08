{% macro orion_firm_source(col='_client', include_alias=true, alias_name='firm_source') -%}
case {{ col }}
    when 568 then 'mwa'
    when 1945 then 'mwa'
    when 2102 then 'mwa'
    when 2623 then 'mwa'
    when 3394 then 'mps'
    when 2878 then 'network'
    end {%- if not include_alias -%} {%- else %} as {{ alias_name }} {% endif -%}
{%- endmacro %}