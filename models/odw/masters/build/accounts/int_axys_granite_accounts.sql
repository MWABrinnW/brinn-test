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
          'axys_granite__stg_accounts'
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

--------------------------------------------

, cte_agg_strat as (
    select
        a.effective_date                                                                               as effective_date
        , a.system_name                                                                                as system_name
        , a.system_instance                                                                            as system_instance
        , a.system_key                                                                                 as system_key
        , a.firm_source                                                                                as firm_source
        , a.account_number_formatted                                                                   as account_number_formatted
        , a.account_number                                                                             as account_number
        , a.custodian                                                                                  as custodian
        , a.crm_id                                                                                     as crm_id
        , a.acct_status                                                                                as acct_status
        , a.begin_mgmt_date                                                                            as begin_mgmt_date
        , a.close_date                                                                                 as close_date
        , a.aum                                                                                        as aum
        , a.coverage_officer                                                                           as coverage_officer
        , a.discretion                                                                                 as discretion
        , a.proxy_vote                                                                                 as proxy_vote
        , a.prime_enabled                                                                              as prime_enabled
        , a.account_type                                                                               as account_type
        , a._created_at                                                                                as _created_at
        , _source_file                                                                                 as _source_file
        , array_agg(distinct a.portfolio_code) over (partition by a.effective_date , a.account_number) as _account_id
        , listagg(a.goal , ' | ') over (partition by a.effective_date , a.account_number)              as _investment_strategy
        , listagg(a.acct_name , ' | ') over (partition by a.effective_date , a.account_number)         as _account_name
    from {{ ref('axys_granite__stg_accounts') }} as a
    where 1 = 1
        and a.effective_date in (select distinct effective_date from dates_to_refresh as t)
)

select
    ag.effective_date                           as effective_date
    , ag.system_name                            as system_name
    , ag.system_instance                        as system_instance
    , ag.system_key                             as system_key
    , ag.firm_source                            as firm_source
    , ag.account_number_formatted               as account_number_formatted
    , ag.account_number                         as account_number
    , ag.custodian::text(200)                   as custodian
    , ag._account_id::variant                   as account_id
    , ag._account_name::text(200)               as account_name
    , ag.crm_id::text(200)                      as client_id
    , iff(ag.acct_status = 'Open' , 1 , 0)::int as is_active
    , min(ag.begin_mgmt_date::date)             as opened_date
    , ag.close_date::date                       as closed_date
    , sum(ag.aum)::decimal(16 , 2)              as account_value
    , case
        when ag.coverage_officer = 'SBS' then 'Scott Schermerhorn'
        when ag.coverage_officer = 'TSL' then 'Tim Lesko'
        when ag.coverage_officer = 'WDH' then 'Bill Hutchens, Jr.'
        when ag.coverage_officer = 'JMS' then 'Joyce Skaperdas'
        when ag.coverage_officer = 'VGS' then 'Victor Soucy'
        when ag.coverage_officer = 'NFM' then 'Nick MacDonald'
        when ag.coverage_officer = 'MEC' then 'Martha Cottrill'
        else ag.coverage_officer
    end::text(200)                              as advisor
    , null::text                                as advisor_id
    , null::text                                as advisor_id_source
    , null::text                                as advisor_email
    , ag._investment_strategy::text(200)        as model_investment_strategy
    , case
        when ag.discretion = 'Discretionary' then 0
        when ag.discretion = 'Non-Discretionary' then 1
    end::int                                    as is_discretionary
    , case
        when ag.proxy_vote = 'Sole' then 1
        when ag.proxy_vote = 'Client' then 0
    end::int                                    as is_voting_proxied
    , try_to_boolean(ag.prime_enabled)::int     as is_prime_broker
    , ag.account_type                           as type
    , current_timestamp()::timestamp_ntz        as _created_at
    , ag._created_at::timestamp_ntz             as _source_loaded_at
    , ag._source_file                           as _source_file
from cte_agg_strat as ag
group by all
