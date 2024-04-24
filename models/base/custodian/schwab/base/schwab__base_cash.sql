-- depends_on: {{ ref('schwab__stg_cash') }}

select
    a.custodian
    , cl.firm_source
    , cf.firm
    , a.record_type
    , a.custodian_id
    , a.master_account_number
    , a.master_account_name
    , a.business_date
    , a.account_number
    , a.account_title_line_1
    , a.account_title_line_2
    , a.account_title_line_3
    , a.account_registration
    , a.account_type
    , a.net_credit_or_debit_settled_unsettled
    , a.margin_balance_settled_unsettled
    , a.total_available_to_pay
    , a.margin_buying_power
    , a.money_market_funds_settled_unsettled
    , a.mtd_margin_interest
    , a.daily_margin_interest
    , a.equity_excluding_options
    , a.equity_percentage
    , a.market_value_long
    , a.market_value_short
    , a.equity_including_options
    , a.option_requirements
    , a.month_end_dividend_payout
    , a.maintenance_call
    , a.mvl_cash_account_excluding_options
    , a.net_market_value_positions_only
    , a.net_market_value_positions_plus_cash_and_money_market
    , a.cash_balance_settled_only
    , a.cash_margin_balance_settled_only
    , a.version_marker_3
    , a.bank_sweep_interest_bearing_feature
    , a.master_number
    , a.is_deceased
    , a.is_from_tda_migration
    , a.effective_date
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_firm_source
    , row_number() over (
        partition by a.effective_date , a.account_number
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_global
    , {{ col_is_head(reference=source('schwab', 'rps_cash')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._source_loaded_at
    , a._source_file
from {{ source('schwab', 'rps_cash') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
