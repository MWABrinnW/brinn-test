select
    effective_date
    , system_name
    , system_instance
    , system_key
    , firm_source
    , account_id
    , account_number_formatted
    , account_number
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
    , market_value
    , quantity
    , price
    , price_unfactored
    , factor
    , cost_basis
    , product_id
    , asset_id
    , is_asset_managed
    , is_product_managed
    , fkalclient
    , _created_at
    , _source_loaded_at
    , createddate
    , _source_file
    , {{ col_is_head(
        reference=ref('orion__bld_holdings'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
from {{ ref('orion__bld_holdings') }}
