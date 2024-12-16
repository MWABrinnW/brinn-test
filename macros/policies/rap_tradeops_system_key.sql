{% macro rap_tradeops_system_key() %}

{%- set sql -%}
    -- All systems
    (is_role_in_session('engineering')) or
    -- Options
    (system_key = 'copilot__mwa-options' and is_role_in_session('trading_options'))
;
{%- endset -%}

create row access policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_tradeops_system_key
as (system_key text) RETURNS boolean ->
    {{ sql }}

alter row access policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_tradeops_system_key
set body ->
    {{ sql }}

{% endmacro %}