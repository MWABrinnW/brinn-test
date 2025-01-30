select
    effective_date
    , custodian
    , account_number
    , account_number_formatted
    , crm_account_number
    , pms_account_id
    , is_active
    , symbol
    , ticker
    , cusip
    , is_custodial_cash
    , quantity
    , current_price
    , current_value
    , current_price_raw
    , current_value_raw
    , current_price_unfactored
    , current_value_unfactored
    , factor
    , cost_per_share
    , cost_basis
    , acquired_date
    , product_name
    , product_type
    , asset_class
    , product_category
    , product_id
    , asset_id
    , is_asset_managed
    , lot_id
    , is_perform
    , is_moxy
    , is_intraday_import
    , _created_at
from {{ ref('mis__tax_lots_api') }}
