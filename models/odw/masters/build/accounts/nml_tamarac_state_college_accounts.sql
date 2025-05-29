{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set src_models = [
          'tamarac_state_college_history__base_accounts'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, system_key, max(_created_at) as _created_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
    order by 1
    {% else -%}
    select null::date as effective_date, null::text as system_key
        , null::timestamp as _created_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
    select
        effective_date              as effective_date
        , system_key                as system_key
        , max(_created_at)          as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, system_key from source_summary group by all
    union
    select effective_date, system_key from destination_summary group by all
)


, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.system_key = s.system_key
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.system_key = d.system_key
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

, base_accounts as (
    select
        effective_date
        , system_name
        , system_instance
        , system_key
        , firm_source
        , account_number_formatted
        , account_number
        , custodian
        , upload_account_id
        , account_type
        , account_name
        , first_name
        , last_name
        , primary_household_id
        , closed_date
        , performance_inception_date
        , total_account_value_preveod
        , advisor
        , billing_definitions
        , target_allocation
        , aum_indicator
        , discretionary
        , _created_at
        , entity_type
    from {{ ref('tamarac_state_college_history__base_accounts') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct t.effective_date from dates_to_refresh as t)
)

, base_households as (
    select
        effective_date, upload_household_id, household_name
    from {{ ref('tamarac_state_college_history__base_households') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct t.effective_date from dates_to_refresh as t)
)

select
    a.effective_date                                                          as effective_date
    , a.system_name::text(500)                                                as system_name
    , a.system_instance::text(500)                                            as system_instance
    , a.system_key::text(500)                                                 as system_key
    , a.firm_source::text(500)                                                as firm_source
    , a.account_number_formatted::varchar(500)                                as account_number_formatted
    , a.account_number::varchar(500)                                          as account_number
    , a.account_number::varchar(500)                                          as pms_account_number
    , a.custodian::text(500)                                                  as pms_custodian
    , a.upload_account_id::text(500)                                          as pms_account_id
    , a.account_type::text(500)                                               as pms_account_type
    , a.account_name::text(500)                                               as pms_account_name
    , array_to_string(
        array_construct_compact(a.first_name , a.last_name) , ' '
    )                                                                         as pms_registrant_name
    , a.primary_household_id::text(500)                                       as pms_client_id
    , h.household_name::text(500)                                             as pms_client_name
    , case
        when a.closed_date::date is null
            then 1
        else 0
    end::int                                                                  as pms_is_active
    , null::date                                                              as pms_created_date
    , a.performance_inception_date::date                                      as pms_opened_date
    , a.closed_date::date                                                     as pms_closed_date
    , a.total_account_value_preveod::decimal(16 , 2)                          as pms_account_value
    , a.advisor::text(500)                                                    as pms_advisor
    , null::text                                                              as pms_advisor_id
    , null::text                                                              as pms_advisor_id_source
    , null::text(500)                                                         as pms_advisor_email
    , '112'::varchar(100)                                                     as pms_location_code
    , a.billing_definitions::text(500)                                        as pms_fee_schedule
    , a.target_allocation::text(500)                                          as pms_model_investment_strategy
    , case
        when a.aum_indicator::int = 1 then 'AUM - Assets Under Management'
        when a.aum_indicator::int = 0 then 'Data Aggregation / Reporting Only'
    end::text(500)                                                            as pms_aum_classification
    , null::int                                                               as pms_is_erisa
    , try_to_boolean(a.discretionary)::int                                    as pms_is_discretionary
    , null::int                                                               as pms_is_voting_proxied
    , null::int                                                               as pms_is_prime_broker
    , null::int                                                               as pms_is_broker_dealer_account
    , null::text(500)                                                         as pms_cost_basis_method

    -- CRM --------------------------------------------------------------------
    , coalesce(
        sf1.system_name , sf2.system_name
        , d1.crm , d2.crm
    )                                                                         as crm
    , coalesce(
        sf1.system_instance , sf2.system_instance
        , d1.instance_location , d2.instance_location
    )                                                                         as crm_instance_location
    , coalesce(
        sf1.system_key , sf2.system_key
        , d1.crm_key , d2.crm_key
    )                                                                         as crm_key
    , sf1.custodian                                                           as crm_custodian
    , coalesce(
        sf1.estate_item_id , sf2.estate_item_id
        , d1.account_id , d2.account_id
    )                                                                         as crm_account_id
    , coalesce(
        sf1.account_type , sf2.account_type
        , d1.account_type , d2.account_type
    )                                                                         as crm_account_type
    , coalesce(
        sf1.account_name , sf2.account_name
        , d1.account_name , d2.account_name
    )                                                                         as crm_account_name
    , coalesce(
        sf1.registrant_name , sf2.registrant_name
        , d1.registrant_name , d2.registrant_name
    )                                                                         as crm_registrant_name
    , coalesce(
        sf1.household_id , sf2.household_id
        , d1.household_id , d2.household_id
    )                                                                         as crm_client_id
    , coalesce(
        sf1.household_name , sf2.household_name
        , d1.household_name , d2.household_name
    )                                                                         as crm_client_name
    , coalesce(
        sf1.is_active , sf2.is_active
        , d1.is_active , d2.is_active
    )                                                                         as crm_is_active
    , coalesce(
        sf1.created_at::date , sf2.created_at::date
        , d1.created_date , d2.created_date
    )                                                                         as crm_created_date
    , coalesce(sf1.opened_date , sf2.opened_date)                             as crm_opened_date
    , coalesce(
        sf1.closed_date , sf2.closed_date
        , d1.closed_date , d2.closed_date
    )                                                                         as crm_closed_date
    , coalesce(
        sf1.account_value , sf2.account_value
        , d1.account_value , d2.account_value
    )                                                                         as crm_account_value
    , coalesce(
        sf1.client_manager , sf2.client_manager
        , d1.advisor , d2.advisor
    )                                                                         as crm_advisor
    , coalesce(
        sf1.employee_number , sf2.employee_number
        , d1.advisor_id , d2.advisor_id
    )                                                                         as crm_advisor_id
    , coalesce(
        sf1.employee_number_source , sf2.employee_number_source
        , d1.advisor_id_source , d2.advisor_id_source
    )                                                                         as crm_advisor_id_source
    , coalesce(
        sf1.client_manager_email , sf2.client_manager_email
        , d1.advisor_email , d2.advisor_email
    )                                                                         as crm_advisor_email
    , coalesce(
        sf1.household_location_code , sf2.household_location_code
        , d1.location_code , d2.location_code
    )                                                                         as crm_location_code
    , coalesce(sf1.fee_schedule , sf2.fee_schedule)                           as crm_fee_schedule
    , coalesce(
        sf1.investment_strategy , sf2.investment_strategy
        , d1.investment_strategy , d2.investment_strategy)
        as crm_model_investment_strategy
    , coalesce(sf1.aum_classification , sf2.aum_classification)               as crm_aum_classification
    , coalesce(sf1.is_erisa , sf2.is_erisa)                                   as crm_is_erisa
    , coalesce(
        sf1.is_discretionary , sf2.is_discretionary
        , d1.is_discretionary , d2.is_discretionary
    )::number(2 , 0
    )                                                                         as crm_is_discretionary
    , coalesce(sf1.is_voting_proxied , sf2.is_voting_proxied)                 as crm_is_voting_proxied
    , coalesce(sf1.is_prime_broker , sf2.is_prime_broker)                     as crm_is_prime_broker
    , coalesce(sf1.is_broker_dealer_account , sf2.is_broker_dealer_account)
        as crm_is_broker_dealer_account

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce() }}

    -- KEYS -------------------------------------------------------------------
    , concat(
        a.system_key
        , '__' , pms_account_name
    )
        as system_key__account_name
    , concat(
        a.system_key
        , '__' , pms_account_number
    )
        as system_key__account_number
    , concat(
        a.system_key
        , '__' , '' , coalesce(pms_advisor , crm_advisor)
    )                                                                         as system_key__advisor

    , concat(pms_advisor , '__' , pms_account_number)
                                                                              as advisor__account_number
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
                a.effective_date , __account_key
                , __custodian_key
        )                                                                     as dedupe_system_count

    , case when dedupe_system_count
            > 1 then 1
        else 0
    end                                                                       as has_dupes
    , ''::text(5000)
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
    end                                                                       as is_excluded
    , object_construct_keep_null(
        'join_d1_eff_date' , iff(d1.crm_pms_account_id is not null , 1 , 0)
        , 'join_d2_is_head' , iff(d2.crm_pms_account_id is not null , 1 , 0)
        , 'join_map_cus_glo' , iff(map_cus_glo.source_value is not null , 1 , 0)
        , 'join_ovrd_acct' , iff(ovrd_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_acct' , iff(ovrd_sys_acct.scope_key is not null , 1 , 0)
        , 'join_ovrd_sys_adv' , iff(ovrd_sys_adv.scope_key is not null , 1 , 0)
        , 'join_pref_adv_acct' , iff(pref_adv_acct.scope_key is not null , 1 , 0)
        , 'join_pref_adv' , iff(pref_adv.scope_key is not null , 1 , 0)
        , 'join_pref_loc' , iff(pref_loc.scope_key is not null , 1 , 0)

    )::variant                                                                as _extra_fields

    -- META -------------------------------------------------------------------
    , current_timestamp()::timestamp_ntz                                      as _created_at
    , a._created_at::timestamp_ntz                                            as _source_loaded_at
    , null::text(500)                                                         as _source_file
from base_accounts as a
left join base_households as h
    on a.effective_date = h.effective_date
    and a.primary_household_id = h.upload_household_id
-- [crm] join to the dynamics crm "effective_date" and then on "is_head" if the first join does not return a result.
left join {{ ref('dynamics_tamarac_cpg__int_accounts') }} as d1
    on a.effective_date::date = d1.effective_date
    and a.upload_account_id = d1.crm_pms_account_id
    and a.effective_date >= '2024-09-30'
    and exists(select 1 from dates_to_refresh)
    and d1.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
left join {{ ref('dynamics_tamarac_cpg__int_accounts') }} as d2
    on d2.effective_date = (select max(effective_date) from {{ ref('dynamics_tamarac_cpg__int_accounts') }})
    and a.upload_account_id = d2.crm_pms_account_id
    and a.effective_date >= '2024-09-30'
    and exists(select 1 from dates_to_refresh)
    and d2.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
-- [crm] join to the salesforce crm "effective_date" and then on "is_head" if the first join does not return a result.
left join {{ ref('salesforce_compass_accounts') }} as sf1
    on pms_account_number = sf1.account_number
    and __custodian_key = case
        when sf1.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf1.custodian_key
        else ''
    end
    and a.effective_date = sf1.effective_at::date
    and a.effective_date < '2024-09-30'
    and exists(select 1 from dates_to_refresh)
    and sf1.effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
left join {{ ref('salesforce_compass_accounts') }} as sf2
    on pms_account_number = sf2.account_number
    and __custodian_key = case
        when sf2.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf2.custodian_key
        else ''
    end
    and sf2.is_head = 1
    and a.effective_date < '2024-09-30'

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
-- joins on pms location code (static value) as opposed to location code due to ambiguous column
    on pms_location_code = pref_loc.scope_key
    and a.effective_date between coalesce(pref_loc.start_date , a.effective_date)
    and coalesce(pref_loc.end_date , a.effective_date)
where true
    and a.entity_type = 'Single Account'
