{% macro mp_client_pii_float() %}
{%- set obj_name = 'mp_client_pii_float' -%}
{# This masking policy is for general client PII #}
{%- set sql -%}
case
      when is_role_in_session('engineering')
        or is_role_in_session('datamanagement')
            then val
      when is_granted_to_invoker_role('mp_client_pii')
            then val
      else null
end
;
{%- endset -%}

create masking policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.{{ obj_name }} as (val float)
  returns float ->
      {{ sql }}

alter masking policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.{{ obj_name }} set body ->
      {{ sql }}

{% endmacro %}