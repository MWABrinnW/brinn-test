select
    a.effective_at::date                                                      as effective_date
    , 'salesforce'                                                            as system_name
    , 'compass_rps'                                                           as system_instance
    , concat('salesforce' , '__' , 'compass_rps')                             as system_key
    , 'mwa'                                                                   as firm_source
    , coalesce(ovrd_acct._account_number_formatted , a.id)                    as account_number_formatted
    , coalesce(ovrd_acct._account_number , a.id)                              as account_number
    , coalesce(ovrd_acct._account_number , a.id)                              as pms_account_number
    , c.name::text(200)                                                       as pms_custodian
    , a.id::text(200)                                                         as pms_account_id
    , a.plan_type_c::text(200)                                                as pms_account_type
    , a.name::text(500)                                                       as pms_account_name
    , null::text(500)                                                         as pms_registrant_name
    , a.account_c                                                             as pms_client_id
    , ba.name::text(200)                                                      as pms_client_name
    , iff(a.sfdc_project_status_c = 'Active Client/Plan' , 1 , 0)::int        as pms_is_active
    , a.created_date::date                                                    as pms_created_date
    , a.date_iaa_submitted_c::date                                            as pms_opened_date
    , a.close_date_c::date                                                    as pms_closed_date
    , a.plan_assets_c::decimal(16 , 2)                                        as pms_account_value
    , u.name::text(200)                                                       as pms_advisor
    , u.email::text(200)                                                      as pms_advisor_email
    , '301'::text(200)                                                        as pms_location_code
    , a.advisory_fee_schedule_c::text(200)                                    as pms_fee_schedule
    , null::text(200)                                                         as pms_model_investment_strategy
    , a.aum_classification_c::text(200)                                       as pms_aum_classification
    , case
        when left(lower(a.fiduciary_relationship_c) , 5) = 'erisa'
            then 1
        else 0
    end::int                                                                  as pms_is_erisa
    , case
        when a.fiduciary_relationship_c ilike '%3(38)%'
            then 1
        when a.fiduciary_relationship_c ilike '%3(21)%'
            then 0
    end::int                                                                  as pms_is_discretionary
    , null::int                                                               as pms_is_voting_proxied
    , null::int                                                               as pms_is_prime_broker
    , null::int                                                               as pms_is_broker_dealer_account
    , null::int                                                               as pms_cost_basis_method

    -- CRM --------------------------------------------------------------------
    {{ select_crm_null('salesforce__compass_rps') }}

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce('salesforce__compass_rps') }}

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
                a.effective_at::date
                , pms_account_number
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
                a.effective_at::date
                , __custodian_key
                , pms_account_number
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

        'join_map_cus_glo' , iff(map_cus_glo.source_value is not null , 1 , 0)
        , 'join_ovrd_acct' , iff(ovrd_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_acct' , iff(ovrd_sys_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_adv' , iff(ovrd_sys_adv.scope_key is not null , 1 , 0)
        , 'join_pref_adv_acct' , iff(pref_adv_acct.scope_key is not null , 1 , 0)
        , 'join_pref_adv' , iff(pref_adv.scope_key is not null , 1 , 0)
        , 'join_pref_loc' , iff(pref_loc.scope_key is not null , 1 , 0)

    )::variant                                                                as _extra_fields
    -- META -------------------------------------------------------------------
    , a.is_head                                                               as is_head
    , 1                                                                       as is_current
    , a._created_at::timestamp_ntz                                            as _source_loaded_at
    , null::text(200)                                                         as _source_file
from {{ ref('salesforce_compass__base_plan_c') }} as a
left join {{ ref('aux__stg_rules_account_value_dates') }} as vo
    on a.effective_at::date = vo.effective_date
    and a.system_key = vo._system_key
    and vo.is_head = 1
left join {{ ref('salesforce_compass__base_plan_c') }} as nv
    on vo.value_date = nv.effective_at::date
    and a.id = nv.id
    and nv.is_latest = 1
left join {{ ref('salesforce_compass__base_user') }} as u
    on a.owner_id = u.id
    and u.is_head = 1
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on a.effective_at::date = fs.effective_at::date
    and a.fee_schedule_c = fs.id
    and fs.is_latest = 1
left join {{ ref('salesforce_compass__base_custodian_c') }} as c
    on a.effective_at::date = c.effective_at::date
    and a.custodian_c = c.id
    and c.is_latest = 1
left join {{ ref('salesforce_compass__base_account') }} as ba
    on a.effective_at::date = ba.effective_at::date
    and a.account_c = ba.id
    and ba.is_latest = 1
-- mappings
left join {{ ref('aux__stg_masters_mappings') }} as map_aum_glo
    on map_aum_glo.field = 'aum_classification'
    and coalesce(crm_aum_classification , pms_aum_classification) = map_aum_glo.source_value
    and
    a.effective_at::date between coalesce(map_aum_glo.start_date , a.effective_at::date) and coalesce(
        map_aum_glo.end_date , a.effective_at::date
    )
left join {{ ref('aux__stg_masters_mappings') }} as map_cus_glo
    on map_cus_glo.field = 'custodian'
    and pms_custodian = map_cus_glo.source_value
    and
    a.effective_at::date between coalesce(map_cus_glo.start_date , a.effective_at::date) and coalesce(
        map_cus_glo.end_date , a.effective_at::date
    )
-- overrides
left join {{ ref('aux__stg_masters_overrides') }} as ovrd_acct
    on ovrd_acct.scope = 'account_number'
    and pms_account_number = ovrd_acct.scope_key
    and a.effective_at::date between coalesce(ovrd_acct.start_date , a.effective_at::date)
    and coalesce(ovrd_acct.end_date , a.effective_at::date)

left join {{ ref('aux__stg_masters_overrides') }} as ovrd_sys_acct
    on ovrd_sys_acct.scope = 'system_key__account_number'
    and system_key__account_number = ovrd_sys_acct.scope_key
    and a.effective_at::date between coalesce(ovrd_sys_acct.start_date , a.effective_at::date)
    and coalesce(ovrd_sys_acct.end_date , a.effective_at::date)

left join {{ ref('aux__stg_masters_overrides') }} as ovrd_sys_adv
    on ovrd_sys_adv.scope = 'system_key__advisor'
    and system_key__advisor = ovrd_sys_adv.scope_key
    and a.effective_at::date between coalesce(ovrd_sys_adv.start_date , a.effective_at::date)
    and coalesce(ovrd_sys_adv.end_date , a.effective_at::date)

-- preferred system key
left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_adv_acct
    on advisor__account_number = pref_adv_acct.scope_key
    and a.effective_at::date between coalesce(pref_adv_acct.start_date , a.effective_at::date)
    and coalesce(pref_adv_acct.end_date , a.effective_at::date)

left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_adv
    on coalesce(pms_advisor , crm_advisor) = pref_adv.scope_key
    and a.effective_at::date between coalesce(pref_adv.start_date , a.effective_at::date)
    and coalesce(pref_adv.end_date , a.effective_at::date)

left join {{ ref('aux__stg_masters_preferred_system_key') }} as pref_loc
    on location_code = pref_loc.scope_key
    and a.effective_at::date between coalesce(pref_loc.start_date , a.effective_at::date)
    and coalesce(pref_loc.end_date , a.effective_at::date)

where true
    and a.effective_at::date <= '2025-04-29'
    and coalesce(a.is_deleted , 0) = 0
    and a.is_latest = 1
