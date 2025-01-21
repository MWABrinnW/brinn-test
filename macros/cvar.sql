{% macro cvar(var_name) -%}

    {%-
        set all_project_vars = {
            'offset': var('offset', '0'),
            'lookback': var('lookback', 7),
            'dev_day_filter': var('dev_day_filter', 5),
            'lookback_custodial': var('lookback_custodial', 5),
            'lookback_orion': var('lookback_orion', 5)
        }
    -%}

    {{ return(all_project_vars[var_name]) }}

{%- endmacro %}