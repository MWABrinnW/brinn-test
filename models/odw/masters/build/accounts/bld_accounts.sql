{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'system_key']
) }}

-- set variables from the variable dictionary maco used in this script
{% set lookback = cvar('lookback') %}
{% set dev_filter = cvar('dev_day_filter')%}

-- resolve the "end_date" or use current_date function
{% set provided_end_date = var('end_date', none) %}
{% set end_date = 
    "'" ~ provided_end_date ~ "'" if provided_end_date 
    else "current_date" 
%}

-- resolve the "start_date" based on the "end_date" and "lookback"
{% set start_date = "dateadd('day', -" ~ lookback ~ ", " ~ end_date ~ ")" %}


{%-
    set source_models = [
          'nml_addepar_corbenic_accounts'
         ,'nml_axys_granite_accounts'
         ,'nml_black_diamond_baystate_accounts'
         ,'nml_black_diamond_houston_accounts'
         ,'nml_black_diamond_mps_accounts' 
         ,'nml_black_diamond_uhnw_accounts'
         ,'nml_cambak_andco_accounts'
         ,'nml_envestnet_manasquan_accounts'
         ,'nml_orion_core_accounts'
         ,'nml_orion_cascadia_accounts'
         ,'nml_orion_arbor_wealth_accounts'
         ,'nml_orion_hayes_accounts'
         ,'nml_orion_mps_accounts'
         ,'nml_portfoliocenter_tcea_accounts'
         ,'nml_salesforce_compass_rps_accounts'
         ,'nml_salesforce_compass_mic_accounts'
         ,'nml_tamarac_state_college_accounts'
         ,'nml_tpg_hfw_accounts'
    ]
-%}

with cte_union as (
    {% for nml_model in source_models -%}
        select
            *
            , {{ "'" ~ nml_model ~ "'" }} as _source_model
            , case when system_key in ('cambak__andco','salesforce__compass_rps') then 1
                else 0
            end::int                          as is_institutional
        from {{ ref(nml_model) }}
        where true
        {%- if not loop.last %}
            union all
        {% endif -%}
    {%- endfor %}
),

{# aggregate max source_loadd at across all unions, if any source is latter than the target "created_at"
all data needs to be reloaded for the effective date #}
cte_max_source_loaded_at AS (
    select
        effective_date,
        max(_source_loaded_at)::datetime as max_source_loaded_at
    from cte_union
    where true
    and effective_date between {{start_date}} and {{end_date}}
    group by all
),

{# aggregate max created_at for use in incremental #}

-- aggregate max created_at for use in incremental
cte_target_max AS (
    {%- if is_incremental() -%}
        select 
            effective_date,
            max(_created_at)::datetime as max_created_at
        from {{ this }}
        where effective_date between {{start_date}} and {{end_date}}
        group by effective_date
    {%- else -%}
        select 
            null::date as effective_date,
            null::datetime as max_created_at
    {%- endif %}
),

cte_incremental as (
    select cte_union.*
    from cte_union as cte_union
    left join cte_target_max as cte_tm
       on cte_union.effective_date = cte_tm.effective_date
    left join cte_max_source_loaded_at as cte_um
       on cte_um.effective_date = cte_tm.effective_date
    where true
        -- lookback window, defaults to lookback (start) from today (end)
        and cte_union.effective_date between {{ start_date }} and {{ end_date }}
        {%- if target.name not in ['prod'] %}
            -- restrict lookback window in dev.
            and datediff('day', {{ start_date }}, {{ end_date }}) <= {{ dev_filter }}
        {%- endif %}

        {%- if is_incremental() %}
        and 
            (
            -- insertion for fresher records or records do not exist for a given effective_date
            cte_tm.max_created_at is null
            or cte_um.max_source_loaded_at > cte_tm.max_created_at
            )
        {%- endif %}

)
,
cte_system_with_custodial as (
-- join with custodian master for custodian sourced fields. 
-- min function applied to standardize custodian accross partition, later used in the primary account evaluation
    select
        a.*
        --- TODO: consider how to account for lpl accounts similar to other custodians
        , min(case
            when a.__custodian_key in ('schwab' , 'fidelity' , 'pershing' , 'lpl' , 'tda') then a.__custodian_key
            else ''
        end) over (partition by a.is_institutional , a.effective_date , a.account_number) as __custodian_cust
        , case when ca.account_number is not null then 1 else 0 end                       as has_custodial_feed
        , null::int                                                                       as cus_is_discretionary
        , ca.is_prime_broker                                                              as cus_is_prime_broker
        , null::int                                                                       as cus_is_broker_dealer_account
    from cte_incremental as a
    left join {{ ref('bld_custodian_accounts') }} as ca
        on a.effective_date = ca.effective_date
        and a.__custodian_key = ca.custodian
        and a.account_number = ca.account_number
        and ca.rn_global = 1
)

, cte_fidelity_firm_sources as (
    select
        f.account_number
        , f.effective_date
        , f.custodian
        , f.gnum                                                                    as link
        , cl.link_type
        , cl.link_subtype
        , array_agg(distinct cl.firm_source) within group (order by cl.firm_source) as firm_source_agg
    from {{ ref('fidelity__int_gnums') }} as f
    left join {{ ref('custodian_links') }} as cl
        on f.gnum = cl.link
        and f.effective_date >= coalesce(cl.effective_start_date , '1999-01-01')
        and f.effective_date <= coalesce(cl.effective_end_date , '2099-12-31')
        and cl.custodian = 'fidelity'
    where true
        and f.gnum_source = 'PRIMARY_GNUM'
    group by all
)

, cte_schwab_firm_sources as (
    select
        s.account_number
        , s.effective_date
        , s.custodian
        , fa_master_account_number                                                as link
        , 'master_number'                                                         as link_type
        , 'fa_master'                                                             as link_subtype
        , array_agg(distinct s.firm_source) within group (order by s.firm_source) as firm_source_agg
    from {{ ref('schwab__base_fa_master_relationships') }} as s
    where true
    group by all
)

, cte_system_with_firm_source_verified as (
    select
        a.*
        , coalesce(f.link , s.link)                 as link
        , coalesce(f.link_type , s.link_type)       as link_type
        , coalesce(f.link_subtype , s.link_subtype) as link_subtype
        , case
            when a.__custodian_cust = 'fidelity' then f.firm_source_agg
            when a.__custodian_cust = 'schwab' then s.firm_source_agg
            when a.__custodian_cust = 'pershing' then array_construct('mwa')
            when a.__custodian_cust = 'lpl' then array_construct('mps')
        end::variant                                as firm_source_verified
    from cte_system_with_custodial as a
    left join cte_fidelity_firm_sources as f
        on a.account_number = f.account_number
        and a.effective_date = f.effective_date
        and a.__custodian_cust = lower(f.custodian)
    left join cte_schwab_firm_sources as s
        on a.account_number = s.account_number
        and a.effective_date = s.effective_date
        and a.__custodian_cust = lower(s.custodian)
)

, cte_location as (
    select 
    a.*
    , l.office_name as office_name
    from cte_system_with_firm_source_verified as a
        left join {{ ref('locations') }} as l
    on a.location_code = l.location_code
    and l.active = 1
)

, cte_final as (
    select
    -- [normalized] attributes normalized and coalesced accross source systems
        effective_date
        , system_name
        , system_instance
        , system_key
        , firm_source
        , firm_source_verified
        , account_number_formatted
        , account_number
        , custodian
        , link
        , link_type
        , link_subtype
        , account_type
        , account_name
        , registrant_name
        , client_name
        , is_active
        , created_date
        , opened_date
        , closed_date
        -- account values should be 0 if the effective date proceeds the closed date (from system only, except rps)
        , iff((coalesce(closed_date , '2099-12-31')) <= effective_date , 0 , account_value)          as account_value
        , advisor
        , max(
            advisor_email) over (
            partition by
                effective_date
                , system_key
                , advisor
        )                                                                                            as advisor_email
        , advisor_employee_id
        , location_code
        , office_name
        , fee_schedule
        , model_investment_strategy
        , case when aum_classification is null then 'Needs Classification' else aum_classification end::text(200) as aum_classification
        , case when is_erisa = 1 then 1 else 0 end::int                                              as is_erisa
        , coalesce(
            cus_is_discretionary
            , is_discretionary
        )                                                                                            as is_discretionary
        , coalesce(
            cus_is_prime_broker
            , is_prime_broker
        )                                                                                            as is_prime_broker
        , coalesce(
            cus_is_broker_dealer_account
            , is_broker_dealer_account
        )                                                                                            as is_broker_dealer_account

        , pref_advisor__account_number
            as pref_advisor__account_number
        , pref_advisor                                                                                as pref_advisor
        , pref_location                                                                               as pref_location
        , pref_system_key                                                                                    as pref_system_key
        , is_institutional
        , dedupe_system_rn
        , dedupe_system_count
        --- [global deduplication decision tree] --------------------------------------------------------------------------------------------------------
        , row_number()
            over (
                partition by is_institutional , effective_date , __account_key , __custodian_cust
                order by
                    -- disqualify excluded account records
                    coalesce(is_excluded , 0) asc
                    -- prefer first record in a system, if duped
                    , dedupe_system_rn asc
                    -- prefer open accounts over closed
                    , iff(closed_date is null , 1 , 2) asc
                    -- prefer accounts that have a preferred system key that matches record system key
                    , case when system_key = pref_system_key then 1 else 2 end asc
                    -- prefer records that have an "account", "advisor" override
                    , case
                        when pref_advisor__account_number is not null
                            then 1
                        when pref_advisor is not null and advisor is not null
                            then 2
                        else 3
                    end::int
                    -- prefer "portfoliocenter tcea" over other system
                    , case when system_key = 'portfoliocenter__tcea' then 1 else 2 end asc
                    -- prefer records that have a "location" override
                    , case when pref_location = system_key then 1 else 2 end asc
                    -- prefer "tamarac stateg college" over other system
                    , case when system_key = 'tamarac__state_college' and crm = 'dynamics' then 1 else 2 end asc
                    -- prefer "orion" system by firm source
                    , case when system_key = 'orion__core' and coalesce(firm_source_verified[0] , firm_source) = 'mwa'
                            then 1
                        when system_key = 'orion__mps' and coalesce(firm_source_verified[0] , firm_source) = 'mps'
                            then 1
                        else 2
                    end asc
                    -- prefer accounts that were found in CRM
                    , case when crm_account_id is not null then 1 else 2 end asc
            )                                                                                        as dedupe_global_rn
        , count(*)
            over (partition by is_institutional , effective_date , __account_key , __custodian_cust) as dedupe_global_count
        , count(distinct system_key)
            over (partition by is_institutional , effective_date , __account_key , __custodian_cust) as dedupe_system_key_count
        , case when has_dupes = 1 or dedupe_global_count > 1 then 1 else 0 end                       as has_dupes

        --- [global deduplication decision tree ~ breakout] ----------------------------------------------------------------------------------------------
        , is_excluded                                                                                as __is_excluded
        , excluded_reasons                                                                           as __if_excluded_reasons
        , dedupe_system_rn                                                                           as __dedupe_system_rn
        , iff(closed_date is null , 1 , 2)                                                           as __prefer_open
        , case when system_key = pref_system_key then 1 else 2 end                                               as __key_match_preference
        , case
            when pref_advisor__account_number is not null then 1
            when pref_advisor is not null and advisor is not null then 2
            else 3
        end::int                                                                                     as __ovrd_acct_and_or_advisor
        , case when system_key = 'portfoliocenter__tcea' then 1 else 2 end                           as __prefer_portfolio
        , case when pref_location = system_key then 1 else 2 end                                      as __ovrd_location
        , case when system_key = 'tamarac__state_college' and crm = 'dynamics' then 1
            else 2
        end                                                                                          as __prefer_tamarac
        , case when system_key = 'orion__core' and coalesce(firm_source_verified[0] , firm_source) = 'mwa'
                then 1
            when system_key = 'orion__mps' and coalesce(firm_source_verified[0] , firm_source) = 'mps'
                then 1
            else 2
        end                                                                                          as __prefer_orion
        , case when crm_account_id is not null then 1 else 2 end                                     as __prefer_with_crm_id
        ----------------------------------------------------------------------------------------------------------------------------------------------------

        , has_custodial_feed
        , excluded_reasons
        , is_excluded
    
    -- [pms] attributes sourced from the pms
        , pms_account_number
        , pms_custodian
        , pms_account_id
        , pms_account_type
        , pms_account_name
        , pms_registrant_name
        , pms_client_id
        , pms_client_name
        , pms_is_active
        , pms_created_date
        , pms_opened_date
        , pms_closed_date
        , pms_account_value
        , pms_advisor
        , pms_advisor_email
        , pms_location_code
        , pms_fee_schedule
        , pms_model_investment_strategy
        , pms_aum_classification
        , pms_is_erisa
        , pms_is_discretionary
        , pms_is_voting_proxied
        , pms_is_prime_broker
        , pms_is_broker_dealer_account

    -- [crm] attributes sourced from the crm 
        , crm
        , crm_instance_location
        , crm_key
        , crm_custodian
        , crm_account_id
        , crm_account_type
        , crm_account_name
        , crm_registrant_name
        , crm_client_id
        , crm_client_name
        , crm_is_active
        , crm_created_date
        , crm_opened_date
        , crm_closed_date
        , crm_account_value
        , crm_advisor
        , crm_advisor_email
        , crm_location_code
        , crm_fee_schedule
        , crm_model_investment_strategy
        , crm_aum_classification
        , crm_is_erisa
        , crm_is_discretionary
        , crm_is_voting_proxied
        , crm_is_prime_broker
        , crm_is_broker_dealer_account

    -- [custodian] attributes sourced from the custodian
        , cus_is_discretionary
        , cus_is_prime_broker
        , cus_is_broker_dealer_account

    -- [metadata] internal helpers and metadata
        , __custodian_key
        , __custodian_cust
        , system_key__account_number
        , system_key__advisor
        , advisor__account_number
        , __account_key
        , is_head
        , is_current
        , _source_loaded_at
        , _source_file
        , _extra_fields
    from cte_location
)

, cte_preferred_system_key as (
-- Get the preferred_system_key for the primary record
    select
        is_institutional
        , effective_date
        , __custodian_cust
        , __account_key
        , pref_system_key
    from cte_final
    where 1 = 1
        and dedupe_global_rn = 1
)

-- Assign the preferred_system_key to each account record
select
    a.*
    , pk.pref_system_key as __preferred_system_key
    , case
        when a.dedupe_global_rn = 1
            then 1
        else 0
    end                       as is_primary
    , {{ col_is_market_day(date_col = 'a.effective_date')}}
    , {{ col_is_market_month_end(date_col='a.effective_date') }}
    , current_timestamp()::datetime     as _created_at
from cte_final as a
left join cte_preferred_system_key as pk
    on a.is_institutional = pk.is_institutional
    and a.effective_date = pk.effective_date
    and a.__custodian_cust = pk.__custodian_cust
    and a.__account_key = pk.__account_key
where 1 = 1
order by __account_key asc , is_primary desc , dedupe_global_rn asc
