select
    'schwab'                                                                              as custodian
    , cl.firm_source                                                                      as firm_source
    , cf.firm                                                                             as firm
    , nullif(trim(substring(a.content , 1 , 2)) , '')::text(200)                          as record_type
    , nullif(trim(substring(a.content , 4 , 8)) , '')::text(200)                          as custodian_id
    , right(nullif(trim(substring(a.content , 13 , 10)) , '')::text(200) , 8)             as master_account_number
    , nullif(trim(substring(a.content , 24 , 30)) , '')::text(200)                        as master_account_name
    , to_date(nullif(trim(substring(a.content , 55 , 8)) , '')::text(200) , 'YYYYMMDD')   as business_date
    , right(nullif(trim(substring(a.content , 64 , 10)) , '')::text(200) , 8)             as account_number
    , nullif(trim(substring(a.content , 75 , 45)) , '')::text(200)                        as account_title_line_1
    , nullif(trim(substring(a.content , 121 , 45)) , '')::text(200)                       as account_title_line_2
    , nullif(trim(substring(a.content , 167 , 45)) , '')::text(200)                       as account_title_line_3
    , nullif(trim(substring(a.content , 213 , 5)) , '')::text(200)                        as account_registration
    , nullif(trim(substring(a.content , 219 , 5)) , '')::text(200)                        as account_type
    , nullif(trim(substring(a.content , 225 , 4)) , '')::text(200)                        as product_code
    , nullif(trim(substring(a.content , 230 , 8)) , '')::text(200)                        as product_category_code
    , nullif(trim(substring(a.content , 239 , 8)) , '')::text(200)                        as tax_code
    , nullif(trim(substring(a.content , 248 , 2)) , '')::text(200)                        as legacy_security_type
    , nullif(trim(substring(a.content , 251 , 30)) , '')::text(200)                       as ticker_symbol
    , nullif(trim(substring(a.content , 282 , 30)) , '')::text(200)                       as industry_ticker_symbol
    , nullif(trim(substring(a.content , 313 , 9)) , '')::text(200)                        as cusip
    , nullif(trim(substring(a.content , 323 , 7)) , '')::text(200)                        as schwab_security_number
    , nullif(trim(substring(a.content , 331 , 10)) , '')::text(200)                       as item_issue_id
    , nullif(trim(substring(a.content , 342 , 5)) , '')::text(200)                        as rule_set_suffix_id
    , nullif(trim(substring(a.content , 348 , 12)) , '')::text(200)                       as isin
    , nullif(trim(substring(a.content , 361 , 7)) , '')::text(200)                        as sedol
    , nullif(trim(substring(a.content , 369 , 30)) , '')::text(200)                       as options_display_symbol
    , nullif(trim(substring(a.content , 400 , 30)) , '')::text(200)                       as underlying_ticker_symbol
    , nullif(trim(substring(a.content , 431 , 30)) , '')::text(200)                       as underlying_industry_ticker_symbol
    , nullif(trim(substring(a.content , 462 , 9)) , '')::text(200)                        as underlying_cusip
    , nullif(trim(substring(a.content , 472 , 7)) , '')::text(200)                        as underlying_schwab_security_number
    , nullif(trim(substring(a.content , 480 , 10)) , '')::text(200)                       as underlying_item_issue_id
    , nullif(trim(substring(a.content , 491 , 5)) , '')::text(200)                        as underlying_rule_set_suffix_id
    , nullif(trim(substring(a.content , 497 , 12)) , '')::text(200)                       as underlying_isin
    , nullif(trim(substring(a.content , 510 , 7)) , '')::text(200)                        as underlying_sedol
    , nullif(trim(substring(a.content , 518 , 5)) , '')::text(200)                        as money_market_code
    , nullif(trim(substring(a.content , 524 , 2)) , '')::text(200)                        as transaction_type_code
    , nullif(trim(substring(a.content , 527 , 2)) , '')::text(200)                        as transaction_sub_type_code
    , nullif(trim(substring(a.content , 530 , 24)) , '')::text(200)                       as transaction_category
    , nullif(trim(substring(a.content , 555 , 5)) , '')::text(200)                        as transaction_source_code
    , nullif(trim(substring(a.content , 561 , 18)) , '')::text(200)                       as transaction_source_code_description
    , nullif(trim(substring(a.content , 580 , 80)) , '')::text(200)                       as transaction_detail_description
    , nullif(trim(substring(a.content , 661 , 6)) , '')::text(200)                        as action_code
    , nullif(trim(substring(a.content , 668 , 1)) , '')::text(200)                        as transaction_cancel_code
    , to_date(nullif(trim(substring(a.content , 670 , 8)) , '')::text(200) , 'YYYYMMDD')  as trade_date
    , to_date(nullif(trim(substring(a.content , 679 , 8)) , '')::text(200) , 'YYYYMMDD')  as settlement_date
    , to_date(nullif(trim(substring(a.content , 688 , 8)) , '')::text(200) , 'YYYYMMDD')  as transaction_date
    , to_date(nullif(trim(substring(a.content , 697 , 8)) , '')::text(200) , 'YYYYMMDD')  as ex_dividend_date
    , nullif(trim(substring(a.content , 706 , 17)) , '')::decimal(20 , 5)                 as quantity
    , nullif(trim(substring(a.content , 724 , 17)) , '')::decimal(20 , 5)                 as price
    , nullif(trim(substring(a.content , 742 , 17)) , '')::decimal(20 , 5)                 as gross_amount
    , nullif(trim(substring(a.content , 760 , 6)) , '')::text(200)                        as debit_credit_indicator
    , nullif(trim(substring(a.content , 767 , 17)) , '')::decimal(20 , 5)                 as net_amount
    , nullif(trim(substring(a.content , 785 , 17)) , '')::decimal(20 , 5)                 as commission
    , nullif(trim(substring(a.content , 803 , 17)) , '')::decimal(20 , 5)                 as exchange_processing_fee
    , nullif(trim(substring(a.content , 821 , 17)) , '')::decimal(20 , 5)                 as broker_service_fee
    , nullif(trim(substring(a.content , 839 , 17)) , '')::decimal(20 , 5)                 as prime_broker_fee
    , nullif(trim(substring(a.content , 857 , 17)) , '')::decimal(20 , 5)                 as trade_away_fee
    , nullif(trim(substring(a.content , 875 , 17)) , '')::decimal(20 , 5)                 as redemption_fee
    , nullif(trim(substring(a.content , 893 , 17)) , '')::decimal(20 , 5)                 as other_fee
    , nullif(trim(substring(a.content , 911 , 17)) , '')::decimal(20 , 5)                 as federal_tefra_withholding
    , nullif(trim(substring(a.content , 929 , 17)) , '')::decimal(20 , 5)                 as state_tax_withholding
    , nullif(trim(substring(a.content , 947 , 2)) , '')::text(200)                        as state_receiving_tax
    , nullif(trim(substring(a.content , 950 , 17)) , '')::decimal(20 , 5)                 as accrued_interest
    , nullif(trim(substring(a.content , 968 , 11)) , '')::text(200)                       as accounting_rule_code
    , nullif(trim(substring(a.content , 980 , 4)) , '')::text(200)                        as order_source_code
    , nullif(trim(substring(a.content , 985 , 8)) , '')::int                              as order_number
    , to_timestamp(
        nullif(trim(substring(a.content , 994 , 14)) , '')::text(200)
        , 'YYYYMMDD_HH24:MI'
    )                                                                                     as trade_order_entry_time_stamp
    , to_timestamp(
        nullif(trim(substring(a.content , 1009 , 14)) , '')::text(200)
        , 'YYYYMMDD_HH24:MI'
    )                                                                                     as trade_order_execution_time_stamp
    , nullif(trim(substring(a.content , 1024 , 8)) , '')::text(200)                       as broker_code
    , nullif(trim(substring(a.content , 1033 , 50)) , '')::text(200)                      as broker_name
    , nullif(trim(substring(a.content , 1084 , 10)) , '')::text(200)                      as schwab_from_account
    , nullif(trim(substring(a.content , 1095 , 10)) , '')::text(200)                      as schwab_to_account
    , nullif(trim(substring(a.content , 1106 , 15)) , '')::text(200)                      as schwab1_check_number
    , nullif(trim(substring(a.content , 1122 , 1)) , '')::text(200)                       as sweep_indicator
    , nullif(trim(substring(a.content , 1124 , 5)) , '')::text(200)                       as stock_exchange_code
    , nullif(trim(substring(a.content , 1130 , 1)) , '')::text(200)                       as inter_class_exchange_code
    , nullif(trim(substring(a.content , 1132 , 17)) , '')::decimal(20 , 5)                as distribution_rate
    , nullif(trim(substring(a.content , 1150 , 17)) , '')::decimal(20 , 5)                as cash_in_lieu_share_quantity
    , nullif(trim(substring(a.content , 1168 , 17)) , '')::decimal(20 , 5)                as dividend_interest_share_quantity
    , nullif(trim(substring(a.content , 1186 , 17)) , '')::decimal(20 , 5)                as cash_in_lieu_rate
    , nullif(trim(substring(a.content , 1204 , 17)) , '')::decimal(20 , 5)                as asset_backed_factor
    , nullif(trim(substring(a.content , 1222 , 2)) , '')::text(200)                       as source_system
    , nullif(trim(substring(a.content , 1225 , 2)) , '')::text(200)                       as journal_type
    , nullif(trim(substring(a.content , 1228 , 1)) , '')::text(200)                       as deposit_media
    , nullif(trim(substring(a.content , 1230 , 23)) , '')::text(200)                      as schwab_cashiering_unique_identifier
    , nullif(trim(substring(a.content , 1254 , 60)) , '')::text(200)                      as recipient_maker_name_line_1
    , nullif(trim(substring(a.content , 1315 , 60)) , '')::text(200)                      as recipient_maker_name_line_2
    , nullif(trim(substring(a.content , 1376 , 60)) , '')::text(200)                      as recipient_maker_name_line_3
    , nullif(trim(substring(a.content , 1437 , 12)) , '')::text(200)                      as frequency
    , nullif(trim(substring(a.content , 1450 , 15)) , '')::text(200)                      as disbursed_check_number
    , nullif(trim(substring(a.content , 1466 , 35)) , '')::text(200)                      as fed_reference_number
    , nullif(trim(substring(a.content , 1502 , 34)) , '')::text(200)                      as recipient_maker_account_number
    , nullif(trim(substring(a.content , 1537 , 8)) , '')::text(200)                       as bank_account_type
    , nullif(trim(substring(a.content , 1546 , 60)) , '')::text(200)                      as bank_name_part_1
    , nullif(trim(substring(a.content , 1607 , 60)) , '')::text(200)                      as bank_name_part_2
    , nullif(trim(substring(a.content , 1668 , 9)) , '')::text(200)                       as bank_aba_number
    , nullif(trim(substring(a.content , 1678 , 60)) , '')::text(200)                      as intermediary_name
    , nullif(trim(substring(a.content , 1739 , 50)) , '')::text(200)                      as transaction_check_memo_1
    , nullif(trim(substring(a.content , 1790 , 50)) , '')::text(200)                      as transaction_check_memo_2
    , nullif(trim(substring(a.content , 1841 , 17)) , '')::decimal(20 , 5)                as retirement_federal_income_tax
    , nullif(trim(substring(a.content , 1859 , 17)) , '')::decimal(20 , 5)                as retirement_state_income_tax
    , nullif(trim(substring(a.content , 1877 , 2)) , '')::decimal(20 , 5)                 as retirement_income_tax_state
    , to_timestamp(
        nullif(trim(substring(a.content , 1880 , 26)) , '')
        , 'YYYY-MM-DD-HH24.MI.SS.FF6'
    )                                                                                     as publication_time_stamp
    , nullif(trim(substring(a.content , 1907 , 8)) , '')::text(200)                       as version_marker_1
    , nullif(trim(substring(a.content , 1916 , 20)) , '')::decimal(20 , 5)                as tips_factor
    , nullif(trim(substring(a.content , 1937 , 18)) , '')::decimal(20 , 5)                as closing_price
    , nullif(trim(substring(a.content , 1956 , 8)) , '')::text(200)                       as version_marker_2
    , nullif(trim(substring(a.content , 1965 , 240)) , '')::text(200)                     as transaction_memo
    , nullif(trim(substring(a.content , 2206 , 8)) , '')::text(200)                       as version_marker_3
    , nullif(trim(substring(a.content , 2215 , 18)) , '')::decimal(20 , 5)                as closing_price_unfactored
    , nullif(trim(substring(a.content , 2234 , 17)) , '')::decimal(20 , 5)                as factor
    , to_date(nullif(trim(substring(a.content , 2252 , 8)) , '')::text(200) , 'YYYYMMDD') as factor_date
    , a.master_number                                                                     as master_number
    , cl.is_deceased                                                                      as is_deceased
    , cl.is_from_tda_migration                                                            as is_from_tda_migration
    , a.effective_date                                                                    as effective_date
    , dense_rank() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by
            case
                when master_number = '08438162'-- orion
                    then 1
                when master_number = '08109543'-- fixed income
                    then 2
                when master_number = '08315101'-- non-orion
                    then 3
                when master_number = '08355335'-- mps
                    then 4
                when master_number = '08051423'-- swag
                    then 5
                else 6
            end asc , a.master_number
    )                                                                                     as rn
    , {{ col_is_head(reference=source('schwab', 'trn')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at                                                                       as _source_loaded_at
    , a._source_file                                                                      as _source_file
from {{ source('schwab', 'trn') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where left(a.content , 2) = 'D1'
