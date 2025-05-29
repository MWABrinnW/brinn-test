{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{# Set the upstream raw models here and dbt will use them dynamically below.
   We want to use these because when we check for new data they are more performant
   than referencing the temporary nml models.
#}
{%-
    set source_models = [
          'schwab__base_tax_lots'
         ,'schwab__base_securities'
         ,'fidelity_baystate_history__vw_tlaopen_tax_accounting'
         ,'fidelity_mps_history__vw_tlaopen_tax_accounting'
         ,'fidelity_swag_history__vw_tlaopen_tax_accounting'
         ,'fidelity_mwa_history__vw_tlaopen_tax_accounting'
    ]
-%}


{# Set the upstream normalized models here that feed the build. #}
{%-
    set nml_models = [
          'nml_schwab_tax_lots'
         ,'nml_fidelity_mps_tax_lots'
         ,'nml_fidelity_swag_tax_lots'
         ,'nml_fidelity_baystate_tax_lots'
         ,'nml_fidelity_mwa_tax_lots'
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
    group by all
    order by 1,2
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

    union

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
        a.effective_date
        , a.custodian
        , a.firm_source
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
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

-- Grab new data for any effective dates determined to be "fresh".
, data_to_build as (
    {% for nml_model in nml_models -%}
    select
        effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , symbol
        , ticker
        , cusip
        , quantity
        , cost_per_share
        , cost_basis
        , current_price
        , current_value
        , trade_date
        , settlement_date
        , entry_date_source
        , is_cash
        , is_sweep
        , is_short
        , is_wash_sale
        , lot_id_source
        , security_id_source
        , option_ticker
        , option_indicator
        , option_expiration_date
        , option_strike_price
        , isin
        , sedol
        , product_type
        , product_type_source_definition
        , product_type_source_code
        , legacy_product_type
        , legacy_product_type_source_definition
        , legacy_product_type_source_code
        , _source_loaded_at
        , _source_file
        , _extra_fields
    from {{ ref(nml_model) }}
    where 1 = 1
        and effective_date in (select distinct effective_date from dates_to_refresh)
        -- Offer the snowflake query optimizer a chance to prune the query early
        -- if there are no dates to refresh.
        and exists (select 1 from dates_to_refresh)

    {%- if not loop.last %}

    union all

    {% endif -%}
    {% endfor %}
)

select *
    , dense_rank() over(
        partition by effective_date, custodian, account_number
        order by
            {{ firm_source_rank() }})::int as rn_global
    , current_timestamp() as _created_at
from data_to_build
order by effective_date, custodian
