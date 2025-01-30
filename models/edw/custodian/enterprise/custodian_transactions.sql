select
    effective_date
    , custodian
    , firm
    , firm_source
    , account_number
    , account_number_formatted
    , custodian_link
    , custodian_link_detail
    , rep_link
    , rep_link_detail
    , account_type
    , account_type_source_definition
    , account_type_source_code
    , product_type
    , product_type_source_definition
    , product_type_source_code
    , symbol
    , ticker
    , cusip
    , transaction_type_1_source_code
    , transaction_type_2_source_code
    , transaction_type_3_source_code
    , transaction_type_4_source_code
    , transaction_type_5_source_code
    , transaction_date
    , settlement_date
    , entry_date
    , units_shares
    , price
    , gross_amount
    , net_amount
    , commission
    , closing_price
    , closing_price_unfactored
    , factor
    , factor_date
    , is_trade
    , buy_sell
    , debit_credit_indicator
    , trade_executed_at
    , ex_dividend_date
    , is_canceled
    , isin
    , sedol
    , transaction_id_source
    , transaction_id
    , {{ col_is_head(
        reference=ref('bld_custodian_transactions'),
        source_date_col='effective_date'
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at
    , _source_loaded_at
    , _source_file
from {{ ref('bld_custodian_transactions') }}
