{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream normalized models here and dbt will use them dynamically below #}
{%-
    set source_models = [
          'nml_fidelity_mps_cash'
         ,'nml_fidelity_mwa_cash'
         ,'nml_fidelity_swag_cash'
         ,'nml_schwab_mps_cash'
         ,'nml_schwab_mwa_cash'
         ,'nml_schwab_swag_cash'
         ,'nml_pershing_mwa_cash'
         ,'nml_pershing_mps_cash'
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
,cte_effective_dates_out_of_date as
(
    {% for nml_model in source_models -%}
    {%- set parts = nml_model.split('_') -%}
    {%- set custodian = parts[1] -%}
    {%- set firm_source = parts[2] -%}
    select distinct effective_date, {{"'" ~ nml_model ~ "'"}} as model_source
    from {{ ref(nml_model) }}
    -- Capture effective dates where source timestamp is newer than destination max timestamp.
    -- This should account for a historical date that was reloaded because the _created_at would
    -- evaluate as newer than the max timestamp in destination.
    where _source_loaded_at > nvl((select max(_created_at) from cte_max_created_at), dateadd(d, -1, _source_loaded_at))
        {%- if table_exists and is_incremental() %}
        -- Capture effective dates where source custodian-firm does not exist in destination
        or effective_date not in (select distinct effective_date from {{ this }} where custodian = '{{custodian}}' and firm_source = '{{firm_source}}')
        {%- endif -%}

    {%- if not loop.last %}

    union

    {% endif -%}
    {%- endfor %}
)
,cte_cash as
(
    {% for nml_model in source_models -%}
    select *
        , row_number() over(partition by effective_date, custodian, account_number order by firm_source) as rn
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

select *, current_timestamp()::timestamp as _created_at
from cte_cash
where rn = 1
