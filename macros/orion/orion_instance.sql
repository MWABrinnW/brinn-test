{% macro orion_instance(col='_client', include_alias=true, alias_name='system_instance') -%}
case {{ col }}
    when 568 then 'core'
    when 1945 then 'hayes'
    when 2102 then 'cascadia'
    when 2623 then 'arbor_wealth'
    when 3394 then 'mps'
    when 2878 then 'network'
    end {%- if not include_alias -%} {%- else %} as {{ alias_name }} {% endif -%}
{%- endmacro %}