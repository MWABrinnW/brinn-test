with cte_dates as
(
    select date_key as effective_date
    from {{ ref('dates') }}
    where is_market_day = 1
      and date_key between
        (select min(effective_date) from {{ ref('bld_custodian_holdings') }})
        and
        (select max(effective_date) from {{ ref('bld_custodian_holdings') }})
)
,cte_custodians_spined as
(
    select distinct c.custodian, c.firm_source, cf.firm, d.effective_date
    from {{ ref('custodians') }} c
    left join {{ ref('custodian_firms') }} cf
        on c.firm_source = cf.firm_source
    cross join cte_dates d
)

select
      c.effective_date
    , c.custodian
    , c.firm
    , c.firm_source
    , h.account_number
    , h.account_number_formatted
    , h.symbol
    , h.ticker
    , h.cusip
    , h.security_name
    , h.security_type
    , h.security_name_source
    , h.is_cash
    , h.is_sweep
    , h.market_value
    , h.units_shares
    , h.quantity
    , h.quantity_settled
    , h.quantity_unsettled
    , h.price
    , h.price_unfactored
    , h.factor
    , h.cost_basis
    , h.is_13f
    , h.asset_category
    , h.asset_class
    , h.cusip_security_type
    , h.cusip_fund_type
    , h.cusip_income_type
    , h.underlying_ticker
    , h.underlying_cusip
    , h.underlying_security_id_source
    , h.product_type
    , h.product_type_source_definition
    , h.product_type_source_code
    , h.account_type
    , h.account_type_source
    , h.account_type_source_code
    , h.security_id_source
    , h.isin
    , h.sedol
    , h.extra_fields
    , {{ col_is_head(reference=ref('bld_custodian_holdings'), source_date_col='c.effective_date') }}
    , {{ col_is_current(date_col='c.effective_date') }}
    , h.rn_firm_source
    , h.rn_global
    , h._source_loaded_at
    , h._source_file
    , h._created_at
from cte_custodians_spined c
left join {{ ref('bld_custodian_holdings') }} h
    on c.custodian = h.custodian
    and c.firm_source = h.firm_source
    and c.effective_date = h.effective_date
where true
