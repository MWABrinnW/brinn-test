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
    , ca.account_number
    , ca.account_number_formatted
    , ca.cusip
    , ca.ticker
    , ca.is_cash
    , ca.source_security_name
    , ca.market_value
    , ca.units_shares
    , ca.price
    , ca.price_unfactored
    , ca.cost_basis
    , ca.security_type
    , ca.source_security_type
    , ca.source_security_type_code
    , ca.account_type
    , ca.source_account_type
    , ca.source_account_type_code
    , {{ col_is_head(reference=ref('bld_custodian_holdings'), source_date_col='c.effective_date') }}
    , {{ col_is_current(date_col='c.effective_date') }}
    , ca._source_loaded_at
    , ca._source_file
    , ca._created_at
from cte_custodians_spined c
left join {{ ref('bld_custodian_holdings') }} ca
    on c.custodian = ca.custodian
    and c.firm_source = ca.firm_source
    and c.effective_date = ca.effective_date
where true
