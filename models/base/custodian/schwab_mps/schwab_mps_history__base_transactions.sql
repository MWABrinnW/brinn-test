select
    recordtype                     as record_type
  , 'custodian'                    as custodian
  , 'mps'                          as firm_source
  , null::text(200)                as firm
  , custodianid                    as custodian_id
  , right(mstracctnumber, 8)       as master_account_number
  , masteraccountname              as master_account_name
  , businessdate                   as business_date
  , accountid                      as account_number
  , accounttitle1                  as account_title_line_1
  , accounttitle2                  as account_title_line_2
  , accounttitle3                  as account_title_line_3
  , accountregis                   as account_registration
  , accounttype                    as account_type
  , prodcode                       as product_code
  , prodcatgcode                   as product_category_code
  , taxcode                        as tax_code
  , lyst                           as legacy_security_type
  , tickersymbol                   as ticker_symbol
  , industrytickersymbol           as industry_ticker_symbol
  , cusip                          as cusip
  , schwabsecnbr                   as schwab_security_number
  , itemissueid                    as item_issue_id
  , rulstsufid                     as rule_set_suffix_id
  , isin                           as isin
  , sedol                          as sedol
  , optionsdisplaysymbol           as options_display_symbol
  , underlyingtickersymbol         as underlying_ticker_symbol
  , underlyingindustrytickersymbol as underlying_industry_ticker_symbol
  , underlyingcusip                as underlying_cusip
  , underlyingschwabnmbr           as underlying_schwab_security_number
  , underlyingitmissid             as underlying_item_issue_id
  , unrulsufid                     as underlying_rule_set_suffix_id
  , underlyingisn                  as underlying_isin
  , underlyingsedol                as underlying_sedol
  , mnymkcode                      as money_market_code
  , trcd                           as transaction_type_code
  , sbcd                           as transaction_subtype_code
  , transactioncategory            as transaction_category
  , transrccde                     as transaction_source_code
  , transactionsourcecodedesc      as transaction_source_code_description
  , transactiondetaildescription   as transaction_detail_description
  , tradetypecd                    as action_code
  , tc                             as transaction_cancel_code
  , tradedate                      as trade_date
  , settlementdate                 as settlement_date
  , traddate                       as transaction_date
  , eddivdnddate                   as ex_dividend_date
  , quantity                       as quantity
  , price                          as price
  , grossamount                    as gross_amount
  , debitcredit                    as debit_credit_indicator
  , netamount                      as net_amount
  , commission                     as commission
  , exchangeprocessingfee          as exchange_processing_fee
  , brokerservicefee               as broker_service_fee
  , primebrokerfee                 as prime_broker_fee
  , tradeawayfee                   as trade_away_fee
  , redemptionfee                  as redemption_fee
  , otherfee                       as other_fee
  , federaltefrawithholding        as federal_tefra_withholding
  , statetaxwithholding            as state_tax_withholding
  , sttx                           as state_receiving_tax
  , accruedinterest                as accrued_interest
  , accountingrulecode             as accounting_rule_code
  , ordersrcd                      as order_source_code
  , ordernumber                    as order_number
  , to_timestamp(tradeorderentrytimestamp, 'YYYYMMDD_HH24:MI') as trade_order_entry_time_stamp
  , to_timestamp(tradeorderexecutiontimestamp, 'YYYYMMDD_HH24:MI') as trade_order_execution_time_stamp
  , brokercode                     as broker_code
  , brokername                     as broker_name
  , swbfromaccount                 as schwab_from_account
  , swbtoaccount                   as schwab_to_account
  , s1check                        as schwab1_check_number
  , si                             as sweep_indicator
  , stockexchg                     as stock_exchange_code
  , ie                             as inter_class_exchange_code
  , distributionrate               as distribution_rate
  , cashinlieushareqty             as cash_in_lieu_share_quantity
  , divintshareqty                 as dividend_interest_share_quantity
  , cashinlieurate                 as cash_in_lieu_rate
  , assetbackedfactor              as asset_backed_factor
  , srsy                           as source_system
  , jntp                           as journal_type
  , dm                             as deposit_media
  , cashieringid                   as schwab_cashiering_unique_identifier
  , recipmakername1                as recipient_maker_name_1
  , recipmakername2                as recipient_maker_name_2
  , recipmakername3                as recipient_maker_name_3
  , frequency                      as frequency
  , disbursechecknum               as disbursed_check_number
  , federalbankrefnum              as fed_reference_number
  , recipmakeracctnum              as fed_reference_number
  , bankaccttype                   as bank_account_type
  , banknamepart1                  as bank_name_part_1
  , banknamepart2                  as bank_name_part_2
  , bankaba                        as bank_aba_number
  , intermedname                   as intermediary_name
  , checkmemo1                     as transaction_check_memo_1
  , checkmemo2                     as transaction_check_memo_2
  , retfedincometax                as retirement_federal_income_tax
  , retstateinctax                 as retirement_state_income_tax
  , rttx                           as retirement_income_tax_state
  , to_timestamp(pubtimestamp,
                 'YYYY-MM-DD-HH24.MI.SS.FF6') as publication_time_stamp
  --, versmrkr1                      as version_marker_1
  , tipsfactor                     as tips_factor
  , closingprice                   as closing_price
  --, versmrkr2                      as version_marker_2
  , transmemo                      as transaction_memo
  --, versmrkr3                      as version_marker_3
  , closingpriceunfactored         as closing_price_unfactored
  , factor                         as factor
  , factordate                     as factor_date
  , right(mstracctnumber, 8)       as master_number
  , effective_date::date           as effective_date
  , {{ col_is_head(reference=source('schwab_mps', 'tax_lots')) }}
  , record_datetime::timestamp     as _source_loaded_at
  , null::text(200)                as _source_file
from {{ source('schwab_mps', 'transactions') }}
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_transactions') }})

union all

select
    record_type
  , custodian
  , firm_source
  , firm
  , custodian_id
  , master_account_number
  , master_account_name
  , business_date
  , account_number
  , account_title_line_1
  , account_title_line_2
  , account_title_line_3
  , account_registration
  , account_type
  , product_code
  , product_category_code
  , tax_code
  , legacy_security_type
  , ticker_symbol
  , industry_ticker_symbol
  , cusip
  , schwab_security_number
  , item_issue_id
  , rule_set_suffix_id
  , isin
  , sedol
  , options_display_symbol
  , underlying_ticker_symbol
  , underlying_industry_ticker_symbol
  , underlying_cusip
  , underlying_schwab_security_number
  , underlying_item_issue_id
  , underlying_rule_set_suffix_id
  , underlying_isin
  , underlying_sedol
  , money_market_code
  , transaction_type_code
  , transaction_sub_type_code
  , transaction_category
  , transaction_source_code
  , transaction_source_code_description
  , transaction_detail_description
  , action_code
  , transaction_cancel_code
  , trade_date
  , settlement_date
  , transaction_date
  , ex_dividend_date
  , quantity
  , price
  , gross_amount
  , debit_credit_indicator
  , net_amount
  , commission
  , exchange_processing_fee
  , broker_service_fee
  , prime_broker_fee
  , trade_away_fee
  , redemption_fee
  , other_fee
  , federal_tefra_withholding
  , state_tax_withholding
  , state_receiving_tax
  , accrued_interest
  , accounting_rule_code
  , order_source_code
  , order_number
  , trade_order_entry_time_stamp
  , trade_order_execution_time_stamp
  , broker_code
  , broker_name
  , schwab_from_account
  , schwab_to_account
  , schwab1_check_number
  , sweep_indicator
  , stock_exchange_code
  , inter_class_exchange_code
  , distribution_rate
  , cash_in_lieu_share_quantity
  , dividend_interest_share_quantity
  , cash_in_lieu_rate
  , asset_backed_factor
  , source_system
  , journal_type
  , deposit_media
  , schwab_cashiering_unique_identifier
  , recipient_maker_name_line_1
  , recipient_maker_name_line_2
  , recipient_maker_name_line_3
  , frequency
  , disbursed_check_number
  , fed_reference_number
  , recipient_maker_account_number
  , bank_account_type
  , bank_name_part_1
  , bank_name_part_2
  , bank_aba_number
  , intermediary_name
  , transaction_check_memo_1
  , transaction_check_memo_2
  , retirement_federal_income_tax
  , retirement_state_income_tax
  , retirement_income_tax_state
  , publication_time_stamp
  --, version_marker_1
  , tips_factor
  , closing_price
  --, version_marker_2
  , transaction_memo
  --, version_marker_3
  , closing_price_unfactored
  , factor
  , factor_date
  , master_number
  , effective_date
  , is_head
  , _source_loaded_at
  , _source_file
from {{ ref('schwab__base_transactions') }}
where 1=1
  and firm_source = 'mps'
  and rn = 1
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
