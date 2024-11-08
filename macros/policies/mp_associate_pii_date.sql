{% macro mp_associate_pii_date() %}
{# This masking policy is for general client PII #}
{%- set sql -%}
 case
      when is_role_in_session('engineering')
        or is_role_in_session('datamanagement')
            then val
      when is_role_in_session('DB_HR_ASSOC_R')
            then val
      when is_granted_to_invoker_role('mp_associate_pii')
            then val
      else null::date
end
;
{%- endset -%}

create masking policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.mp_associate_pii_date as (val date)
  returns date ->
      {{ sql }}

alter masking policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.mp_associate_pii_date set body ->
      {{ sql }}

{% endmacro %}