-- depends_on: {{ ref('fidelity_mwa_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_mps_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_swag_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('schwab__base_transactions') }}

{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set source_models = [
          'fidelity_mwa_history__vw_actvyd_activity'
         ,'fidelity_mps_history__vw_actvyd_activity'
         ,'fidelity_swag_history__vw_actvyd_activity'
         ,'fidelity_baystate_history__vw_actvyd_activity'
         ,'schwab__base_transactions'
    ]
-%}

{%-
    set nml_models = [
          'nml_fidelity_mwa_transactions'
         ,'nml_fidelity_mps_transactions'
         ,'nml_fidelity_swag_transactions'
         ,'nml_fidelity_baystate_transactions'
         ,'nml_schwab_transactions'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {% for src_model in source_models -%}
    select effective_date, custodian, firm_source, max(_source_loaded_at) as _created_at, {{"'" ~ src_model ~ "'"}} as model_source
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
    select effective_date, custodian, firm_source from source_summary group by all
    union
    select effective_date, custodian, firm_source from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.custodian       as custodian
        , a.firm_source     as firm_source
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
        and a.firm_source = s.firm_source
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
        and a.firm_source = d.firm_source
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

{% for nml_model in nml_models -%}
    select
        a.* exclude (is_head , is_current)
        , current_timestamp() as _created_at
    from {{ ref(nml_model) }} as a
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and a.effective_date in (select distinct effective_date from dates_to_refresh)

    {%- if not loop.last %}

        union all

    {% endif -%}
{%- endfor %}
