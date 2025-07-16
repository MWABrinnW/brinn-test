{{
  config(
    alias = 'holdings' if target.name in ['prod', 'ci'] else none,
    schema = 'enterprise' if target.name in ['prod', 'ci'] else none
    )
}}


select
    a.effective_date
    , a.system_name
    , a.system_instance
    , a.system_key
    , a.firm_source
    , a.account_number_formatted
    , a.account_number
    , a.account_value
    , a.account_id_crm
    , a.account_id_pms
    , a.account_name
    , a.client_id_crm
    , a.client_id_pms
    , a.client_name
    , a.custodian
    , a.account_type
    , a.model_investment_strategy
    , a.aum_classification
    , a.advisor
    , a.discretion_status
    , a.is_active
    , a.opened_date
    , a.closed_date
    , a.location_code
    , a.office_name
    , a.link
    , a.link_type
    , a.link_subtype
    , a.is_market_month_end
    , a.is_market_day
    , a.is_manual_account
    , h.cusip
    , h.ticker
    , h.is_custodial_cash
    , h.security_id
    , h.security_name
    , h.security_type
    , h.security_subtype
    , h.asset_class
    , h.market_value
    , h.quantity
    , h.price
    , h.price_unfactored
    , h.factor
    , h.cost_basis
    , h.is_manual_holdings
    , a.is_legacy
    , {{ col_is_head(
        reference=ref('edw_accounts'),
        source_date_col='a.effective_date',
        reference_date_col='effective_date'
    ) }}
    , h._created_at
from {{ ref('edw_accounts') }} as a
left join {{ ref('bld_holdings') }} as h
    on a.effective_date = h.effective_date
    and a.system_key = h.system_key
    and a.account_number = h.account_number
    and (
        a.system_key != 'axys__granite' and a.account_id_pms = h.account_id
        or a.system_key = 'axys__granite'
    )
order by a.effective_date , a.system_key
