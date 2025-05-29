{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
) }}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{# Set the upstream raw models here and dbt will use them dynamically below.
   We want to use these because when we check for new data they are more performant
   than referencing the temporary nml models.
#}
{%-
    set source_models = [
         'nml_fidelitycgf_mps_holdings'
         ,'nml_fidelitycgf_mwa_holdings'
    ]
-%}


{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the holdings/positions from custodians normalized. #}
{%-
    set nml_models_holdings = [
         'nml_fidelitycgf_mps_holdings'
         ,'nml_fidelitycgf_mwa_holdings'
    ]
-%}

{#  Set the upstream cash models here and dbt will use them dynamically below
    These cash models are needed for sources that show cash outside of the
    positions data. #}
{%-
    set nml_models_cash = [
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
        and firm_source not in ('other', 'sma', 'unknown')
    group by all
    order by 1,2
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in source_models %}
    select
        effective_date              as effective_date
        , custodian                 as custodian
        , firm_source               as firm_source
        , max(_source_loaded_at)    as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Exclude auxillary/bunk firm sources because it muddies up the comparison.
        and firm_source not in ('other', 'sma', 'unknown')
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

, data_to_build as
(
    {# ADD HOLDINGS #}
    {% for nml_model in nml_models_holdings -%}
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
        , security_name_source
        , is_cash
        , is_sweep
        , market_value
        , units_shares
        , quantity
        , quantity_settled
        , quantity_unsettled
        , price
        , price_unfactored
        , factor
        , cost_basis
        , security_id_source
        , underlying_ticker
        , underlying_cusip
        , underlying_security_id_source
        , product_type
        , product_type_source_definition
        , product_type_source_code
        , account_type
        , account_type_source
        , account_type_source_code
        , isin
        , sedol
        , extra_fields
        , _source_loaded_at
        , _source_file
    from {{ ref(nml_model) }}
    where 1 = 1
        and effective_date in (select distinct effective_date from dates_to_refresh)
        -- Offer the snowflake query optimizer a chance to prune the query early
        -- if there are no dates to refresh.
        and exists (select 1 from dates_to_refresh)

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}

    {# ADD CASH #}
    {% for nml_model in nml_models_cash -%}

    union all

    select
          effective_date                    as effective_date
        , custodian                         as custodian
        , firm                              as firm
        , firm_source                       as firm_source
        , account_number                    as account_number
        , account_number_formatted          as account_number_formatted
        , '_CASH_'::text                    as symbol
        , '_CASH_'::text                    as ticker
        , null::text                        as cusip
        , 'CASH'::text                      as security_name_source
        , 1::int                            as is_cash
        , 1::int                            as is_sweep
        , total_cash_value::decimal(15, 2)  as market_value
        , null::decimal(20, 5)              as units_shares
        , null::decimal(20, 5)              as quantity
        , null::decimal(20, 5)              as quantity_settled
        , null::decimal(20, 5)              as quantity_unsettled
        , null::decimal(20, 5)              as price
        , null::decimal(20, 5)              as price_unfactored
        , null::decimal(20, 5)              as factor
        , null::decimal(20, 5)              as cost_basis
        , null::text                        as security_id_source
        , null::text                        as underlying_ticker
        , null::text                        as underlying_cusip
        , null::text                        as underlying_security_id_source
        , null::text                        as product_type
        , null::text                        as product_type_source_definition
        , null::text                        as product_type_source_code
        , null::text                        as account_type
        , null::text                        as account_type_source
        , null::text                        as account_type_source_code
        , null::text                        as isin
        , null::text                        as sedol
        , null::variant                     as extra_fields
        , _source_loaded_at                 as _source_loaded_at
        , _source_file                      as _source_file
    from {{ ref(nml_model) }}
    where 1 = 1
        and effective_date in (select distinct effective_date from dates_to_refresh)
        -- Offer the snowflake query optimizer a chance to prune the query early
        -- if there are no dates to refresh.
        and exists (select 1 from dates_to_refresh)

    {%- endfor %}
)

select
    h.effective_date                                 as effective_date
  , h.custodian                                      as custodian
  , h.firm                                           as firm
  , h.firm_source                                    as firm_source
  , h.account_number                                 as account_number
  , h.account_number_formatted                       as account_number_formatted
  , coalesce(h.symbol, h.ticker, h.cusip)            as symbol
  , h.ticker                                         as ticker
  , h.cusip                                          as cusip
  , coalesce(s.product_name, h.security_name_source) as security_name
  , case
        when s.product_type is not null
            then s.product_type
        when h.product_type_source_definition ilike any ('EQUITY OPTION', 'OPTION INDEX', 'option - %')
            then 'Option'
        else null
        end::text                                    as security_type
  , h.security_name_source                           as security_name_source

  , h.is_cash                                        as is_cash
  , h.is_sweep                                       as is_sweep
  , h.market_value::decimal(38 , 12)                 as market_value
  , h.units_shares::decimal(22 , 7)                  as units_shares
  , h.quantity::decimal(22 , 7)                      as quantity
  , h.quantity_settled::decimal(22 , 7)              as quantity_settled
  , h.quantity_unsettled::decimal(22 , 7)            as quantity_unsettled
  , h.price::decimal(38 , 12)                        as price
  , h.price_unfactored::decimal(22 , 7)              as price_unfactored
  , h.factor::decimal(22 , 7)                        as factor
  , h.cost_basis::decimal(24 , 9)                    as cost_basis

  , s.is_13f::int                                    as is_13f
  , s.asset_category                                 as asset_category
  , s.asset_class                                    as asset_class
  , s.cusip_security_type                            as cusip_security_type
  , s.cusip_fund_type                                as cusip_fund_type
  , s.cusip_income_type                              as cusip_income_type
  , h.underlying_ticker                              as underlying_ticker
  , h.underlying_cusip                               as underlying_cusip
  , h.underlying_security_id_source                  as underlying_security_id_source
  , h.product_type                                   as product_type
  , h.product_type_source_definition                 as product_type_source_definition
  , h.product_type_source_code                       as product_type_source_code
  , h.account_type                                   as account_type
  , h.account_type_source                            as account_type_source
  , h.account_type_source_code                       as account_type_source_code
  , h.security_id_source                             as security_id_source
  , h.isin                                           as isin
  , h.sedol                                          as sedol
  , h.extra_fields                                   as extra_fields
  , dense_rank() over (partition by h.effective_date, h.custodian, h.account_number, h.firm_source
    order by {{ firm_source_rank(col='h.firm_source') }}
    )                                                as rn_firm_source
  , dense_rank() over (partition by h.effective_date, h.custodian, h.account_number
    order by {{ firm_source_rank(col='h.firm_source') }}
    )                                                as rn_global
  , h._source_loaded_at                              as _source_loaded_at
  , h._source_file                                   as _source_file
  , current_timestamp()::timestamp_ntz               as _created_at
from data_to_build                    h
left join {{ ref('bld_securities') }} s
    on h.cusip = s.cusip
