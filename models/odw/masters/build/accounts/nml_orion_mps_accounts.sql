select
    a.effective_date                                                          as effective_date
    , a.system_name                                                           as system_name
    , a.system_instance                                                       as system_instance
    , a.system_key                                                            as system_key
    , a.firm_source                                                           as firm_source
    -- PMS --------------------------------------------------------------------
    , a.account_number_formatted                                              as account_number_formatted
    , a.account_number                                                        as account_number
    , a.account_number                                                        as pms_account_number
    , a.custodian                                                             as pms_custodian
    , a.account_id                                                            as pms_account_id
    , a.account_type                                                          as pms_account_type
    , a.account_name                                                          as pms_account_name
    , a.registrant_name                                                       as pms_registrant_name
    , a.household_id                                                          as pms_client_id
    , a.household_name                                                        as pms_client_name
    , a.is_active                                                             as pms_is_active
    , a.created_date                                                          as pms_created_date
    , a.opened_date                                                           as pms_opened_date
    , a.closed_date                                                           as pms_closed_date
    , a.account_value                                                         as pms_account_value
    , pp.advisor_full_name                                                    as pms_advisor
    , pp.contact_id::text(200)                                                as pms_advisor_id
    , case when pp.advisor_full_name is not null
            then 'redtail__network'
    end::text                                                                 as pms_advisor_id_source
    , null::text(200)                                                         as pms_advisor_email
    , '609'::text                                                             as pms_location_code
    , a.fee_schedule                                                          as pms_fee_schedule--not available in RS yet
    , a.investment_strategy                                                   as pms_model_investment_strategy
    , coalesce(udf_aum.fieldvalue , udf_aum_def.defaultvalue)::text(200)      as pms_aum_classification--sourced from crm
    , a.is_erisa                                                              as pms_is_erisa--sourced from custodian
    , a.is_discretionary                                                      as pms_is_discretionary--sourced from custodian
    , a.is_voting_proxied                                                     as pms_is_voting_proxied--sourced from custodian
    , a.is_prime_broker                                                       as pms_is_prime_broker
    , a.is_broker_dealer_account                                              as pms_is_broker_dealer_account
    , a.cost_basis_method                                                     as pms_cost_basis_method
    -- CRM --------------------------------------------------------------------
    {{ select_crm_null() }}

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce('orion__mps') }}

    -- KEYS -------------------------------------------------------------------
    , concat(a.system_key , '__' , pms_account_name)                          as system_key__account_name
    , concat(a.system_key , '__' , pms_account_number)                        as system_key__account_number
    , concat(a.system_key , '__' , coalesce(pms_advisor , crm_advisor))       as system_key__advisor
    , concat(pms_advisor , '__' , pms_account_number)                         as advisor__account_number
    , account_number                                                          as __account_key
    -- HELPERS ----------------------------------------------------------------
    , {{ assign_custodian_key() }}
    , pref_adv_acct._system_key                                               as pref_advisor__account_number
    , coalesce(pref_adv._system_key , (
        case when pp.preferred_pms = 'Orion' then 'orion__mps'
            when pp.preferred_pms = 'Black Diamond' then 'black_diamond__mps'
            else 'orion__mps'
        end
    ))
        as pref_advisor
    , pref_loc._system_key                                                    as pref_location
    , coalesce(
        pref_advisor__account_number
        , pref_advisor
        , pref_location
        , a.system_key
    )                                                                         as pref_system_key
    , row_number()
        over (
            partition by
                a.effective_date
                , __account_key
                , __custodian_key
            order by
                a._source_loaded_at desc
                , pms_closed_date desc
                , crm_account_id asc
                , pms_account_value desc
                , pms_created_date asc
        )                                                                     as dedupe_system_rn

    , count(*)
        over (
            partition by
                a.effective_date , __account_key
                , __custodian_key
        )                                                                     as dedupe_system_count

    , case when dedupe_system_count
            > 1 then 1
        else 0
    end                                                                       as has_dupes
    , ''::text(2000)
    || coalesce(case
        when pms_client_name in ('History Client')
            then 'Historical client;'
    end , '')
    || coalesce(case
        when pms_client_name in ('History Household')
            then 'Historical household;'
    end , '')
    || coalesce(case
        when pms_advisor in ('Demo Rep' , 'New Accounts Rep' , 'MPS Demo Rep' , 'MPS Accounts')
            then 'demo/generic advisor;'
    end , '')
    || coalesce(case
        when 1 = 2--noqa:ST10
            then ';'
    end , '')
        as excluded_reasons
    , case
        when excluded_reasons = ''
            then 0
        else 1
    end                                                                       as is_excluded
    , object_construct_keep_null(
        'join_udf_aum' , iff(udf_aum.fkalclient is not null , 1 , 0)
        , 'join_udf_aum_def' , iff(udf_aum_def.fkalclient is not null , 1 , 0)
        , 'join_map_cus_glo' , iff(map_cus_glo.source_value is not null , 1 , 0)
        , 'join_ovrd_acct' , iff(ovrd_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_acct' , iff(ovrd_sys_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_adv' , iff(ovrd_sys_adv.scope_key is not null , 1 , 0)
        , 'join_pref_adv_acct' , iff(pref_adv_acct.scope_key is not null , 1 , 0)
        , 'join_pref_adv' , iff(pref_adv.scope_key is not null , 1 , 0)
        , 'join_pref_loc' , iff(pref_loc.scope_key is not null , 1 , 0)

    )::variant                                                                as _extra_fields
    -- META -------------------------------------------------------------------
    , a.is_head                                                               as is_head
    , a.is_current                                                            as is_current
    , a._source_loaded_at                                                     as _source_loaded_at
    , a._source_file                                                          as _source_file
from {{ ref('int_orion_accounts') }} as a
left join {{ ref('orion__base_vw_userdefinedfields_account') }} as udf_aum
    on a.fkalclient = udf_aum.fkalclient
    and a.account_id = udf_aum.fkaccount
    and a.effective_date = udf_aum.effective_date
    and udf_aum.code = '7AUMCLASSI'
left join {{ ref('orion__base_vw_userdefinedfields') }} as udf_aum_def
    on udf_aum.fkalclient = udf_aum_def.fkalclient
    and udf_aum.effective_date = udf_aum_def.effective_date
    and udf_aum.code = udf_aum_def.code

-- overrides to determine the preferred pms key from redtail for mps records
left join {{ ref('redtail_network__int_contact_preferred_pms') }} as pp
    on upper(pp.advisor) = upper(a.advisor)

-- mappings
left join {{ ref('aux__stg_masters_mappings') }} as map_aum_glo
    on map_aum_glo.field = 'aum_classification'
    {% if instance | lower == 'mps' -%} 
    and coalesce(pms_aum_classification , crm_aum_classification) = map_aum_glo.source_value
    {% else %}
        and coalesce(crm_aum_classification , pms_aum_classification) = map_aum_glo.source_value
    {%- endif %}
    and
    a.effective_date between coalesce(map_aum_glo.start_date , a.effective_date) and coalesce(
        map_aum_glo.end_date , a.effective_date
    )
left join {{ ref('aux__stg_masters_mappings') }} as map_cus_glo
    on map_cus_glo.field = 'custodian'
    and pms_custodian = map_cus_glo.source_value
    and
    a.effective_date between coalesce(map_cus_glo.start_date , a.effective_date) and coalesce(
        map_cus_glo.end_date , a.effective_date
    )
-- overrides
left join {{ ref('aux__stg_masters_overrides') }} as ovrd_acct
    on ovrd_acct.scope = 'account_number'
    and pms_account_number = ovrd_acct.scope_key
    and a.effective_date between coalesce(ovrd_acct.start_date , a.effective_date)
    and coalesce(ovrd_acct.end_date , a.effective_date)

left join {{ ref('aux__stg_masters_overrides') }} as ovrd_sys_acct
    on ovrd_sys_acct.scope = 'system_key__account_number'
    and system_key__account_number = ovrd_sys_acct.scope_key
    and a.effective_date between coalesce(ovrd_sys_acct.start_date , a.effective_date)
    and coalesce(ovrd_sys_acct.end_date , a.effective_date)

left join {{ ref('aux__stg_masters_overrides') }} as ovrd_sys_adv
    on ovrd_sys_adv.scope = 'system_key__advisor'
    and system_key__advisor = ovrd_sys_adv.scope_key
    and a.effective_date between coalesce(ovrd_sys_adv.start_date , a.effective_date)
    and coalesce(ovrd_sys_adv.end_date , a.effective_date)

-- preferred system key
left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_adv_acct
    on advisor__account_number = pref_adv_acct.scope_key
    and a.effective_date between coalesce(pref_adv_acct.start_date , a.effective_date)
    and coalesce(pref_adv_acct.end_date , a.effective_date)

left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_adv
    on coalesce(pms_advisor , crm_advisor) = pref_adv.scope_key
    and a.effective_date between coalesce(pref_adv.start_date , a.effective_date)
    and coalesce(pref_adv.end_date , a.effective_date)

left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_loc
    on location_code = pref_loc.scope_key
    and a.effective_date between coalesce(pref_loc.start_date , a.effective_date)
    and coalesce(pref_loc.end_date , a.effective_date)


where true
    and a.account_number is not null
    and a.system_key = 'orion__mps'
