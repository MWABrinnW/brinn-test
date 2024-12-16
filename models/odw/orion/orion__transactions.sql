select
    system_name
    , system_instance
    , system_key
    , firm_source
    , account_number
    , custodian
    , account_id
    , account_type
    , account_name
    , date
    , settlement_date
    , created_date
    , edited_date
    , symbol
    , cusip
    , ticker
    , is_ticker_cusip
    , is_custodial_cash
    , product_name
    , product_type
    , product_category
    , asset_class
    , product_id
    , is_asset_managed
    , is_product_managed
    , type_id
    , type_code
    , type_name
    , type_description
    , quantity
    , price
    , amount
    , sign_field
    , notes
    , id
    , asset_id
    , type_cash_offset
    , trade_status
    , trade_status_id
    , fkalclient
    , _created_at
    , _source_loaded_at
    , createddate
    , _source_file
    , case
        when type_name ilike '%buy%'
            then 1
        when type_name ilike '%sell%'
            then 1
        else 0
    end::int       as is_trade
    , case
        when type_name ilike '%buy%'
            then 'buy'
        when type_name ilike '%sell%'
            then 'sell'
    end::text(200) as buy_sell
    , {{ col_is_head(
        reference=ref('orion__bld_transactions'),
        source_date_col='date',
        reference_date_col='date'
        ) }}
from {{ ref('orion__bld_transactions') }}
