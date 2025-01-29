{%- macro assign_custodian_key() -%}
     case
        when coalesce(pms_custodian , crm_custodian) ilike '%schwab%'
            then 'schwab'
        when coalesce(pms_custodian , crm_custodian) ilike '%fid%'
            then 'fidelity'
        when coalesce(pms_custodian , crm_custodian) ilike '%lpl%'
            then 'lpl'
        when coalesce(pms_custodian , crm_custodian) ilike '%pershing%'
            then 'pershing'
        when coalesce(pms_custodian , crm_custodian) ilike '%tda%'
            or coalesce(pms_custodian , crm_custodian) ilike '%ameritrade%'
            then 'tda'
        else ''
    end::text(100)                                                      as __custodian_key
{%- endmacro -%}