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
          'orion__bld_accounts'
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
        and system_key = 'orion__core'
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

--------------------------------------------------------------------------------

, orion_accounts as (
    select *
    from {{ ref('orion__bld_accounts') }}
    where 1 = 1
        and account_number is not null
        and system_key = 'orion__core'
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from dates_to_refresh)
)

, sf_accounts as (
    select
        effective_at
        , system_name, system_instance, system_key
        , orion_account_id
        , estate_item_id
        , account_type
        , registration_type
        , account_name
        , custodian
        , registrant_name
        , household_id
        , household_name
        , is_active
        , created_at
        , opened_date
        , closed_date
        , account_value
        , client_manager
        , client_manager_email
        , household_location_code
        , fee_schedule
        , investment_strategy
        , aum_classification
        , is_erisa
        , is_discretionary
        , is_voting_proxied
        , is_prime_broker
        , is_broker_dealer_account
        , employee_number
        , employee_number_source
        , row_number() over(
            partition by effective_at::date, orion_account_id
            order by rn_acct_num
        )   as rn_orion_account_id
    from {{ ref('bld_salesforce_compass_accounts') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct effective_date from dates_to_refresh)
)

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
    , a.advisor                                                               as pms_advisor
    , null::text(200)                                                         as pms_advisor_id
    , null::text(200)                                                         as pms_advisor_id_source
    , a.advisor_email                                                         as pms_advisor_email
    , a.location_code                                                         as pms_location_code
    , a.fee_schedule                                                          as pms_fee_schedule
    , a.investment_strategy                                                   as pms_model_investment_strategy
    , null::text                                                              as pms_aum_classification
    , null::int                                                               as pms_is_erisa
    , null::int                                                               as pms_is_discretionary
    , null::int                                                               as pms_is_voting_proxied
    , null::int                                                               as pms_is_prime_broker
    , null::int                                                               as pms_is_broker_dealer_account
    , null::text                                                              as pms_cost_basis_method
    -- CRM --------------------------------------------------------------------
    {{ select_crm_salesforce_compass() }}

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce('orion__core') }}

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
    , array_to_string(
        array_construct_compact(
        -- household
            case
                when pms_client_name ilike 'History Client%' then 'Historical client;'
                when pms_client_name = 'History Household' then 'Historical client;'
            end
            -- advisor
            , case
                when pms_advisor = 'Demo Rep' then 'Demo rep;'
                when pms_advisor ilike 'Test Rep%' then 'Test account;'
                when pms_advisor ilike 'DO NOT USE%' then 'Flagged account;'
                when pms_advisor = 'Boston History Conversion' then 'Conversion account;'
                when pms_advisor = 'MIAN Accounts' then 'Custodian direct account;'
            end
            -- account
            , case
                when pms_account_name ilike 'Hist Account' then 'Historical account;'
                when a.account_number ilike '%NOTIONAL' then 'Premium Income duplication;'
                when a.account_number ilike '%_HIST' then 'Historical account;'
                when a.account_number ilike '%_HIST_E' then 'Historical account;'
            end
            -- custodian dealer
            , case
                when pms_custodian = 'Sample Custodian' then 'Sample custodian;'
                when
                    pms_custodian = 'Billing Accounts' and pms_account_number in ('CHOYTBILL' , 'HHHLLCBILL')
                    then 'Billing account;'
            end
            -- Broker/Dealer reasons
            , case
                when
                    a.bd_name in ('DO NOT USE - CONVERSION HISTORY BROKER/DEALER' , 'Sample -- Remove')
                    then 'Excluded broker dealer entity;'
            end
        )
        , ' '-- Separator
    )::varchar(2000)                                                          as excluded_reasons
    , case
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
    --, a.is_head                                                               as is_head
    , a._source_loaded_at                                                     as _created_at
    , a._source_loaded_at                                                     as _source_loaded_at
    , a._source_file                                                          as _source_file
from orion_accounts as a
-- [crm] join to the salesforce crm "effective_date" and then on "is_head" if the first join does not return a result.
left join sf_accounts as sf1
    on a.effective_date = sf1.effective_at::date
    and a.account_id = sf1.orion_account_id
    and sf1.rn_orion_account_id = 1
left join sf_accounts as sf2
    on sf2.effective_at::date = (select max(tt.effective_at::date) from sf_accounts as tt)
    and a.account_id = sf2.orion_account_id
    and sf2.rn_orion_account_id = 1
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
where 1 = 1
