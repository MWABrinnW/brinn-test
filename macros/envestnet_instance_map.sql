{%- macro envestnet_instance_map(instance) -%}
case
    when {{ "'" ~ instance ~ "'" }}  = 'manasquan' then 'mwa'
    else ''
end
{%- endmacro -%}
