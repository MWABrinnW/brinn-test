-- unions holdings from the masters pipeline, non orion holdings
select
    bh.effective_date
    , bh.system_name
    , bh.system_instance
    , bh.system_key
    , bh.firm_source
    , bh.account_id::text(200) as account_id
    , bh.account_number_formatted
    , bh.account_number
    , bh.client_id
    , bh.client_name
    , bh.custodian
    , bh.cusip
    , bh.ticker
    , bh.is_ticker_cusip
    , bh.is_custodial_cash
    , bh.security_id
    , bh.security_name
    , bh.security_type
    , bh.security_subtype
    , bh.asset_class
    , bh.market_value
    , bh.quantity
    , bh.price
    , bh.price_unfactored
    , bh.factor
    , bh.cost_basis
    , 0::int                   as is_manual_holdings
    , 0::int                   as is_legacy
    , bh._source_loaded_at
    , bh._created_at
from {{ ref('bld_holdings') }} as bh
where true
    and bh.effective_date >= '2025-01-01'
union all
-- unions holdings from the orion pipeline
select
    obh.effective_date
    , obh.system_name
    , obh.system_instance
    , obh.system_key
    , obh.firm_source
    , obh.account_id::text(200) as account_id
    , obh.account_number_formatted
    , obh.account_number
    , obh.household_id          as client_id
    , obh.household_name        as client_name
    , obh.custodian
    , obh.cusip
    , obh.ticker
    , obh.is_ticker_cusip
    , obh.is_custodial_cash
    , obh.product_id            as security_id
    , obh.product_name          as security_name
    , obh.product_type          as security_type
    , obh.product_category      as security_subtype
    , obh.asset_class
    , obh.market_value
    , obh.quantity
    , obh.price
    , obh.price_unfactored
    , obh.factor
    , obh.cost_basis
    , 0::int                    as is_manual_holdings
    , 0::int                    as is_legacy
    , obh._source_loaded_at
    , obh._created_at
from {{ ref('orion__bld_holdings') }} as obh
where true
    and obh.effective_date >= '2025-01-01'
