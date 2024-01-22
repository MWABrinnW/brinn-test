{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream normalized models here and dbt will use them dynamically below #}
{%-
    set source_models = [
          'nml_schwab_mwa_accounts'
         ,'nml_schwab_mps_accounts'
         ,'nml_schwab_swag_accounts'
         ,'nml_fidelity_baystate_accounts'
         ,'nml_fidelity_mwa_accounts'
         ,'nml_fidelity_mps_accounts'
         ,'nml_fidelity_swag_accounts'
         ,'nml_pershing_mwa_accounts'
         ,'nml_pershing_mps_accounts'
         ,'nml_tda_mwa_accounts'
         ,'nml_tda_mps_accounts'
         ,'nml_tda_swag_accounts'
         ,'nml_fidelitycgf_mwa_accounts'
         ,'nml_fidelitycgf_mps_accounts'
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
    where _created_at > nvl((select max(_created_at) from cte_max_created_at), dateadd(d, -1, _created_at))


    {%- if is_incremental() %}

    union

    select distinct effective_date, {{"'" ~ nml_model ~ "'"}} as model_source
    from {{ ref(nml_model) }}
    where effective_date not in (select distinct effective_date from {{ this }} where replace(custodian,'-','') = '{{custodian}}' and firm_source = '{{firm_source}}')
    {%- endif -%}

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
,cte_cash as
(
    select
          effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , total_cash_value::decimal(20, 2)   as cash_value
        , money_market_value::decimal(17, 2) as money_market_value
    from {{ ref('bld_custodian_cash_balances') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}
)
,cte_holdings as
(
    select
          effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , sum(nvl(market_value,0))::decimal(17, 2)  as total_value
        , sum(case
                when nvl(is_cash,0) = 0
                then nvl(market_value,0)
                else 0 end)::decimal(17, 2)         as holdings_value
        , sum(case
                when nvl(is_cash,0) = 1
                then nvl(market_value,0)
                else 0 end)::decimal(17, 2)         as cash_value
    from {{ ref('bld_custodian_holdings') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}
    group by effective_date, custodian, firm, firm_source
            , account_number, account_number_formatted
)
,cte_accounts_with_values as
(
    select
          a.effective_date
        , a.custodian
        , a.firm
        , a.firm_source
        , a.account_number
        , a.account_number_formatted
        , a.custodian_link
        , a.custodian_link_detail
        , a.rep_link
        , a.rep_link_detail
        , h.total_value                         as total_value
        , h.cash_value                          as cash_value
        , a.account_type
        , a.account_type_source_definition
        , a.account_type_source_code
        , a.opened_date
        , a.account_title
        , a.first_name
        , a.middle_name
        , a.last_name
        , a.irs_id
        , a.irs_id_type
        , a.birth_date
        , a.email_address
        , a.phone
        , a.cost_basis_method_mutual_funds
        , a.cost_basis_method_non_mutual_funds
        , a.is_taxable
        , a.is_fee_authorized
        , a.is_prime_broker
        , a.restrictions_source_code
        , a.restrictions_source_definition
        , a.restrictions
        , a.mailing_address_street
        , a.mailing_address_city
        , a.mailing_address_state
        , a.mailing_address_zip
        , a.legal_address_street
        , a.legal_address_city
        , a.legal_address_state
        , a.legal_address_zip
        , a.legal_address_country
        , a.is_head
        , a.is_current
        , a._source_loaded_at
        , a._source_file
    from cte_accounts a
    left join cte_holdings h
        on a.effective_date = h.effective_date
        and a.custodian = h.custodian
        and a.firm_source = h.firm_source
        and a.account_number = h.account_number
)

select
    *
    , row_number() over(partition by effective_date, custodian, firm_source, account_number order by _source_loaded_at desc) as rn_firm_source
    , row_number() over(partition by effective_date, custodian, account_number
                    order by case
                        when firm_source = 'mwa'
                            then 1
                        when firm_source = 'baystate'
                            then 2
                        when firm_source = 'mps'
                            then 3
                        when firm_source = 'swag'
                            then 4
                        when firm_source = 'network'
                            then 5
                        else 6
                        end asc
                    )                as rn_global
    , current_timestamp()::timestamp as _created_at
from cte_accounts_with_values
