{%- macro black_diamond_nml_accounts_lambda(instance, is_historical = false, where_conditions = none) -%}
{# This macro combines the black diamond accounts PMS models for lambda view usage into a
historical and fresh version. This is not normally necessary for lambda views but due to
the complexity of the black diamond accounts models and the number of instances we have
this macro helps centralize all the logic for these models. #}

{%- set history_relation = 'nml_black_diamond_' ~ instance ~ '_accounts_history' %}
{%- set fresh_relation = 'nml_black_diamond_' ~ instance ~ '_accounts_fresh' %}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set src_models = [
          'black_diamond_' ~ instance ~ '__base_accounts'
    ]
-%}

{# --============================================================= #}
{# If historical model, we need to use the incremental subqueries that would
later be used to determine the dates for refresh. #}
{%- if is_historical %}
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
{%- endif %}
{# --============================================================= #}

{# For baystate, pull advisor split percents from salesforce. #}
{%- if instance | lower == 'baystate' %}
{%- if is_historical %}
,
{%- else %}
with
{%- endif %}
cte_baystate_fee_schedule as (
    select
        account_id                                                          as account_id
        , effective_date                                                    as effective_date
        , listagg(distinct fee_name,'; ') within GROUP (order by fee_name)  as fee_schedule
    from {{ ref('black_diamond_baystate__base_account_fees') }}
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and effective_date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
    group by 1,2
)

, bd_base_accounts as (
    select
        a.* exclude(is_head)
    from {{ ref('black_diamond_' ~ instance ~ '__base_accounts') }} as a
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and a.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)
{%- elif instance | lower == 'uhnw' %}
{# We need to dedupe UHNW accounts with the MPS instance, ignoring any accounts from UHNW that
are also in the MPS instance. #}
{%- if is_historical %}
,
{%- else %}
with
{%- endif %}
 uhnw_accounts_with_dupes_tagged as (
    select
        uhnw.*
        , case
            when mps.account_number = uhnw.account_number then 1
            else 0
        end::int          as is_duplicate
        , case
            when mps.account_number = uhnw.account_number then 'mps account'
        end::varchar as duplicate_reason
    from {{ ref('black_diamond_uhnw__base_accounts') }} as uhnw
    left join {{ ref('black_diamond_mps__base_accounts') }} as mps
        on uhnw.account_number = mps.account_number
        and uhnw.effective_date = mps.effective_date
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and mps.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and mps.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and uhnw.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and uhnw.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)

-- dedupe accounts that have an identical account number and account value (totalemw) per effective date.
, uhnw_accounts_dupes_ranked as (
    select
        a.*
        , row_number()
            over (
                partition by a.account_number , a.effective_date , a.total_emv
                order by a.account_number asc , a.effective_date asc , a.total_emv desc
            )
            as rn
    from uhnw_accounts_with_dupes_tagged as a
    where true
        and a.is_duplicate = 0
    qualify rn = 1
)

-- identify accounts that have a shared data provider (array has one value),
-- make distinct by appending internal acount id to account number (normalized model); otherwise, source account number
, uhnw_accounts_distinct as (
    select
        da.*
        , count(*) over (partition by da.account_number , da.effective_date)                             as acct_cnt
        , array_agg(distinct da.data_provider) over (partition by da.account_number , da.effective_date) as distinct_data_provider
        , case
            when array_size(distinct_data_provider) = 1 and acct_cnt > 1
                then 1
            else 0
        end::int                                                                                         as make_distinct
    from uhnw_accounts_dupes_ranked as da
)

, bd_base_accounts as (
    select * exclude (is_duplicate , duplicate_reason)
    from uhnw_accounts_distinct
)
{%- else %}
{%- if is_historical %}
,
{%- else %}
with
{%- endif %}
 bd_base_accounts as (
    select
        a.* exclude(is_head)
    from {{ ref('black_diamond_' ~ instance ~ '__base_accounts') }} as a
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and a.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)
{%- endif %}

{# --execute for both conditions "is_historical: true or false" #}

{%- if instance | lower == 'mps' %}
, advisors as (
    select
        associate_id::text                  as associate_id
        , advisor_legal_name_first::text    as advisor_legal_name_first
        , advisor_legal_name_last::text     as advisor_legal_name_last
        , advisor_legal_name_full::text     as advisor_legal_name_full
        , advisor_work_email::text          as advisor_work_email
        , advisor_type::text                as advisor_type
        , advisor_pms_system::text          as advisor_pms_system
        , location_code                     as _location_code
        , system_key::text                  as system_key
    from {{ ref('advisors_enterprise_head') }}
    where true
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        {%- endif %}
)
    
{%- endif %}
{# --========================================================== #}

select
    a.effective_date                                                      as effective_date
    , a.system_name                                                       as system_name
    , a.system_instance                                                   as system_instance
    , a.system_key                                                        as system_key
    , a.firm_source                                                       as firm_source
    , a.account_number_formatted                                          as account_number_formatted
    , a.account_number                                                    as account_number
    , a.account_number                                                    as pms_account_number
    , a.custodian                                                         as pms_custodian
    , a.id::text                                                          as pms_account_id
    , a.account_registration_type::text                                   as pms_account_type
    , case
        when a.system_key in (
            'black_diamond__baystate'
            , 'black_diamond__commonwealth'
            , 'black_diamond__houston'
            , 'black_diamond__uhnw'
            ) then a.account_name
        when a.system_key = 'black_diamond__mcgervey' then r.portfolio_display_name
        else a.custodial_account_name
    end::text                                                             as pms_account_name
    , case
        when a.system_key = 'black_diamond__mcgervey' then r.portfolio_display_name
        else a.custodial_account_name
    end::text                                                             as pms_registrant_name
    , r.relationship_id                                                   as pms_client_id
    , case when '{{ instance }}'::text in ('baystate' , 'mps' , 'uhnw')
        then r.relationship_name else r.portfolio_display_name
       end                                                                as pms_client_name
    , iff(a.closed_date is null , 1 , 0)                                  as pms_is_active
    , null::date                                                          as pms_created_date
    , a.start_date                                                        as pms_opened_date
    , a.closed_date                                                       as pms_closed_date
    , a.total_emv::decimal(16 , 2)                                        as pms_account_value
    , case
        when a.system_key = 'black_diamond__mcgervey'
        then case
            when a.manager = 'YA8' then 'Matt McGervey'
            when a.manager = '55T' then 'Michael E. McGervey'
            when a.manager = '37F' then 'E. Mike McGervey'
            else a.manager
            end
        {% if instance | lower == 'mps' %}
            when a.system_key = 'black_diamond__mps'
            then adv.advisor_legal_name_full
        {% endif %}
        {% if instance | lower == 'baystate' %}
            when a.system_key = 'black_diamond__baystate'
            then sf1_bay.advisor
        {% endif %}
        -- default for "houston" instances
        else a.team
        end::text                                                         as pms_advisor

    {% if instance | lower == 'mps' %}
        , adv.associate_id::text                                          as pms_advisor_id
    {% elif instance | lower == 'baystate' %}
        , sf1_bay.advisor_id                                              as pms_advisor_id
    {% else %}
        , null::text                                                      as pms_advisor_id
    {% endif %}

    
    {% if instance | lower == 'mps' %}
        , case when adv.associate_id is not null
            then adv.system_key end::text                                 as pms_advisor_id_source
        {% else %}
        , null::text                                                      as pms_advisor_id_source
    {% endif %}
   
    {% if instance | lower == 'mps' %}
    , adv.advisor_work_email                                              as pms_advisor_email
    {% else %}
    , null::text                                                          as pms_advisor_email
    {% endif %}
    , case
        when a.system_key = 'black_diamond__houston' then '116'
        when a.system_key = 'black_diamond__mcgervey' then 'L-10016'
        when a.system_key = 'black_diamond__commonwealth' then '173'
        when a.system_key = 'black_diamond__uhnw' then '640'
        when a.system_key = 'black_diamond__baystate' then 'L-10070'
    {%- if instance | lower == 'mps' %}
        when a.system_key = 'black_diamond__mps' then coalesce(adv._location_code,'609')
    {%- endif %}
    end::text                                                             as pms_location_code
    {% if instance | lower == 'baystate' %}
    , cte_fs.fee_schedule                                                 as pms_fee_schedule
    {% else %}
    , a.fee_name                                                          as pms_fee_schedule
    {% endif %}
    , case when a.system_key = 'black_diamond__baystate' then a.style_name
        else null end::text                                               as pms_model_investment_strategy
    ,  {% if instance | lower == 'uhnw' or instance | lower == 'mps' %}
      a.aum_aua_ro as pms_aum_classification
      {% else %}
      'AUM - Assets Under Management'                                     as pms_aum_classification
      {% endif %}
    , null::int                                                           as pms_is_erisa
    , a.discretionary::int                                                as pms_is_discretionary
    , null::int                                                           as pms_is_voting_proxied
    , null::int                                                           as pms_is_prime_broker
    , null::int                                                           as pms_is_broker_dealer_account
    , null::int                                                           as pms_cost_basis_method

    -- CRM --------------------------------------------------------------------
    {% if instance == 'houston' %}
        {{ select_crm_salesforce_compass() }}
    {% else %}
        {{ select_crm_null() }}
    {% endif %}

    -- COALESCE ---------------------------------------------------------------
    {% if instance == 'mps' %}
    {{ select_nml_account_coalesce('black_diamond__mps') }}
    {% else %}
    {{ select_nml_account_coalesce() }}
    {% endif %}


    -- KEYS -------------------------------------------------------------------
    , concat(a.system_key , '__' , pms_account_name)                      as system_key__account_name
    , concat(a.system_key , '__' , pms_account_number)                    as system_key__account_number
    , concat(a.system_key , '__' , coalesce(pms_advisor , crm_advisor))   as system_key__advisor
    , concat(pms_advisor , '__' , pms_account_number)                     as advisor__account_number

    {% if instance == 'uhnw' %}
       ,  case
            when make_distinct = 1
        then concat(pms_account_number , '_' , pms_account_id)
        else pms_account_number end::varchar                              as __account_key
    {% else %}
       , pms_account_number::varchar                                      as __account_key
    {% endif %}

    -- HELPERS ----------------------------------------------------------------
    , {{ assign_custodian_key() }}
    , pref_adv_acct._system_key                                           as pref_advisor__account_number
    {% if instance == 'mps' %}
    , coalesce(pref_adv._system_key , (
        case when adv.advisor_pms_system = 'orion__mps' then 'orion__mps'
            else 'black_diamond__mps'
        end
    ))
                                                                          as pref_advisor
    {% else %}
    ,  pref_adv._system_key                                               as pref_advisor
    {% endif %}
    , pref_loc._system_key                                                as pref_location
    , coalesce(
        pref_advisor__account_number
        , pref_advisor
        , pref_location
        , a.system_key
    )                                                                     as pref_system_key
    , row_number()
        over (
            partition by
                a.effective_date
                , __account_key
                , __custodian_key
            order by
                a._source_loaded_at desc
                , pms_closed_date desc
                , case when crm_aum_classification = 'AUM - Assets Under Management' then 1
                  when crm_aum_classification = 'AUA - Assets Under Advisory' then 2
                  else 3 end asc
                , iff(crm_account_id is null, 2, 1) asc
                , iff(advisor is null, 2, 1) asc
                , pms_account_value desc
                , pms_created_date asc
        )                                                                 as dedupe_system_rn
    , count(*)
        over (
               partition by
                a.effective_date
                , __account_key
                , __custodian_key
        )                                                                 as dedupe_system_count
    , case when dedupe_system_count > 1 then 1 else 0 end                 as has_dupes
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
    {# || coalesce(case
        when a.system_key = 'black_diamond__commonwealth' and r.is_master_portfolio = 0
        then 'black diamond is_master_portfolio=0;'
        else ''
    end , '') #}
    || coalesce(case
        when a.system_key = 'black_diamond__uhnw' and pms_advisor is null
            then 'Advisor is null;'
        when a.system_key = 'black_diamond__uhnw' and pms_advisor not in ('Bonde', 'Dominic Cozzetto', 'Marc Russell', 'The Lab', 'APX')
            then 'Non UHNW advisor;'
    end , '')
                                                                          as excluded_reasons
    , coalesce(
        ovrd_acct._is_excluded
        , ovrd_sys_acct._is_excluded
        , ovrd_sys_adv._is_excluded
        , case
            when excluded_reasons = '' then 0
            else 1
        end
    )                                                                     as is_excluded
, object_construct_keep_null(
    {% if instance | lower == 'houston' %}
        'join_sf1_eff_date', iff(sf1.system_key is not null, 1, 0),
        'join_sf2_is_head', iff(sf2.system_key is not null, 1, 0),
    {% endif %}
    {% if instance | lower == 'mps' %}
        'pms_advisor_source', (a.team),
        'join_advisor_master' , iff(adv.associate_id is not null , 1 , 0),
    {% endif %}
        'join_map_cus_glo', iff(map_cus_glo.source_value is not null, 1, 0),
        'join_ovrd_acct', iff(ovrd_acct.scope_key is not null, 1, 0),
        'join_ovrd_sys_acct', iff(ovrd_sys_acct.scope_key is not null, 1, 0),
        'join_ovrd_sys_adv', iff(ovrd_sys_adv.scope_key is not null, 1, 0),
        'join_pref_adv_acct', iff(pref_adv_acct.scope_key is not null, 1, 0),
        'join_pref_adv', iff(pref_adv.scope_key is not null, 1, 0),
        'join_pref_loc', iff(pref_loc.scope_key is not null, 1, 0)
)::variant as _extra_fields
    -- META -------------------------------------------------------------------
    , current_timestamp()::timestamp_ntz                                  as _created_at
    , a._source_loaded_at::timestamp_ntz                                  as _source_loaded_at
    , null::text                                                          as _source_file
from bd_base_accounts                                                             as a
left join {{ ref('black_diamond_' ~ instance ~ '__int_relationships_distinct') }} as r
    on a.effective_date = r.effective_date
    and a.id = r.account_id
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and r.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and r.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
left join {{ ref('black_diamond_' ~ instance ~ '__base_account_fees') }}          as f
    on a.effective_date = f.effective_date
    and a.id = f.account_id
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and f.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and f.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
-- [crm] join to the salesforce crm "effective_date" and then on "is_head" if the first join does not return a result.
{%- if instance | lower == 'houston' %}
left join {{ ref('salesforce_compass_accounts') }} as sf1
    on pms_account_number = sf1.account_number
    and __custodian_key = case
        when sf1.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf1.custodian_key
        else ''
    end
    and a.effective_date = sf1.effective_at::date
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and sf1.effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and sf1.effective_at::date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
left join {{ ref('salesforce_compass_accounts') }} as sf2
    on pms_account_number = sf2.account_number
    and __custodian_key = case
        when sf2.custodian_key in ('schwab' , 'fidelity' , 'lpl' , 'pershing' , 'tda') then sf2.custodian_key
        else ''
    end
    and sf2.is_head = 1
{%- endif %}

-- [misc] joins to a specific instance that otherwise would error if not wrapped with jinga
{%- if instance | lower == 'baystate' %}
left join {{ ref('salesforce_baystate__int_advisors') }} as sf1_bay
    on a.effective_date = sf1_bay.effective_date
    and a.advisor_commission_split_code = sf1_bay.advisor_commission_split_code
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and sf1_bay.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and sf1_bay.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
left join cte_baystate_fee_schedule as cte_fs
    on cte_fs.account_id = a.id
    and cte_fs.effective_date = a.effective_date
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and cte_fs.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and cte_fs.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
{%- endif %}

{%- if instance | lower == 'mps' %}
left join advisors as adv
 on lower(adv.advisor_legal_name_full) = lower(a.team)
     and lower(adv.system_key) = 'redtail__network'
{%- endif %}

-- mappings
left join {{ ref('aux__stg_masters_mappings') }} as map_aum_glo
    on map_aum_glo.field = 'aum_classification'
    {% if instance | lower == 'mps' -%}
    and coalesce(pms_aum_classification , crm_aum_classification) = map_aum_glo.source_value
    {% else %}
    and coalesce(crm_aum_classification, pms_aum_classification) = map_aum_glo.source_value
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
where 1 = 1
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and a.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
    {%- if where_conditions %}
    {{ where_conditions }}
    {%- endif %}

{%- endmacro -%}
