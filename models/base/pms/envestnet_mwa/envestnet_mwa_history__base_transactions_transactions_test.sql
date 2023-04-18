select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , transaction_id
    , account_id
    , account_number
    , transaction_type
    , security_id
    , cusip
    , ticker
    , transaction_description
    , transaction_date
    , transaction_amount
    , transaction_units
    , commission
    , deleted_flag
    , settlement_date
    , sec_fee
    , postage_fee
    , clearing_fee
    , exchange_fee
    , ticket_charge
    , handling_fee
    , redemption_fee
    , deferred_sales_load_fee
    , concession
    , accrued_interest
    , owning_rep_id
    , executing_rep_id
    , posted_date
    , transaction_mapping_id
    , exchange_id
    , revenue_concession
    , execution_price
    , security_type
    , security_style
    , trade_currency
    , settlement_currency
    , sales_charge_percentage
    , external_transaction_id
    , {{ col_is_head(reference=source('envestnet_mwa', 'transactions_transactions_test')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'transactions_transactions_test') }}


