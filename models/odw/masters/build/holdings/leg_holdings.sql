-- unions holdings from the masters pipeline, non orion holdings
select
    bh.effective_date             as effective_date
    , bh.system_name              as system_name
    , bh.system_instance          as system_instance
    , bh.system_key               as system_key
    , bh.firm_source              as firm_source
    , bh.account_id::text(200)    as account_id
    , bh.account_number_formatted as account_number_formatted
    , bh.account_number           as account_number
    , bh.client_id                as client_id
    , bh.client_name              as client_name
    , bh.custodian                as custodian
    , bh.cusip                    as cusip
    , bh.ticker                   as ticker
    , bh.is_ticker_cusip          as is_ticker_cusip
    , bh.is_custodial_cash        as is_custodial_cash
    , bh.security_id              as security_id
    , bh.security_name            as security_name
    , bh.security_type            as security_type
    , bh.security_subtype         as security_subtype
    , bh.asset_class              as asset_class
    , bh.market_value             as market_value
    , bh.quantity                 as quantity
    , bh.price                    as price
    , bh.price_unfactored         as price_unfactored
    , bh.factor                   as factor
    , bh.cost_basis               as cost_basis
    , 0::int                      as is_manual_holdings
    , 0::int                      as is_legacy
    , bh._source_loaded_at        as _source_loaded_at
    , bh._created_at              as _created_at
from {{ ref('bld_holdings') }} as bh
where true
    and bh.effective_date >= '2025-01-01'
union all
-- unions holdings from the orion pipeline
select
    obh.effective_date             as effective_date
    , obh.system_name              as system_name
    , obh.system_instance          as system_instance
    , obh.system_key               as system_key
    , obh.firm_source              as firm_source
    , obh.account_id::text(200)    as account_id
    , obh.account_number_formatted as account_number_formatted
    , obh.account_number           as account_number
    , obh.household_id             as client_id
    , obh.household_name           as client_name
    , obh.custodian                as custodian
    , obh.cusip                    as cusip
    , obh.ticker                   as ticker
    , obh.is_ticker_cusip          as is_ticker_cusip
    , obh.is_custodial_cash        as is_custodial_cash
    , obh.product_id               as security_id
    , obh.product_name             as security_name
    , obh.product_type             as security_type
    , obh.product_category         as security_subtype
    , obh.asset_class              as asset_class
    , obh.market_value             as market_value
    , obh.quantity                 as quantity
    , obh.price                    as price
    , obh.price_unfactored         as price_unfactored
    , obh.factor                   as factor
    , obh.cost_basis               as cost_basis
    , 0::int                       as is_manual_holdings
    , 0::int                       as is_legacy
    , obh._source_loaded_at        as _source_loaded_at
    , obh._created_at              as _created_at
from {{ ref('orion__bld_holdings') }} as obh
where true
    and obh.effective_date >= '2025-01-01'
