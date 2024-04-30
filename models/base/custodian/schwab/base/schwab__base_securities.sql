-- depends_on: {{ ref('schwab__stg_securities') }}

select
    a.custodian
    , cl.firm_source
    , cf.firm
    , a.record_type
    , a.custodian_id
    , a.master_account_number
    , a.master_account_name
    , a.business_date
    , a.product_code
    , a.product_category_code
    , a.tax_code
    , a.legacy_security_type
    , a.ticker_symbol
    , a.industry_ticker_symbol
    , a.cusip
    , a.schwab_security_number
    , a.re_org_schwab_internal_security_number
    , a.item_issue_id
    , a.rule_set_suffix
    , a.isin
    , a.sedol
    , a.options_display_symbol
    , a.security_description_line_1
    , a.security_description_line_2
    , a.security_description_line_3
    , a.security_description_line_4
    , a.underlying_ticker_symbol
    , a.underlying_industry_ticker_symbol
    , a.underlying_cusip
    , a.underlying_schwab_security_number
    , a.underlying_item_issue_id
    , a.underlying_rule_set_suffix_id
    , a.underlying_isin
    , a.underlying_sedol
    , a.money_market_code
    , a.last_update_date
    , a.sweep_fund_indicator
    , a.closing_price
    , a.security_price_update_date
    , a.security_valuation_unit
    , a.option_root_symbol
    , a.option_expiration_date
    , a.option_call_or_put_code
    , a.strike_price_amount
    , a.interest_rate
    , a.maturity_date
    , a.tips_factor
    , a.asset_backed_factor
    , a.face_value_amount
    , a.issuer_state
    , a.version_marker_number
    , a.schwab_proprietary_indicator
    , a.schwab_one_source_indicator
    , a.version_marker_2
    , a.closing_price_unfactored
    , a.factor
    , a.factor_date
    , a.master_number
    , a.is_deceased
    , a.is_from_tda_migration
    , a.effective_date
    , row_number() over (
        partition by a.effective_date , a.item_issue_id , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn
    , row_number() over (
        partition by a.effective_date , a.item_issue_id , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_firm_source
    , row_number() over (
        partition by a.effective_date , a.item_issue_id
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_global
    , {{ col_is_head(reference=source('schwab', 'sec_securities')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._source_loaded_at
    , a._source_file
from {{ source('schwab', 'sec_securities') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    and is_head = 1
