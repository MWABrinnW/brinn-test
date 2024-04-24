with cte_dates as (
    select date_key as effective_date
    from {{ ref('dates') }}
    where is_market_day = 1
        and date_key between
        (select min(effective_date) from {{ ref('bld_custodian_tax_lots') }})
        and
        (select max(effective_date) from {{ ref('bld_custodian_tax_lots') }})
)

, cte_custodians_spined as (
    select distinct
        c.custodian
        , c.firm_source
        , cf.firm
        , d.effective_date
    from {{ ref('custodians') }} as c
    left join {{ ref('custodian_firms') }} as cf
        on c.firm_source = cf.firm_source
    cross join cte_dates as d
)

select
    c.effective_date
    , c.custodian
    , c.firm
    , c.firm_source
    , bctl.account_number
    , bctl.account_number_formatted
    , bctl.symbol
    , bctl.ticker
    , bctl.cusip
    , bctl.quantity
    , bctl.cost_per_share
    , bctl.cost_basis
    , bctl.current_price
    , bctl.current_value
    , bctl.trade_date
    , bctl.settlement_date
    , bctl.entry_date_source
    , bctl.is_cash
    , bctl.is_sweep
    , bctl.is_short
    , bctl.is_wash_sale
    , bctl.lot_id_source
    , bctl.security_id_source
    , bctl.option_ticker
    , bctl.option_indicator
    , bctl.option_expiration_date
    , bctl.option_strike_price
    , bctl.isin
    , bctl.sedol
    , bctl.product_type
    , bctl.product_type_source_definition
    , bctl.product_type_source_code
    , bctl.legacy_product_type
    , bctl.legacy_product_type_source_definition
    , bctl.legacy_product_type_source_code
    , {{ col_is_head(reference='cte_custodians_spined', source_date_col='c.effective_date') }}
    , {{ col_is_current(date_col='c.effective_date') }}
    , bctl.rn_global
    , bctl._extra_fields
    , bctl._source_loaded_at
    , bctl._source_file
    , bctl._created_at
from cte_custodians_spined as c
left join {{ ref('bld_custodian_tax_lots') }} as bctl
    on c.custodian = bctl.custodian
    and c.firm_source = bctl.firm_source
    and c.effective_date = bctl.effective_date
