{% macro rap_firm_source() %}

{%- set sql -%}
    ((is_role_in_session('engineering')
        or is_role_in_session('datamanagement'))
    -- MWA
    or (firm_source = 'mwa' and (
        is_role_in_session('mwa')
        or is_role_in_session('db_custodial_mwa_r')
        or is_role_in_session('db_edw_client_mwa_r')
        or is_role_in_session('db_pms_mwa_r')
    ))
    -- MPS
    or (firm_source = 'mps' and (
        is_role_in_session('mps')
        or is_role_in_session('db_custodial_mps_r')
        or is_role_in_session('db_edw_client_mps_r')
        or is_role_in_session('db_pms_mps_r')
    ))
    -- NETWORK/SWAG
    or (firm_source in ('swag','network','baystate') and (
        is_role_in_session('mps')
        or is_role_in_session('network')
        or is_role_in_session('baystate')
        or is_role_in_session('db_custodial_mps_r')
        or is_role_in_session('db_edw_client_mps_r')
        or is_role_in_session('db_pms_mps_r')
    ))
    )
;
{%- endset -%}

create row access policy if not exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_firm_source
as (firm_source text) RETURNS boolean ->
    {{ sql }}

alter row access policy if exists {{ var('common_policy_db') }}.{{ var('common_policy_schema') }}.rap_firm_source
set body ->
    {{ sql }}

{% endmacro %}