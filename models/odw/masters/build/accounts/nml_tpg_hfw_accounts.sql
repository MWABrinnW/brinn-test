select
    a.effective_date                                                          as effective_date
    , a.system_name::text(200)                                                as system_name
    , a.system_instance::text(200)                                            as system_instance
    , a.system_key::text(200)                                                 as system_key
    , a.firm_source::text(200)                                                as firm_source
    , a.account_number_formatted::text(200)                                   as account_number_formatted
    , a.account_number::text(200)                                             as account_number
    , a.account_number::text(200)                                             as pms_account_number
    , null::text(200)                                                         as pms_custodian
    , a.internal_account_number::text(200)                                    as pms_account_id
    , a.type_of_account::text(200)                                            as pms_account_type
    , a.account_name::text(200)                                               as pms_account_name
    , a.registrant_name::text(200)                                            as pms_registrant_name
    , a.internal_household_number::text(200)                                  as pms_client_id
    , a.client_name::text(500)                                                as pms_client_name
    , null::int                                                               as pms_is_active
    , null::date                                                              as pms_created_date
    , null::date                                                              as pms_opened_date
    , null::date                                                              as pms_closed_date
    , a.account_value::decimal(18 , 2)                                        as pms_account_value
    , null::text(200)                                                         as pms_advisor
    , null::text(200)                                                         as pms_advisor_email
    , a.location_code::varchar(100)                                           as pms_location_code
    , null::text(200)                                                         as pms_fee_schedule
    , null::text(200)                                                         as pms_model_investment_strategy
    , null::varchar(200)                                                      as pms_aum_classification
    , null::int                                                               as pms_is_erisa
    , null::int                                                               as pms_is_discretionary
    , null::int                                                               as pms_is_voting_proxied
    , null::int                                                               as pms_is_prime_broker
    , null::int                                                               as pms_is_broker_dealer_account
    , null::text(200)                                                         as pms_cost_basis_method
    -- CRM --------------------------------------------------------------------
    {{ select_crm_salesforce_compass() }}

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce('tpg__hfw') }}

    -- KEYS -------------------------------------------------------------------
    , concat(
        a.system_key
        , '__' , pms_account_name
    )                                                                         as system_key__account_name
    , concat(
        a.system_key
        , '__' , pms_account_number
    )                                                                         as system_key__account_number
    , concat(
        a.system_key
        , '__' , '' , coalesce(pms_advisor , crm_advisor)
    )                                                                         as system_key__advisor

    , concat(pms_advisor , '__' , pms_account_number)                         as advisor__account_number
    , pms_account_number                                                      as __account_key
    -- HELPERS ----------------------------------------------------------------
    , {{ assign_custodian_key() }}
    , pref_adv_acct._system_key                                               as pref_advisor__account_number
    , pref_adv._system_key                                                    as pref_advisor
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
                a._created_at desc
                , pms_closed_date desc
                , crm_account_id asc
                , pms_account_value desc
                , pms_created_date asc
        )                                                                     as dedupe_system_rn

    , count(*)
        over (
            partition by
                a.effective_date
                , __account_key
                , __custodian_key
        )                                                                     as dedupe_system_count

    , case when dedupe_system_count
            > 1 then 1
        else 0
    end                                                                       as has_dupes
    , ''::text(2000)
    || coalesce(case
        when 1 = 2--noqa:ST10
            then ';'
    end , '')
        as excluded_reasons
    , case
        when coalesce(ovrd_acct._is_excluded , ovrd_sys_acct._is_excluded , ovrd_sys_adv._is_excluded) is not null
            then coalesce(ovrd_acct._is_excluded , ovrd_sys_acct._is_excluded , ovrd_sys_adv._is_excluded)
        when excluded_reasons = ''
            then 0
        else 1
    end                                                                       as is_excluded
    , object_construct_keep_null(
        'join_sf1_eff_date' , iff(sf1.system_key is not null , 1 , 0)
        , 'join_sf2_is_head' , iff(sf2.system_key is not null , 1 , 0)
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
    , a._created_at::datetime                                                 as _source_loaded_at
    , null::text(200)                                                         as _source_file
from {{ ref('tpg_hfw__int_accounts') }} as a
-- [crm] join to the salesforce crm "effective_date" and then on "is_head" if the first join does not return a result.
left join {{ ref('salesforce_compass_accounts') }} as sf1
    on pms_account_number = sf1.account_number
    -- system does not provide the custodian
    {# and __custodian_key = sf1.custodian_key #}
    and a.effective_date = sf1.effective_at::date
left join {{ ref('salesforce_compass_accounts') }} as sf2
    on pms_account_number = sf2.account_number
    -- system does not provide the custodian
    and sf2.is_head = 1
-- mappings
left join {{ ref('aux__stg_masters_mappings') }} as map_aum_glo
    on map_aum_glo.field = 'aum_classification'
    and coalesce(crm_aum_classification , pms_aum_classification) = map_aum_glo.source_value
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
