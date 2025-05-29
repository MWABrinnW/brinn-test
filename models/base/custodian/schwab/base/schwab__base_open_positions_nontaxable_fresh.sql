select
    a.custodian                                         as custodian
    , cl.firm_source                                    as firm_source
    , cf.firm                                           as firm
    , a.record_type                                     as record_type
    , a.custodian_id                                    as custodian_id
    , a.master_account_number                           as master_account_number
    , a.master_account_name                             as master_account_name
    , a.business_date                                   as business_date
    , a.account_number                                  as account_number
    , a.security_type                                   as security_type
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
    , a.current_market_value                            as current_market_value
    , a.accrued_interest_fixed_income                   as accrued_interest_fixed_income
    , a.cost_basis_unamortized_cost_basis_amount        as cost_basis_unamortized_cost_basis_amount
    , a.cost_per_share_share_cost_amount                as cost_per_share_share_cost_amount
    , a.adjusted_cost_basis_amortized_cost_basis_amount as adjusted_cost_basis_amortized_cost_basis_amount
    , a.adjusted_cost_per_share                         as adjusted_cost_per_share
    , a.unrealized_gain_loss_ugl                        as unrealized_gain_loss_ugl
    , a.cost_basis_fully_known                          as cost_basis_fully_known
    , a.cost_basis_type                                 as cost_basis_type
    , a.account_taxable_indicator                       as account_taxable_indicator
    , a.certified_indicator                             as certified_indicator
    , a.original_face                                   as original_face
    , a.account_lot_selection_method_default            as account_lot_selection_method_default
    , a.cost_method                                     as cost_method
    , a.principal_paydown_factor                        as principal_paydown_factor
    , a.master_number                                   as master_number
    , a.is_deceased                                     as is_deceased
    , a.is_from_tda_migration                           as is_from_tda_migration
    , a.effective_date                                  as effective_date
    , dense_rank() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                   as rn
    , dense_rank() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                   as rn_firm_source
    , dense_rank() over (
        partition by a.effective_date , a.account_number
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                   as rn_global
    , {{ col_is_head(reference=source('schwab', 'upn_open_positions_nontaxable')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , current_timestamp()::timestamp_ntz                as _created_at
    , a._source_loaded_at                               as _source_loaded_at
    , a._source_file                                    as _source_file
from {{ source('schwab', 'upn_open_positions_nontaxable') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    and a.effective_date > (select max(t.effective_date) from {{ ref('schwab__base_open_positions_nontaxable_history') }} as t)
