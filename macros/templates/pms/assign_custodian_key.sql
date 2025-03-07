
{%- macro assign_custodian_key() -%}
    case 
        when coalesce(crm_custodian, pms_custodian) ilike '%schwab%' then 'schwab'
        when coalesce(crm_custodian, pms_custodian) ilike '%fid%' then 'fidelity'
        when coalesce(crm_custodian, pms_custodian) ilike '%lpl%' then 'lpl'
        when coalesce(crm_custodian, pms_custodian) ilike '%pershing%' then 'pershing'
        when coalesce(crm_custodian, pms_custodian) ilike '%tda%' 
             or coalesce(crm_custodian, pms_custodian) ilike '%ameritrade%' then 'tda'
        else ''
    end::text(100) as __custodian_key
    {%- endmacro -%}