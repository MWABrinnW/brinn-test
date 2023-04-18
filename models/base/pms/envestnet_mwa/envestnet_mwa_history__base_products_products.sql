select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , product_id
    , product_name
    , manager_name
    , product_type_id
    , tax_efficiency
    , risk_rating
    , last_model_change_date
    , status
    , imr_status
    , account_minimum
    , style_type
    , currency
    , portfolio_id
    , portfolio_name
    , manager_firm_id
    , manager_firm_name
    , sleeve_security_id
    , dashboard_product_type
    , product_class_id
    , pricing_tier
    , {{ col_is_head(reference=source('envestnet_mwa', 'products_products')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'products_products') }}


