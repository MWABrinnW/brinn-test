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
    , symbol
    , ticker
    , cusip
    , transaction_date
    , settlement_date
    , entry_date
    , buy_sell
    , units_shares
    , price
    , gross_amount
    , net_amount
    , commission
    , closing_price
    , closing_price_unfactored
    , factor
    , factor_date
    , debit_credit_indicator
    , trade_executed_at
    , is_canceled
    , isin
    , sedol
    , transaction_id_source
    , transaction_id
    , product_type
    , product_type_source_definition
    , product_type_source_code
    , _source_loaded_at as last_collected_at
    , is_in_sod
    , is_in_allocations
from {{ ref('flyer__custodian_trades') }}
where 1 = 1
    and (is_in_sod = 1 or is_in_allocations = 1)
