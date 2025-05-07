select
    a.effective_date                                                           as effective_date
    , a.system_name                                                            as system_name
    , a.system_instance                                                        as system_instance
    , a.system_key                                                             as system_key
    , a.firm_source                                                            as firm_source
    , a.account_number_formatted::varchar(200)                                 as account_number_formatted
    , a.account_number::varchar(200)                                           as account_number
    , a.account_number::varchar(200)                                           as pms_account_number
    , a.cwm_custodian                                                          as pms_custodian
    , a.holding_account_entity_id                                              as pms_account_id
    , a.cwm_account_type                                                       as pms_account_type
    , a.holding_account                                                        as pms_account_name
    , a.top_level_owner                                                        as pms_registrant_name
    , a.top_level_owner_entity_id                                              as pms_client_id
    , a.top_level_owner                                                        as pms_client_name
    , case when a.cwm_closed_date is null then 1 else 0 end::int               as pms_is_active
    , null::date                                                               as pms_created_date
    , a.inception_date::date                                                   as pms_opened_date
    , a.cwm_closed_date::date                                                  as pms_closed_date
    , a.value::decimal(18 , 2)                                                 as pms_account_value
    , case
        when upper(trim(a.cwm_lead_advisor)) = 'BG'
            then 'Brad Griswold'
        when upper(trim(a.cwm_lead_advisor)) = 'DG'
            then 'David Givler II'
        when upper(trim(a.cwm_lead_advisor)) = 'WV'
            then 'William Velekei'
        when upper(trim(a.cwm_lead_advisor)) = 'HA'
            then 'House Account'
    end                                                                        as pms_advisor
    , null::text                                                               as pms_advisor_id
    , null::text                                                               as pms_advisor_id_source
    , null::text(200)                                                          as pms_advisor_email
    , 'L-10001'::varchar(200)                                                  as pms_location_code
    , a.fee_schedule_legacy                                                    as pms_fee_schedule
    , a.cwm_strategy                                                           as pms_model_investment_strategy
    , case
        when a.account_number in
            (
                'DLRU158' , 'MRDRW830' , 'MLRF164' , 'MRP181' , 'MRBP602' , 'X65898133' , '652582799'
                , 'Z19318191'
                , '85281160' , '85281159' , '1050002' , '221549912' , '74572' , '26047' , '217519565'
                , '0000P55037'
                , '0000P32547'
            )
            then 'Data Aggregation / Reporting Only'
        when lower(a.cwm_line_of_business) = 'view only'
            then 'Data Aggregation / Reporting Only'
        when lower(a.cwm_strategy) in ('courtesy account' , 'custom - employee')
            then 'Data Aggregation / Reporting Only'
        else 'AUM - Assets Under Management'
    end                                                                        as pms_aum_classification
    , try_to_boolean(a.cwm_erisa_account)::int                                 as pms_is_erisa
    , try_to_boolean(a.cwm_non_discretionary)::int                             as pms_is_discretionary
    , null::int                                                                as pms_is_voting_proxied
    , null::int                                                                as pms_is_prime_broker
    , null::int                                                                as pms_is_broker_dealer_account
    , null::text(200)                                                          as pms_cost_basis_method

    -- CRM -- use practifi pre 2024-10-01, use salesforce post 2024-10-01, ----
    , coalesce(sf1.system_name , sf2.system_name , pf.system_name)             as crm
    , coalesce(sf1.system_instance , sf2.system_instance , pf.system_instance) as crm_instance_location
    , coalesce(sf1.system_key , sf2.system_key , pf.system_key)                as crm_key
    , sf1.custodian                                                            as crm_custodian
    , coalesce(sf1.estate_item_id , sf2.estate_item_id , pf.id)                as crm_account_id
    , coalesce(sf1.account_type , sf1.account_type)                            as crm_account_type
    , coalesce(sf1.account_name , sf1.account_name)                            as crm_account_name
    , coalesce(sf1.registrant_name , sf1.registrant_name)                      as crm_registrant_name
    , coalesce(sf1.household_id , sf2.household_id , pa.id)                    as crm_client_id
    , coalesce(sf1.household_name , sf2.household_id , pa.name)                as crm_client_name
    , coalesce(sf1.is_active , sf2.is_active)                                  as crm_is_active
    , coalesce(sf1.created_at::date , sf2.created_at::date)                    as crm_created_date
    , coalesce(sf1.opened_date , sf2.opened_date)                              as crm_opened_date
    , coalesce(sf1.closed_date , sf2.closed_date)                              as crm_closed_date
    , coalesce(sf1.account_value , sf2.account_value)                          as crm_account_value
    , coalesce(sf1.client_manager , sf2.client_manager)                        as crm_advisor
    , coalesce(sf1.employee_number , sf2.employee_number)                      as crm_advisor_id
    , coalesce(sf1.employee_number_source , sf2.employee_number_source)        as crm_advisor_id_source
    , coalesce(sf1.client_manager_email , sf2.client_manager_email)            as crm_advisor_email
    , coalesce(sf1.household_location_code , sf2.household_location_code)      as crm_location_code
    , coalesce(sf1.fee_schedule , sf2.fee_schedule)                            as crm_fee_schedule
    , coalesce(sf1.investment_strategy , sf2.investment_strategy)              as crm_model_investment_strategy
    , coalesce(sf1.aum_classification , sf2.aum_classification)                as crm_aum_classification
    , coalesce(sf1.is_erisa , sf2.is_erisa)                                    as crm_is_erisa
    , coalesce(sf1.is_discretionary , sf2.is_discretionary)                    as crm_is_discretionary
    , coalesce(sf1.is_voting_proxied , sf2.is_voting_proxied)                  as crm_is_voting_proxied
    , coalesce(sf1.is_prime_broker , sf2.is_prime_broker)                      as crm_is_prime_broker
    , coalesce(sf1.is_broker_dealer_account , sf2.is_broker_dealer_account)    as crm_is_broker_dealer_account

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce('addepar__corbenic') }}

    -- KEYS -------------------------------------------------------------------
    , concat(
        a.system_key
        , '__' , pms_account_name
    )                                                                          as system_key__account_name
    , concat(
        a.system_key
        , '__' , pms_account_number
    )                                                                          as system_key__account_number
    , concat(
        a.system_key
        , '__' , '' , coalesce(pms_advisor , crm_advisor)
    )                                                                          as system_key__advisor

    , concat(pms_advisor , '__' , pms_account_number)                          as advisor__account_number
    , pms_account_number                                                       as __account_key

    -- HELPERS ----------------------------------------------------------------
    , {{ assign_custodian_key() }}
    , pref_adv_acct._system_key                                                as pref_advisor__account_number
    , pref_adv._system_key                                                     as pref_advisor
    , pref_loc._system_key                                                     as pref_location
    , coalesce(
        pref_advisor__account_number
        , pref_advisor
        , pref_location
        , a.system_key
    )                                                                          as pref_system_key
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
        )                                                                      as dedupe_system_rn

    , count(*)
        over (
            partition by
                a.effective_date , __account_key
                , __custodian_key
        )                                                                      as dedupe_system_count

    , case when dedupe_system_count
            > 1 then 1
        else 0
    end                                                                        as has_dupes
    , ''::text(2000)
    || coalesce(case
        when coalesce(
                ovrd_acct._excluded_reasons
                , ovrd_sys_acct._excluded_reasons
                , ovrd_sys_adv._excluded_reasons
            ) is not null
            then coalesce(
                    ovrd_acct._excluded_reasons
                    , ovrd_sys_acct._excluded_reasons
                    , ovrd_sys_adv._excluded_reasons
                ) || ';'
    end , '')
        as excluded_reasons
    , case
        when coalesce(ovrd_acct._is_excluded , ovrd_sys_acct._is_excluded , ovrd_sys_adv._is_excluded) is not null
            then coalesce(ovrd_acct._is_excluded , ovrd_sys_acct._is_excluded , ovrd_sys_adv._is_excluded)
        when excluded_reasons = ''
            then 0
        else 1
    end                                                                        as is_excluded
    , object_construct_keep_null(
        'join_sf1_eff_date' , iff(sf1.system_key is not null , 1 , 0)
        , 'join_sf2_is_head' , iff(sf2.system_key is not null , 1 , 0)
        , 'join_pf_eff_date' , iff(pf.system_key is not null , 1 , 0)
        , 'join_map_cus_glo' , iff(map_cus_glo.source_value is not null , 1 , 0)
        , 'join_ovrd_acct' , iff(ovrd_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_acct' , iff(ovrd_sys_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_adv' , iff(ovrd_sys_adv.scope_key is not null , 1 , 0)
        , 'join_pref_adv_acct' , iff(pref_adv_acct.scope_key is not null , 1 , 0)
        , 'join_pref_adv' , iff(pref_adv.scope_key is not null , 1 , 0)
        , 'join_pref_loc' , iff(pref_loc.scope_key is not null , 1 , 0)

    )::variant                                                                 as _extra_fields

    -- META -------------------------------------------------------------------
    , a.is_head                                                                as is_head
    , a.is_current                                                             as is_current
    , a._created_at::timestamp_ntz                                             as _source_loaded_at
    , a.source_file                                                            as _source_file

from {{ ref('addepar_corbenic_history__base_accounts') }} as a

-- [crm] join to the salesforce crm "effective_date" and then on "is_head" if the first join does not return a result.
left join {{ ref('salesforce_compass_accounts') }} as sf1
    on pms_account_number = sf1.account_number
    and __custodian_key = case
        when sf1.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf1.custodian_key
        else ''
    end
    and a.effective_date = sf1.effective_at::date
    and sf1.effective_at::date >= '2024-10-01'-- use salesforce crm after this date
left join {{ ref('salesforce_compass_accounts') }} as sf2
    on pms_account_number = sf2.account_number
    and __custodian_key = case
        when sf2.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf2.custodian_key
        else ''
    end
    and sf2.is_head = 1
    and sf2.effective_at::date >= '2024-10-01'-- use salesforce crm after this date
-- [crm] join to the practifi crm "effective_date" 
left join {{ ref('salesforce_corbenic__base_practifi_asset_liability_c') }} as pf
    on a.account_number = pf.practifi_account_number_c
    and a.effective_date = pf.effective_at::date
    and pf.is_latest = 1
    and pf.practifi_account_number_c is not null
    and pf.effective_at::date < '2024-10-01'-- use practifi crm before this date
left join {{ ref('salesforce_corbenic__base_account') }} as pa
    on pf.practifi_client_c = pa.id
    and pf.effective_at::date = pa.effective_at::date

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
