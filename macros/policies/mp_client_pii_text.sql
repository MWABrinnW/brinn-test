{% macro mp_client_pii_text() %}
{# This masking policy is for general client PII #}
{%- set sql -%}
case
      when is_role_in_session('engineering')
        or is_role_in_session('datamanagement')
            then val
      when is_granted_to_invoker_role('mp_client_pii')
            then val
      else iff(val is not null, '**MASKED**', null)
end
;
{%- endset -%}

create masking policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.mp_client_pii_text as (val text)
  returns text ->
      {{ sql }}

alter masking policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.mp_client_pii_text set body ->
      {{ sql }}

{% endmacro %}