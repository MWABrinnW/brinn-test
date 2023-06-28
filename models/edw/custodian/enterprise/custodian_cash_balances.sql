{{ config(enabled = false) }}
select
     effective_date
    ,custodian
    ,firm
    ,firm_source
    ,account_number
    ,account_number_formatted
    ,cash_value
    ,money_market_value
    ,option_market_value
    ,margin_equity_value
    ,{{ col_is_head(reference=ref('bld_custodian_cash_balances'), reference_date_col='effective_date', source_date_col='effective_date') }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,_source_file
    ,_source_loaded_at
    ,_created_at
from {{ ref('bld_custodian_cash_balances') }}