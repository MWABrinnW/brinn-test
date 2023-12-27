select
    t.effective_date                             as effective_date
  , t.custodian                                  as custodian
  , a.firm::text(100)                            as firm
  , t.firm_source                                as firm_source
  , t.account_custodial                          as account_number
  , t.account_custodial_formatted                as account_number_formatted

  , a.custodian_link                             as custodian_link
  , a.custodian_link_detail                      as custodian_link_detail
  , a.rep_link                                   as rep_link
  , a.rep_link_detail                            as rep_link_detail

  , a.account_type                               as account_type
  , a.account_type_source_definition             as account_type_source_definition
  , a.account_type_source_code                   as account_type_source_code

  , cmpt.normalized                              as product_type
  , cmpt.definition                              as product_type_source_definition
  , sec.product_code                             as product_type_source_code

  , coalesce(sec.symbol,
            sec.floor_trading_symbol,
            sec.option_symbol_id_occ,
            t.cusip)                             as symbol
  , coalesce(sec.symbol,
            sec.floor_trading_symbol,
            sec.option_symbol_id_occ)            as ticker
  , t.cusip                                      as cusip
  -------------------------------------------------------------------------------------------
  -- We'll normalize the transaction type later.
  , t.key_code::text(200)                        as transaction_type_1_source_code
  , t.transaction_type_mnemonic::text(200)       as transaction_type_2_source_code
  , null::text(200)                              as transaction_type_3_source_code
  , null::text(200)                              as transaction_type_4_source_code
  , null::text(200)                              as transaction_type_5_source_code
  -------------------------------------------------------------------------------------------
  , t.trade_date                                 as transaction_date
  , t.entry_date                                 as settlement_date
  , t.run_date                                   as entry_date
  , t.bookkeeping_quantity::decimal(22, 5)       as units_shares
  , t.price                                      as price
  , t.bookkeeping_amount                         as gross_amount
  -- PLACEHOLDER (bookkeeping_amount used as placeholder--not sure what to use yet)
  , t.bookkeeping_amount                         as net_amount
  , t.commission                                 as commission
  , sec.factored_price                           as closing_price
  , sec.unfactored_price                         as closing_price_unfactored
  , sec.current_factor_amount                    as factor
  , sec.current_factor_date::date                as factor_date
  , case
        when t.buy_sell_code is not null
            then 1
        else 0
        end::int                                 as is_trade
  , case
        when t.buy_sell_code = 'B'
            then 'buy'
        when t.buy_sell_code = 'S'
            then 'sell'
        else t.buy_sell_code end::text(100)      as buy_sell
  , case
        when t.bookkeeping_amount > 0
            then 'debit'
        else 'credit' end::text(200)             as debit_credit_indicator
  , null::timestamp_tz                           as trade_executed_at
  , null::date                                   as ex_dividend_date
  , case
        when t.cancel_code = '1' then 1
        else 0
        end::int                                 as is_canceled
  , t.isin                                       as isin
  , t.sedol                                      as sedol
  , (t.trade_date ||
        '_' ||
        t.bkpg_reference_number)::text(200)      as transaction_id_source
  , array_to_string(array_construct_compact(
         t.entry_date
        ,t.account_custodial
        ,bkpg_reference_number
        ,key_code
        ,transaction_type_mnemonic
        ,bookkeeping_quantity
        ,bookkeeping_amount
        ,bookkeeping_market_value
        ,bkpg_description_line_1
        ), '_')
                                                 as transaction_id
  , t.is_head                                    as is_head
  , t.is_current                                 as is_current
  , t._source_loaded_at                          as _source_loaded_at
  , t._source_file                               as _source_file
from {{ ref('fidelity_mps_history__vw_actvyd_activity') }}       t
left join {{ ref('custodian_accounts') }}                    a
          on
                      t.account_number = a.account_number
                  and t.effective_date = a.effective_date
                  and t.custodian = a.custodian
                  and t.firm_source = a.firm_source
-- Security attributes
left join {{ref('fidelity_mps_history__vw_secmast_1_security')}} sec
          on
                      sec.cusip = t.cusip -- is this the key we should use?
                  and t.trade_date = sec.effective_date
-- Security type
left join {{ ref('custodian_mappings') }}                        cmpt
          on
                      t.custodian = cmpt.custodian
                  and cmpt.field = 'product_type'
                  and sec.product_code = cmpt.source
---- Transaction type
--left join {{ ref('custodian_mappings') }}                        cmtt
--          on
--                      t.custodian = cmtt.custodian
--                  and cmtt.field = 'transaction_type'
--                  and t.transaction_type_mnemonic = cmtt.source
---- Transaction subtype
--left join {{ ref('custodian_mappings') }}                        cmtst
--          on
--                      t.custodian = cmtst.custodian
--                  and cmtst.field = 'transaction_subtype'
--                  and t.key_code = cmtst.source
where 1=1
  and ( t.buy_sell_code is null or ( t.buy_sell_code is not null and t.trade_type = 'T' ) )
