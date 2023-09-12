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

{# Check if table exists in the database. If it doesn't we can't run the query to check for new data without failing #}
{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.name) -%}

{%- set table_exists=source_relation is not none -%}

with cte_max_created_at as
(
    {%- if table_exists and is_incremental() -%}
    select max(_created_at) as _created_at from {{ this }}
    {%- else -%}
    select null::timestamp as _created_at
    {%- endif -%}
)
,cte_max_effective_date as
(
    {%- if table_exists and is_incremental() -%}
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
    {#  Capture effective dates where source timestamp is newer than destination max timestamp.
        This should account for a historical date that was reloaded because the _created_at would
        evaluate as newer than the max timestamp in destination. -#}
        _source_loaded_at > nvl((select max(_created_at) from cte_max_created_at), dateadd(d, -1, _source_loaded_at))
        {%- if table_exists and is_incremental() %}
        {# Capture effective dates where source custodian-firm does not exist in destination -#}
        or effective_date > nvl((select effective_date from cte_max_effective_date where custodian = '{{custodian}}' and firm_source = '{{firm_source}}'), '1900-01-01'::date)
        {%- endif -%})

    {%- if not loop.last %}

    union

    {% endif -%}
    {%- endfor %}

    union

    {# ADD CASH #}
    {% for nml_model in source_models_cash -%}
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
    {#  Capture effective dates where source timestamp is newer than destination max timestamp.
        This should account for a historical date that was reloaded because the _created_at would
        evaluate as newer than the max timestamp in destination. -#}
    where true
        and (_source_loaded_at > nvl((select max(_created_at) from cte_max_created_at), dateadd(d, -1, _source_loaded_at))
        {%- if table_exists and is_incremental() %}
        {# Capture effective dates where source custodian-firm does not exist in destination -#}
        or effective_date > nvl((select effective_date from cte_max_effective_date where custodian = '{{custodian}}' and firm_source = '{{firm_source}}'), '1900-01-01'::date)
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
        , null::varchar(50)             as cusip
        , '_CASH_'::varchar(50)         as ticker
        , 1::int                        as is_cash
        , 1::int                        as is_sweep
        , 'CASH'::varchar(200)          as source_security_name
        , cash_value::decimal(15, 2)    as market_value
        , null::decimal(19, 9)          as units_shares
        , null::decimal(19, 9)          as price
        , null::decimal(19, 9)          as price_unfactored
        , null::decimal(19, 9)          as factor
        , null::decimal(19, 9)          as cost_basis
        , null::varchar(100)            as security_type
        , null::varchar(100)            as source_security_type
        , null::varchar(100)            as source_security_type_code
        , null::varchar(100)            as account_type
        , null::varchar(100)            as source_account_type
        , null::varchar(100)            as source_account_type_code
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
    *
    , current_timestamp()::timestamp as _created_at
from cte_holdings