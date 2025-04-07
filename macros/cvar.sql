{% macro cvar(var_name) -%}

    {%-
        set all_project_vars = {
            'offset': var('offset', '0'),
            'lookback': var('lookback', 7),
            'dev_day_filter': var('dev_day_filter', 7),
            'lookback_default': var('lookback_days', 365 if target.name == prod else 14),
            'lookback_custodial': var('lookback_custodial', 7),
            'lookback_orion': var('lookback_orion', 5),
            'custodian_masters_start_date': var('custodian_masters_start_date', '2023-01-01'),
            'account_masters_start_date': var('account_masters_start_date', '2025-01-01')}
    -%}

    {{ return(all_project_vars[var_name]) }}

{%- endmacro %}