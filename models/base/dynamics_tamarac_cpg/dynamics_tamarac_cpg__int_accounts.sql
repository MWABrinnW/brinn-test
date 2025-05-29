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
          'dynamics_tamarac_cpg__stg_finance_accounts'
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
    select null::date as effective_date, null::text as system_key
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

----------------------------------------------------

, cpg_accounts as (
    select
        effective_at
        , account_id
        , name
        , tamc_split_1
        , tamc_split_2
        , tamc_split_3
        , tamc_split_4
        , _fivetran_deleted
        , _account_type_id_value
    from {{ ref('dynamics_tamarac_cpg__stg_accounts') }}
    where 1 = 1
        and _fivetran_deleted = 0
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, cpg_split_detail_cte_1 as (
    select
        hh.account_id                                       as split_dtl_account_id
        , hh.name                                           as split_dtl_role_name
        , hh.effective_at                                   as effective_at
        , hh.column_name                                    as split_dtl_split_index
        , to_number(right(trim(split_dtl_split_index) , 1)) as split_dtl_sol_role_id
        , quantity                                          as split_dtl_split_amount
    from cpg_accounts as hh
    unpivot (quantity for column_name in (tamc_split_1 , tamc_split_2 , tamc_split_3 , tamc_split_4))
    where 1 = 1
)

, cpg_connections as (
    select
        effective_at, connection_id, name, _record_1_role_id_value, _record_2_id_value, _related_connection_id_value, state_code
    from {{ ref('dynamics_tamarac_cpg__stg_connections') }}
    where 1 = 1
        and state_code = 0
        and _fivetran_deleted = 0
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, cpg_connection_roles as (
    select
        effective_at, connection_role_id, name
    from {{ ref('dynamics_tamarac_cpg__stg_connection_roles') }}
    where 1 = 1
        and _fivetran_deleted = 0
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, finance_accounts as (
    select
        effective_at
        , tam_custodian
        , tam_upload_id
        , tam_financial_account_id
        , tam_finance_account_id
        , tam_financial_acct_type
        , tam_name
        , _tam_account_id_value
        , tam_termination_date
        , created_at
        , tam_total_value
        , tam_model
        , tam_discretionary_account
        , _tamc_solicitor_payment_household_value
        , _fivetran_synced
    from {{ ref('dynamics_tamarac_cpg__stg_finance_accounts') }}
    where 1 = 1
        and effective_at >= '2024-09-30'--remove date filter (what's this from?)
        and _fivetran_deleted = 0
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, cpg_account_types as (
    select
        effective_at, tam_account_type_id, tam_name
    from {{ ref('dynamics_tamarac_cpg__stg_account_types') }}
    where 1 = 1
        and _fivetran_deleted = 0
        and exists(select 1 from dates_to_refresh)
        and effective_at::date in (select distinct t.effective_date from dates_to_refresh as t)
    qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, cpg_split_detail_cte_2 as (
    select
        ctn_1._record_2_id_value                                                                        as z__record_2_id_value
        , ctn_1.name                                                                                    as z_connection_name
        , ctn_2.name                                                                                    as y_connection_name
        , ctn_2.connection_id                                                                           as y_connection_id
        , ctr_1.name                                                                                    as z_role_name
        , to_number(right(trim(ctr_1.name) , 1))                                                        as sol_role_id
        , max(sol_role_id) over (
            partition by ctn_1._record_2_id_value
            order by ctn_1._record_2_id_value
        )                                                                                               as num_of_sol
        , to_varchar(coalesce(cte_1.split_dtl_split_amount , round((1 / num_of_sol) , 5)) * 100) || '%' as split_amount
        , ctn_1.effective_at                                                                            as effective_at
    -- , cte_1.SPLIT_DTL_SOL_ROLE_ID
    -- , cte_1.SPLIT_DTL_ACCOUNT_ID
    from cpg_connections as ctn_1
    left join cpg_connection_roles as ctr_1
        on ctn_1.effective_at::date = ctr_1.effective_at::date
        and ctn_1._record_1_role_id_value = ctr_1.connection_role_id
    inner join cpg_connections as ctn_2
        on ctn_1.effective_at::date = ctn_2.effective_at::date
        and ctn_1._related_connection_id_value = ctn_2.connection_id
    left join cpg_connection_roles as ctr_2
        on ctn_1.effective_at::date = ctr_2.effective_at::date
        and ctn_2._record_1_role_id_value = ctr_2.connection_role_id
    inner join cpg_accounts as cpg_acc
        on ctn_1.effective_at::date = cpg_acc.effective_at::date
        and ctn_1._record_2_id_value = cpg_acc.account_id
    inner join cpg_account_types as cpg_act
        on ctn_1.effective_at::date = cpg_act.effective_at::date
        and cpg_acc._account_type_id_value = cpg_act.tam_account_type_id
        and cpg_act.tam_name != 'Broker Dealer/RIA'
    left join cpg_split_detail_cte_1 as cte_1
        on ctn_1.effective_at::date = cte_1.effective_at::date
        and ctn_1._record_2_id_value = cte_1.split_dtl_account_id
        and cte_1.split_dtl_sol_role_id = sol_role_id
    where 1 = 1
        and ctr_1.name != 'Employee'
        and ctr_1.name ilike '%SOLICITOR%'
    order by ctn_1._record_2_id_value , ctr_1.name
)

, cpg_split_detail_cte_final as (
    select
        z__record_2_id_value                                               as hh_id
        , effective_at                                                     as effective_at
        , listagg(y_connection_name || ' (' || split_amount || ')' , '; ') as sol_detail
        , listagg(y_connection_id || '; ')                                 as sol_detail_id
    from cpg_split_detail_cte_2
    where true
    group by all
)

----------------------------------------------------
select
    'dynamics'                                           as crm
    , 'tamarac_cpg'                                      as instance_location
    , crm || '__' || instance_location                   as crm_key
    , dfa.tam_custodian                                  as custodian
    , dfa.tam_upload_id                                  as crm_pms_account_id
    , dfa.tam_financial_account_id                       as crm_account_number
    , dfa.tam_finance_account_id                         as account_id
    , dfa.tam_financial_acct_type                        as account_type
    , dfa.tam_name                                       as account_name
    , dfa.tam_name                                       as registrant_name
    , dfa._tam_account_id_value                          as household_id
    , coalesce(dhh.name , 'Orphaned Dynamics Household') as household_name
    , iff(dfa.tam_termination_date is null , 1 , 0)      as is_active
    , dfa.created_at::date                               as created_date
    , null::date                                         as opened_date-- use pms
    , dfa.tam_termination_date                           as closed_date
    , dfa.tam_total_value                                as account_value
    , sol.sol_detail::text                               as advisor
    , sol.sol_detail_id::text                            as advisor_id
    , crm_key                                            as advisor_id_source
    , null::text                                         as advisor_email-- placeholder to be replaced
    , '112'                                              as location_code
    , null::text                                         as fee_schedule-- use pms
    , dfa.tam_model                                      as investment_strategy
    , null::text                                         as aum_classification-- use pms
    , null::int                                          as is_erisa-- use pms
    , dfa.tam_discretionary_account                      as is_discretionary
    , null::int                                          as is_voting_proxied-- use pms
    , null::int                                          as is_prime_broker-- use pms
    , null::int                                          as is_broker_dealer_account-- use pms
    , dfa.effective_at::date                             as effective_date
    , current_timestamp()::timestamp_ntz                 as _created_at
from finance_accounts as dfa
left join cpg_accounts as dhh
    on dfa.effective_at::date = dhh.effective_at::date
    and dfa._tamc_solicitor_payment_household_value = dhh.account_id
    and dhh._fivetran_deleted = 0
left join cpg_split_detail_cte_final as sol
    on dfa.effective_at::date = sol.effective_at::date
    and dfa._tamc_solicitor_payment_household_value = sol.hh_id
where 1 = 1
qualify (
    row_number()
        over
        (
            partition by dfa.effective_at::date , dfa.tam_upload_id
            order by dfa.effective_at::date asc , dfa.tam_upload_id asc , dfa._fivetran_synced desc
        )
) = 1