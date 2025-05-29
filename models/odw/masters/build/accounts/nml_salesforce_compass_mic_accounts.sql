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
          'bld_salesforce_compass_accounts'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, max(_created_at) as _created_at
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
    select null::date as effective_date
        , null::timestamp as _created_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
    select
        effective_at::date          as effective_date
        , max(_created_at)          as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_at::date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_at::date >= current_date() - {{ lookback }}
        {%- endif %}
        and effective_at::date < current_date()
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date from source_summary group by all
    union
    select effective_date from destination_summary group by all
)


, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
    left join destination_summary d
        on a.effective_date = d.effective_date
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

select
    a.effective_at::date                                                      as effective_date
    , a.system_name                                                           as system_name
    , 'mic'                                                                   as system_instance
    , 'salesforce__compass_mic'                                               as system_key
    , a.firm_source                                                           as firm_source
    , a.account_number                                                        as account_number_formatted
    , a.account_number                                                        as account_number
    , a.account_number                                                        as pms_account_number
    , a.custodian::text(500)                                                  as pms_custodian
    , a.id::text(500)                                                         as pms_account_id
    , a.registration_type::text(500)                                          as pms_account_type
    , a.account_name::text(500)                                               as pms_account_name
    , a.registrant_name::text(500)                                            as pms_registrant_name
    , a.household_id::text(500)                                               as pms_client_id
    , a.household_name::text(500)                                             as pms_client_name
    , a.is_active::int                                                        as pms_is_active
    , a.created_at::date                                                      as pms_created_date
    , a.opened_date::date                                                     as pms_opened_date
    , a.closed_date::date                                                     as pms_closed_date
    , a.account_value::decimal(16 , 2)                                        as pms_account_value
    , a.client_manager::text(500)                                             as pms_advisor
    , null::text                                                              as pms_advisor_id
    , null::text                                                              as pms_advisor_id_source
    , a.client_manager_email::text(500)                                       as pms_advisor_email
    , a.household_location_code::text(500)                                    as pms_location_code
    , a.fee_schedule::text(500)                                               as pms_fee_schedule
    , a.investment_strategy::text(500)                                        as pms_model_investment_strategy
    , a.aum_classification::text(500)                                         as pms_aum_classification
    , a.is_erisa::int                                                         as pms_is_erisa
    , a.is_discretionary::int                                                 as pms_is_discretionary
    , a.is_voting_proxied::int                                                as pms_is_voting_proxied
    , a.is_prime_broker::int                                                  as pms_is_prime_broker
    , a.is_broker_dealer_account::int                                         as pms_is_broker_dealer_account
    , null::int                                                               as pms_cost_basis_method

    -- CRM --------------------------------------------------------------------
    {{ select_crm_null('salesforce__compass_mic') }}
    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce(system_key='salesforce__compass_mic') }}

    -- KEYS -------------------------------------------------------------------
    , concat('salesforce__compass_mic' , '__' , pms_account_name)             as system_key__account_name
    , concat('salesforce__compass_mic' , '__' , pms_account_number)           as system_key__account_number
    , concat(
        'salesforce__compass_mic'
        , '__'
        , coalesce(pms_advisor , crm_advisor)
    )                                                                         as system_key__advisor
    , concat(pms_advisor , '__' , pms_account_number)                         as advisor__account_number
    , account_number                                                          as __account_key

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
                a._source_loaded_at desc
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
    , ''::text(5000)
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
    , current_timestamp()::timestamp_ntz                                      as _created_at
    , a._source_loaded_at::timestamp_ntz                                      as _source_loaded_at
    , null::text(500)                                                         as _source_file
from {{ ref('bld_salesforce_compass_accounts') }} as a
-- Exclude dates that aren't market days and future dates.
inner join {{ ref('dates') }} as dt
    on a.effective_at::date = dt.date_key
    and dt.is_market_day = 1
    and dt.date_key < current_date()
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
    and coalesce(a.is_deleted , 0) = 0
    --and a.is_earliest = 1
    and (
        a.client_manager = 'Robert Woodard'
        or a.account_name ilike '%investorforce%'
    )
    and a.as_of_date is not null
    and coalesce(a.custodian , '') <> 'Billing Accounts'
    and exists(select 1 from dates_to_refresh)
    and a.effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
