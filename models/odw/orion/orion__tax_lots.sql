select
    effective_date
    , system_name
    , system_instance
    , system_key
    , firm_source
    , account_id
    , account_number
    , account_number_formatted
    , household_id
    , household_name
    , custodian
    , symbol
    , cusip
    , ticker
    , is_ticker_cusip
    , is_custodial_cash
    , product_name
    , product_type
    , product_category
    , asset_class
    , lot_quantity
    , current_price
    , lot_value
    , factor
    , is_asset_managed
    , is_product_managed
    , acquired_date
    , cost_basis
    , cost_per_share
    , pending_value
    , pending_shares
    , aggregate_lot_quantity
    , aggregate_asset_quantity
    , aggregate_lot_value
    , aggregate_asset_value
    , is_quantity_match
    , is_value_match
    , product_id
    , asset_id
    , lot_id
    , fkalclient
    , last_recon_date
    , expected_recon_date
    , extra_fields
    , createddate
    , _created_at
    , _extracted_at
    , _source_loaded_at
    , _source_file
    , {{ col_is_head(
        reference=ref('orion__bld_tax_lots'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
from {{ ref('orion__bld_tax_lots') }}
