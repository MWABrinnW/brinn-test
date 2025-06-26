select
    system_name
    , system_instance
    , system_key
    , firm_source
    , product_id
    , symbol
    , cusip
    , ticker
    , is_ticker_cusip
    , is_custodial_cash
    , is_product_managed
    , product_name
    , product_type
    , product_subtype
    , product_class_id
    , product_class
    , asset_class
    , product_class_description
    , product_class_category
    , product_class_subcategory
    , product_category_id
    , product_category_abbreviation
    , product_category
    , product_parent_category_abbreviation
    , fkalclient
    , _created_at
    , _source_loaded_at
    , createddate
    , _source_file
from {{ ref('orion__bld_products') }}
