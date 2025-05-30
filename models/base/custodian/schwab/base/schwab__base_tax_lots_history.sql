{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
)}}

{%- set start_date = '2025-01-01' -%}
{%- set lookback = cvar('lookback') -%}

{# Set the upstream raw models here and dbt will use them dynamically below.
   We want to use these because when we check for new data they are more performant
   than referencing the temporary nml models.
#}
{%-
    set source_models = [
          'schwab__base_open_lots_taxable'
         ,'schwab__base_open_lots_nontaxable'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
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
    select null::date as effective_date, null::text as custodian
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in source_models %}
    select
        effective_date              as effective_date
        , custodian                 as custodian
        , max(_source_loaded_at)    as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
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
    select effective_date, custodian from source_summary group by all
    union
    select effective_date, custodian from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.custodian       as custodian
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

, data_to_build as
(
    select
        a.custodian
        , a.record_type
        , a.custodian_id
        , a.master_account_number
        , a.master_account_name
        , a.business_date
        , a.account_number
        , a.product_code
        , a.product_category_code
        , a.tax_code
        , a.symbol_ticker
        , a.cusip
        , a.schwab_internal_id
        , a.item_issue_id
        , a.isin
        , a.sedol
        , a.options_display_symbol
        , a.underlying_ticker_symbol
        , a.underlying_cusip
        , a.underlying_schwab_internal_id
        , a.underlying_item_issue_id
        , a.underlying_isin
        , a.underlying_sedol
        , a.current_quantity
        , a.long_short_indicator
        , a.transaction_code
        , a.current_market_value
        , a.accrued_interest_fixed_income
        , a.acquired_date
        , a.original_purchase_date
        , a.original_purchase_price
        , a.yield_to_maturity_fixed_income
        , a.cost_basis_unamortized_cost_basis_amount
        , a.cost_per_share_share_cost_amount
        , a.adjusted_cost_basis_amortized_cost_basis_amount
        , a.adjusted_cost_per_share
        , a.unrealized_gain_loss_ugl
        , a.number_of_days_held
        , a.holding_period_term
        , a.cost_basis_fully_known
        , a.cost_basis_type
        , a.account_taxable_indicator
        , a.certified_indicator
        , a.original_face
        , a.account_lot_selection_method_default
        , a.wash_sale_impacted
        , a.version_marker_1
        , a.disallowed_loss
        , a.transaction_cost
        , a.transaction_cost_per_share
        , a.version_marker_2
        , a.acquisition_type_gift_or_inherited
        , a.original_cost_basis
        , a.version_marker_3
        , a.adjusted_cost_including_unpaid_amortization
        , a.master_number
        , a.is_deceased
        , a.is_from_tda_migration
        , a.effective_date
        , a._source_loaded_at
        , a._source_file
    from {{ source('schwab', 'ult_open_lots_taxable') }} as a
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and a.effective_date in (select distinct effective_date from dates_to_refresh)

    union all

    select
        a.custodian
        , a.record_type
        , a.custodian_id
        , a.master_account_number
        , a.master_account_name
        , a.business_date
        , a.account_number
        , a.product_code
        , a.product_category_code
        , a.tax_code
        , a.symbol_ticker
        , a.cusip
        , a.schwab_internal_id
        , a.item_issue_id
        , a.isin
        , a.sedol
        , a.options_display_symbol
        , a.underlying_ticker_symbol
        , a.underlying_cusip
        , a.underlying_schwab_internal_id
        , a.underlying_item_issue_id
        , a.underlying_isin
        , a.underlying_sedol
        , a.current_quantity
        , a.long_short_indicator
        , a.transaction_code
        , a.current_market_value
        , a.accrued_interest_fixed_income
        , a.acquired_date
        , a.original_purchase_date
        , a.original_purchase_price
        , a.yield_to_maturity_fixed_income
        , a.cost_basis_unamortized_cost_basis_amount
        , a.cost_per_share_share_cost_amount
        , a.adjusted_cost_basis_amortized_cost_basis_amount
        , a.adjusted_cost_per_share
        , a.unrealized_gain_loss_ugl
        , a.number_of_days_held
        , a.holding_period_term
        , a.cost_basis_fully_known
        , a.cost_basis_type
        , a.account_taxable_indicator
        , a.certified_indicator
        , a.original_face
        , a.account_lot_selection_method_default
        , a.wash_sale_impacted
        , a.version_marker_1
        , a.disallowed_loss
        , a.transaction_cost
        , a.transaction_cost_per_share
        , a.version_marker_2
        , a.acquisition_type_gift_or_inherited
        , a.original_cost_basis
        , a.version_marker_3
        , a.adjusted_cost_including_unpaid_amortization
        , a.master_number
        , a.is_deceased
        , a.is_from_tda_migration
        , a.effective_date
        , a._source_loaded_at
        , a._source_file
    from {{ source('schwab', 'uln_open_lots_nontaxable') }} as a
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and a.effective_date in (select distinct effective_date from dates_to_refresh)
)

select
    a.custodian                                       as custodian
  , cl.firm_source                                    as firm_source
  , cf.firm                                           as firm
  , a.record_type                                     as record_type
  , a.custodian_id                                    as custodian_id
  , a.master_account_number                           as master_account_number
  , a.master_account_name                             as master_account_name
  , a.business_date                                   as business_date
  , a.account_number                                  as account_number
  , a.product_code                                    as product_code
  , a.product_category_code                           as product_category_code
  , a.tax_code                                        as tax_code
  , a.symbol_ticker                                   as symbol_ticker
  , a.cusip                                           as cusip
  , a.schwab_internal_id                              as schwab_internal_id
  , a.item_issue_id                                   as item_issue_id
  , a.isin                                            as isin
  , a.sedol                                           as sedol
  , a.options_display_symbol                          as options_display_symbol
  , a.underlying_ticker_symbol                        as underlying_ticker_symbol
  , a.underlying_cusip                                as underlying_cusip
  , a.underlying_schwab_internal_id                   as underlying_schwab_internal_id
  , a.underlying_item_issue_id                        as underlying_item_issue_id
  , a.underlying_isin                                 as underlying_isin
  , a.underlying_sedol                                as underlying_sedol
  , a.current_quantity                                as current_quantity
  , a.long_short_indicator                            as long_short_indicator
  , a.transaction_code                                as transaction_code
  , a.current_market_value                            as current_market_value
  , a.accrued_interest_fixed_income                   as accrued_interest_fixed_income
  , a.acquired_date                                   as acquired_date
  , a.original_purchase_date                          as original_purchase_date
  , a.original_purchase_price                         as original_purchase_price
  , a.yield_to_maturity_fixed_income                  as yield_to_maturity_fixed_income
  , a.cost_basis_unamortized_cost_basis_amount        as cost_basis_unamortized_cost_basis_amount
  , a.cost_per_share_share_cost_amount                as cost_per_share_share_cost_amount
  , a.adjusted_cost_basis_amortized_cost_basis_amount as adjusted_cost_basis_amortized_cost_basis_amount
  , a.adjusted_cost_per_share                         as adjusted_cost_per_share
  , a.unrealized_gain_loss_ugl                        as unrealized_gain_loss_ugl
  , a.number_of_days_held                             as number_of_days_held
  , a.holding_period_term                             as holding_period_term
  , a.cost_basis_fully_known                          as cost_basis_fully_known
  , a.cost_basis_type                                 as cost_basis_type
  , a.account_taxable_indicator                       as account_taxable_indicator
  , a.certified_indicator                             as certified_indicator
  , a.original_face                                   as original_face
  , a.account_lot_selection_method_default            as account_lot_selection_method_default
  , a.wash_sale_impacted                              as wash_sale_impacted
  , a.version_marker_1                                as version_marker_1
  , a.disallowed_loss                                 as disallowed_loss
  , a.transaction_cost                                as transaction_cost
  , a.transaction_cost_per_share                      as transaction_cost_per_share
  , a.version_marker_2                                as version_marker_2
  , a.acquisition_type_gift_or_inherited              as acquisition_type_gift_or_inherited
  , a.original_cost_basis                             as original_cost_basis
  , a.version_marker_3                                as version_marker_3
  , a.adjusted_cost_including_unpaid_amortization     as adjusted_cost_including_unpaid_amortization
  , a.master_number                                   as master_number
  , a.is_deceased                                     as is_deceased
  , a.is_from_tda_migration                           as is_from_tda_migration
  , a.effective_date                                  as effective_date
  , a._source_loaded_at                               as _source_loaded_at
  , a._source_file                                    as _source_file
  , dense_rank() over (
    partition by a.effective_date , a.account_number , cl.firm_source
    order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                 as rn
  , dense_rank() over (
    partition by a.effective_date , a.account_number , cl.firm_source
    order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                 as rn_firm_source
  , dense_rank() over (
    partition by a.effective_date , a.account_number
    order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                 as rn_global
  , current_timestamp()::timestamp_ntz                as _created_at
from data_to_build a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
order by a.effective_date, a.custodian
