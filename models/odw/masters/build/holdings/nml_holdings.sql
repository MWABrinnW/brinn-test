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
    , bh.custodian
    , bh.cusip
    , bh.ticker
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
    , obh.custodian
    , obh.cusip
    , obh.ticker
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
union all
-- unions "manual" holdings added by data management
select
    mh.effective_date::date                  as effective_date
    , mh.system_name::varchar(200)           as system_name
    , mh.system_instance::text(200)          as system_instance
    , mh.system_key::text(200)               as system_key
    , mh.firm_source::text(200)              as firm_source
    , mh.account_id::text(200)               as account_id
    , mh.account_number_formatted::text(200) as account_number_formatted
    , mh.account_number::text(200)           as account_number
    , mh.custodian::text(200)                as custodian
    , mh.cusip::text(200)                    as cusip
    , mh.ticker::text(200)                   as ticker
    , mh.is_custodial_cash::int              as is_custodial_cash
    , mh.security_id::number(38 , 5)         as security_id
    , mh.security_name::text(200)            as security_name
    , mh.security_type::text(200)            as security_type
    , mh.security_subtype::text(200)         as security_subtype
    , mh.asset_class::text(200)              as asset_class
    , mh.market_value::float                 as market_value
    , mh.quantity::float                     as quantity
    , mh.price::float                        as price
    , mh.price_unfactored::number(19 , 9)    as price_unfactored
    , mh.factor::number(19 , 9)              as factor
    , mh.cost_basis::float                   as cost_basis
    , mh.is_manual_holdings::int             as is_manual_holdings
    , 0::int                                 as is_legacy
    , mh._created_at::datetime               as _source_loaded_at
    , mh._created_at::datetime               as _created_at
from {{ ref('stg_manual_holdings') }} as mh
union all
-- unions holdings from the legacy masters pipeline prior to 2025
select
    lh.effective_date
    , lh.system_name
    , lh.system_instance
    , lh.system_key
    , lh.firm_source
    , lh.account_id
    , lh.account_number_formatted
    , lh.account_number
    , lh.custodian
    , lh.cusip
    , lh.ticker
    , lh.is_custodial_cash
    , lh.security_id
    , lh.security_name
    , lh.security_type
    , lh.security_subtype
    , lh.asset_class
    , lh.market_value
    , lh.quantity
    , lh.price
    , lh.price_unfactored
    , lh.factor
    , lh.cost_basis
    , lh.is_manual_holdings
    , lh.is_legacy
    , lh._source_loaded_at
    , lh._created_at
from {{ ref('stg_legacy_holdings') }} as lh
order by effective_date , system_key , account_number , market_value
