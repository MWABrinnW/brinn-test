{% macro rap_firm_source() %}

{%- set sql -%}
    ((is_role_in_session('engineering')
        or is_role_in_session('datamanagement'))
    -- MWA/WLTH
    or (firm_source in ('mwa' , 'mir') and (
        is_role_in_session('wlth')
        -- Legacy inheritance. These should be cleaned up later.
        or is_role_in_session('mwa')
        or is_role_in_session('db_custodial_mwa_r')
        or is_role_in_session('db_edw_client_mwa_r')
        or is_role_in_session('db_pms_mwa_r')
    ))
    -- INDE (ntwk, bays, cmpg, swag/mps)
    or (firm_source in ('mps', 'swag', 'network', 'baystate', 'cpg',  'mir') and (
        is_role_in_session('mps')
        or is_role_in_session('ntwk')
        or is_role_in_session('swag')
        or is_role_in_session('bays')
        -- Legacy inheritance. These should be cleaned up later.
        or is_role_in_session('db_custodial_mps_r')
        or is_role_in_session('db_edw_client_mps_r')
        or is_role_in_session('db_pms_mps_r')

    ))
    -- MSEC
    or (firm_source = 'msec' and (
        is_role_in_session('msec')
    ))
    -- INST
    or (firm_source in ('andco', 'inst') and (
        is_role_in_session('inst')
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
