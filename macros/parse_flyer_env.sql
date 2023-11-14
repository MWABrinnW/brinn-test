{% macro parse_flyer_env(col='_uri') -%}
case
    when {{ col }} ilike '%ec2-3-89-126-76%'
        then 'dev'
    when {{ col }} ilike '%ec2-44-201-187-118%'
        then 'uat'
    when {{ col }} ilike '%copilot-2.flyerapps.net%'
        then 'prod'
    else 'unknown'
    end::text(200) as _env
{%- endmacro %}