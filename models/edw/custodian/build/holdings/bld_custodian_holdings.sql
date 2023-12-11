{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the holdings/positions from custodians normalized. #}
{%-
    set source_models_holdings = [
          'nml_fidelity_mps_holdings'
         ,'nml_fidelity_mwa_holdings'
         ,'nml_fidelity_swag_holdings'
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
    set source_models_cash = [
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

with cte_max_created_at as
(
    {%- if is_incremental() -%}
    select max(_created_at) as _created_at from {{ this }}
    {%- else -%}
    select null::timestamp as _created_at
    {%- endif -%}
)
{# ,cte_max_effective_date as
(
    {%- if is_incremental() -%}
    select
          replace(custodian,'-','')                     as custodian
        , firm_source                                   as firm_source
        , nvl(max(effective_date),'1900-01-01'::date)   as effective_date
    from {{ this }}
    group by 1,2
    {%- else -%}
    select
          null::text(100) as custodian
        , null::text(100) as firm_source
        , null::date      as effective_date
    {%- endif -%}
) #}
,cte_destination_effective_dates as
(
    {%- if is_incremental() -%}
    select distinct effective_date
    from {{ this }}
    where effective_date >= current_date() - {{ var('lookback_custodial', 30) }}
    {%- else -%}
    select null::date      as effective_date
    {%- endif -%}
)
,cte_effective_dates_out_of_date as
(
    {% for nml_model in source_models_holdings -%}
    {%- set parts = nml_model.split('_') -%}
    {%- set custodian = parts[1] -%}
    {%- set firm_source = parts[2] -%}
    select effective_date, model_source, _source_loaded_at
    from (
        select effective_date, {{"'" ~ nml_model ~ "'"}} as model_source, max(_source_loaded_at) as _source_loaded_at
        from {{ ref(nml_model) }}
        where effective_date >= current_date() - {{ var('lookback_custodial', 30) }}
        group by 1, 2
        )
    where true
        and (
        -- Capture effective dates where source timestamp is newer than destination max timestamp.
        -- ~~This should account for a historical date that was reloaded because the _created_at would
        -- evaluate as newer than the max timestamp in destination.~~
        -- If a custodian is loaded after the first build for an effective_date, we would still
        -- expect for it to get picked up because the _source_loaded_at should be greater
        -- than the max(_created_at) of the destination ({{this}}).
        _source_loaded_at > nvl((select max(_created_at) from cte_max_created_at), dateadd(d, -1, _source_loaded_at))
        {%- if is_incremental() %}

        -- Capture effective dates where source custodian-firm does not exist in destination -
        -- or effective_date > nvl((select effective_date from cte_max_effective_date where custodian = '{{custodian}}' and firm_source = '{{firm_source}}'), '1900-01-01'::date)

        -- Detect effective dates that exist in the source but not destination.
        or effective_date not in (select effective_date from cte_destination_effective_dates)
        {%- endif -%})

    {%- if not loop.last %}

    union

    {% endif -%}
    {%- endfor %}
)
,cte_holdings as
(
    {# ADD HOLDINGS #}
    {% for nml_model in source_models_holdings -%}
    select *
    from {{ ref(nml_model) }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}

    {# ADD CASH #}
    union all

    {% for nml_model in source_models_cash -%}
    select
          effective_date                as effective_date
        , custodian                     as custodian
        , firm                          as firm
        , firm_source                   as firm_source
        , account_number                as account_number
        , account_number_formatted      as account_number_formatted
        , '_CASH_'::text(200)           as symbol
        , '_CASH_'::text(200)           as ticker
        , null::text(200)               as cusip
        , 'CASH'::text(200)             as security_name_source
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
        , null::text(200)               as security_id_source
        , null::text(200)               as underlying_ticker
        , null::text(200)               as underlying_cusip
        , null::text(200)               as underlying_security_id_source
        , null::text(200)               as product_type
        , null::text(200)               as product_type_source_definition
        , null::text(200)               as product_type_source_code
        , null::text(200)               as account_type
        , null::text(200)               as account_type_source
        , null::text(200)               as account_type_source_code
        , null::text(200)               as isin
        , null::text(200)               as sedol
        , null::variant                 as extra_fields
        , is_head                       as is_head
        , is_current                    as is_current
        , _source_loaded_at             as _source_loaded_at
        , _source_file                  as _source_file
    from {{ ref(nml_model) }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
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
        end::text(200)      as security_type
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
        order by case
            when h.firm_source = 'mwa'
                then 1
            when h.firm_source = 'mps'
                then 2
            when h.firm_source = 'swag'
                then 3
            when h.firm_source = 'network'
                then 4
            else 5
            end asc
        )                            as rn_firm_source
    , dense_rank() over (partition by h.effective_date, h.custodian, h.account_number
        order by case
            when h.firm_source = 'mwa'
                then 1
            when h.firm_source = 'mps'
                then 2
            when h.firm_source = 'swag'
                then 3
            when h.firm_source = 'network'
                then 4
            else 5
            end asc
        )                            as rn_global
    , h._source_loaded_at
    , h._source_file
    , current_timestamp()::timestamp as _created_at
from cte_holdings h
left join {{ ref('bld_securities') }} s
    on h.cusip = s.cusip
