--this model does not include orion records. those records are joined in a downstream model.
{{ config(
    materialized='incremental',
    unique_key='_effective_date__system_key',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date','system_key']
) }}

-- set variables from the variable dictionary maco used in this script
{% set lookback = cvar('lookback') %}
{% set dev_filter = cvar('dev_day_filter')%}
{% set max_start_date = cvar('account_masters_start_date')%}

-- resolve the "end_date" or use current_date function
{% set provided_end_date = var('end_date', none) %}
{% set end_date = 
    "'" ~ provided_end_date ~ "'" if provided_end_date 
    else "current_date" 
%}

-- resolve the "start_date" based on the "end_date" and "lookback"
{% set start_date = "dateadd('day', -" ~ lookback ~ ", " ~ end_date ~ ")" %}

{% set source_models = ['nml_addepar_corbenic_holdings',
    'nml_axys_granite_holdings',
    'nml_black_diamond_baystate_holdings' ,
    'nml_black_diamond_houston_holdings' ,
    'nml_black_diamond_mps_holdings' ,
    'nml_black_diamond_uhnw_holdings' ,
    'nml_envestnet_manasquan_holdings' ,
    'nml_portfoliocenter_tcea_holdings' ,
    'nml_tamarac_state_college_holdings' , 
    'nml_tpg_hfw_holdings'
] %}

with cte_union as (
    {% for nml_model in source_models -%}
        select
            *,
            '{{ nml_model }}' as _source_model
        from {{ ref(nml_model) }}
        where true
        {%- if not loop.last %} union all {% endif -%}
    {% endfor %}
),

-- aggregate max created_at for use in incremental
cte_target_max AS (
    {%- if is_incremental() -%}
        select 
            system_key,
            effective_date,
            max(_created_at)::datetime as max_created_at
        from {{ this }}
        where true
            and effective_date between {{start_date}} and {{end_date}}
        group by system_key, effective_date
    {%- else -%}
        select 
            null::text(200) as system_key,
            null::date as effective_date,
            null::datetime as max_created_at
    {%- endif %}
),

cte_incremental as (
    select cte_union.*
        , concat(cte_union.effective_date,'__',cte_union.system_key) as _effective_date__system_key
    from cte_union as cte_union
    left join cte_target_max as cte_tm
       on cte_union.system_key = cte_tm.system_key
       and cte_union.effective_date = cte_tm.effective_date
    where true
        -- limits build, static date from cvar
        and cte_union.effective_date >= '{{ max_start_date }}'
        -- lookback window, defaults to lookback (start) from today (end)
        and cte_union.effective_date between {{start_date}} and {{end_date}}
    {%- if target.name not in ['prod'] %}
        -- restrict lookback window in dev.
        and datediff('day', {{ start_date }}, {{ end_date }}) <= {{ dev_filter }}
    {%- endif %}

    {%- if is_incremental() %}
        and 
            (
            -- insertion for fresher records or records do not exist for a given effective_date
            cte_tm.max_created_at is null
            or cte_union._source_loaded_at > cte_tm.max_created_at
            )
    {%- endif %}
)
select *,
    current_timestamp()::datetime as _created_at
from cte_incremental
where true
order by effective_date, account_number, market_value
