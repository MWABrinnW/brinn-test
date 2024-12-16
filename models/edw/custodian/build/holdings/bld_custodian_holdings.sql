--depends_on: {{ ref('nml_fidelity_mps_holdings') }}
--depends_on: {{ ref('nml_fidelity_mwa_holdings') }}
--depends_on: {{ ref('nml_fidelity_swag_holdings') }}
--depends_on: {{ ref('nml_fidelity_baystate_holdings') }}
--depends_on: {{ ref('nml_pershing_mps_holdings') }}
--depends_on: {{ ref('nml_pershing_mwa_holdings') }}
--depends_on: {{ ref('nml_schwab_mps_holdings') }}
--depends_on: {{ ref('nml_schwab_mwa_holdings') }}
--depends_on: {{ ref('nml_schwab_swag_holdings') }}
--depends_on: {{ ref('nml_tda_mwa_holdings') }}
--depends_on: {{ ref('nml_tda_mps_holdings') }}
--depends_on: {{ ref('nml_tda_swag_holdings') }}
--depends_on: {{ ref('nml_fidelitycgf_mps_holdings') }}
--depends_on: {{ ref('nml_fidelitycgf_mwa_holdings') }}
--depends_on: {{ ref('nml_pershing_mps_cash') }}
--depends_on: {{ ref('nml_pershing_mwa_cash') }}
--depends_on: {{ ref('nml_schwab_mps_cash') }}
--depends_on: {{ ref('nml_schwab_mwa_cash') }}
--depends_on: {{ ref('nml_schwab_swag_cash') }}
--depends_on: {{ ref('nml_tda_mwa_cash') }}
--depends_on: {{ ref('nml_tda_mps_cash') }}
--depends_on: {{ ref('nml_tda_swag_cash') }}

{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream raw models here and dbt will use them dynamically below.
   We want to use these because when we check for new data they are more performant
   than referencing the temporary nml models.
#}
{%-
    set source_models = [
          'fidelity_baystate_history__vw_positd_position'
         ,'fidelity_mps_history__vw_positd_position'
         ,'fidelity_swag_history__vw_positd_position'
         ,'fidelity_mwa_history__vw_positd_position'
         ,'schwab__base_positions'
         ,'nml_pershing_mps_holdings'
         ,'nml_pershing_mwa_holdings'
         ,'nml_fidelitycgf_mps_holdings'
         ,'nml_fidelitycgf_mwa_holdings'
         ,'nml_tda_mps_holdings'
         ,'nml_tda_mwa_holdings'
    ]
-%}


{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the holdings/positions from custodians normalized. #}
{%-
    set nml_models_holdings = [
          'nml_fidelity_mps_holdings'
         ,'nml_fidelity_mwa_holdings'
         ,'nml_fidelity_swag_holdings'
         ,'nml_fidelity_baystate_holdings'
         ,'nml_pershing_mps_holdings'
         ,'nml_pershing_mwa_holdings'
         ,'nml_schwab_mps_holdings'
         ,'nml_schwab_mwa_holdings'
         ,'nml_schwab_swag_holdings'
         ,'nml_tda_mwa_holdings'
         ,'nml_tda_mps_holdings'
         ,'nml_tda_swag_holdings'
         ,'nml_fidelitycgf_mps_holdings'
         ,'nml_fidelitycgf_mwa_holdings'
    ]
-%}

{#  Set the upstream cash models here and dbt will use them dynamically below
    These cash models are needed for sources that show cash outside of the
    positions data. #}
{%-
    set nml_models_cash = [
          'nml_pershing_mps_cash'
         ,'nml_pershing_mwa_cash'
         ,'nml_schwab_mps_cash'
         ,'nml_schwab_mwa_cash'
         ,'nml_schwab_swag_cash'
         ,'nml_tda_mwa_cash'
         ,'nml_tda_mps_cash'
         ,'nml_tda_swag_cash'
    ]
-%}

{# Set the sql that checks if data needs loaded! #}
{% set sql_check_status_base -%}
with cte_destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        and effective_date >= (current_date() - {{ cvar('lookback_custodial') }})
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = '1=1'
        ) }}
    group by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

,cte_fresh_sources as (
    {% for src_model in source_models -%}
    select a.custodian, a.firm_source, a.effective_date, {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }} a
    left join cte_destination_summary b
        on a.effective_date = b.effective_date
        and a.custodian = b.custodian
        and a.firm_source = b.firm_source
    where 1=1
        and a.effective_date >= (current_date() - {{ cvar('lookback_custodial') }})
        {{ incremental_date_filter(
            source_col_name='a.effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = '1=1'
        ) }}
        and b.effective_date is null
        and a.firm_source in ('mwa', 'mps', 'swag', 'network', 'baystate')
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {% endfor %}
)

, cte_dates_to_refresh as (
    select distinct effective_date from cte_fresh_sources
)

{% endset -%}

{% set sql_check_status_select -%}
select count(*) as cnt from cte_dates_to_refresh
{% endset -%}

{% set sql -%}
{{sql_check_status_base}}
{{sql_check_status_select}}
{% endset -%}

{%- if execute and is_incremental() -%}
    {%- set results = run_query(sql) -%}
    {%- set results_value = results.rows[0][0] -%}
{%- else -%}
    {% set results_value = 1 -%}
{%- endif -%}


{%- if results_value | int > 0 -%}
{{sql_check_status_base}}

,cte_holdings as
(
    {# ADD HOLDINGS #}
    {% for nml_model in nml_models_holdings -%}
    select *
    from {{ ref(nml_model) }}
    where 1 = (select case when (select count(*) from cte_dates_to_refresh) > 0 then 1 else 0 end)
        and effective_date >= (current_date() - {{ cvar('lookback_custodial') }})
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select effective_date from cte_dates_to_refresh)'
        ) }}

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}

    {# ADD CASH #}
    union all

    {% for nml_model in nml_models_cash -%}
    select
          effective_date                as effective_date
        , custodian                     as custodian
        , firm                          as firm
        , firm_source                   as firm_source
        , account_number                as account_number
        , account_number_formatted      as account_number_formatted
        , '_CASH_'::text(500)           as symbol
        , '_CASH_'::text(500)           as ticker
        , null::text(500)               as cusip
        , 'CASH'::text(500)             as security_name_source
        , 1::int                        as is_cash
        , 1::int                        as is_sweep
        , total_cash_value::decimal(15, 2) as market_value
        , null::decimal(20, 5)          as units_shares
        , null::decimal(20, 5)          as quantity
        , null::decimal(20, 5)          as quantity_settled
        , null::decimal(20, 5)          as quantity_unsettled
        , null::decimal(20, 5)          as price
        , null::decimal(20, 5)          as price_unfactored
        , null::decimal(20, 5)          as factor
        , null::decimal(20, 5)          as cost_basis
        , null::text(500)               as security_id_source
        , null::text(500)               as underlying_ticker
        , null::text(500)               as underlying_cusip
        , null::text(500)               as underlying_security_id_source
        , null::text(500)               as product_type
        , null::text(500)               as product_type_source_definition
        , null::text(500)               as product_type_source_code
        , null::text(500)               as account_type
        , null::text(500)               as account_type_source
        , null::text(500)               as account_type_source_code
        , null::text(500)               as isin
        , null::text(500)               as sedol
        , null::variant                 as extra_fields
        , is_head                       as is_head
        , is_current                    as is_current
        , _source_loaded_at             as _source_loaded_at
        , _source_file                  as _source_file
    from {{ ref(nml_model) }}
    where 1 = (select case when (select count(*) from cte_dates_to_refresh) > 0 then 1 else 0 end)
        and effective_date >= (current_date() - {{ cvar('lookback_custodial') }})
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select effective_date from cte_dates_to_refresh)'
        ) }}

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

select
      h.effective_date
    , h.custodian
    , h.firm
    , h.firm_source
    , h.account_number
    , h.account_number_formatted
    , coalesce(h.symbol, h.ticker, h.cusip) as symbol
    , h.ticker
    , h.cusip
    , coalesce(s.product_name, h.security_name_source) as security_name
    , case
        when s.product_type is not null
            then s.product_type
        when h.product_type_source_definition ilike any ('EQUITY OPTION', 'OPTION INDEX', 'option - %')
            then 'Option'
        else null
        end::text(500)      as security_type
    , h.security_name_source

    , h.is_cash
    , h.is_sweep
    , h.market_value
    , h.units_shares
    , h.quantity
    , h.quantity_settled
    , h.quantity_unsettled
    , h.price
    , h.price_unfactored
    , h.factor
    , h.cost_basis

    , s.is_13f
    , s.asset_category
    , s.asset_class
    , s.cusip_security_type
    , s.cusip_fund_type
    , s.cusip_income_type

    , h.underlying_ticker
    , h.underlying_cusip
    , h.underlying_security_id_source

    , h.product_type
    , h.product_type_source_definition
    , h.product_type_source_code
    , h.account_type
    , h.account_type_source
    , h.account_type_source_code

    , h.security_id_source
    , h.isin
    , h.sedol
    , h.extra_fields
    , h.is_head
    , h.is_current
    , dense_rank() over (partition by h.effective_date, h.custodian, h.account_number, h.firm_source
        order by {{ firm_source_rank(col='h.firm_source') }}
        )                            as rn_firm_source
    , dense_rank() over (partition by h.effective_date, h.custodian, h.account_number
        order by {{ firm_source_rank(col='h.firm_source') }}
        )                            as rn_global
    , h._source_loaded_at
    , h._source_file
    , current_timestamp()::timestamp as _created_at
from cte_holdings h
left join {{ ref('bld_securities') }} s
    on h.cusip = s.cusip

{% else -%}
select *
from {{ this }}
limit 0
{% endif -%}
