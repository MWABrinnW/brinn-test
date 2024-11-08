{% macro rap_tradeops_venue() %}

{%- set sql -%}
    -- All venues
    (is_role_in_session('engineering')) or
    -- Options
    (venue = 'mwa-options' and is_role_in_session('trading_options'))
;
{%- endset -%}

create row access policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_tradeops_venue
as (venue text) RETURNS boolean ->
    {{ sql }}

alter row access policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_tradeops_venue
set body ->
    {{ sql }}

{% endmacro %}