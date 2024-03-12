{% macro parse_copilot_env(col='_uri') -%}
case
    when {{ col }} ilike '%mariner.flyerapps.net%'
        then 'prod'
    when {{ col }} ilike '%copilot-2.flyerapps.net%'
        then 'prod-old'
    when {{ col }} ilike '%ec2-44-201-187-118%'
        then 'uat'
    when {{ col }} ilike '%ec2-3-89-126-76%'
        then 'dev'
    else 'unknown'
    end::text(200) as _env
{%- endmacro %}