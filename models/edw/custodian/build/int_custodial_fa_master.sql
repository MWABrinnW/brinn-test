{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream normalized models here and dbt will use them dynamically below #}
{%-
    set source_models = [
         'nml_schwab_mwa_accounts',
         'nml_schwab_mps_accounts',
         'nml_fidelity_mwa_accounts',
         'nml_fidelity_mps_accounts',
         'nml_lpl_network_accounts'
    ]
-%}

with cte_max_created_at as
(
    select max(_created_at) as _created_at from {{ this }}
)
,cte_effective_dates_out_of_date as
(
    {% for nml_model in source_models -%}
    select distinct effective_date
    from {{ ref(nml_model) }}
    where _created_at > (select max(_created_at) from cte_max_created_at)

    {%- if not loop.last %}
    
    union

    {% endif -%}
    {%- endfor %}
)
,cte_accounts as
(
    {% for nml_model in source_models -%}
    select * exclude _created_at
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
from cte_accounts
