select
    t.effective_date                 as effective_date
  , t.custodian                      as custodian
  , t.firm::text(100)                as firm
  , t.firm_source                    as firm_source
  , t.account_number                 as account_number
  , a.account_number_formatted       as account_number_formatted

  , a.custodian_link                 as custodian_link
  , a.custodian_link_detail          as custodian_link_detail
  , a.rep_link                       as rep_link
  , a.rep_link_detail                as rep_link_detail

  , a.account_type                   as account_type
  , a.account_type_source_definition as account_type_source_definition
  , a.account_type_source_code       as account_type_source_code

  , cmpt.normalized                  as product_type
  , cmpt.definition                  as product_type_source_definition
  , t.product_code                   as product_type_source_code

  , coalesce(t.ticker_symbol
        , t.industry_ticker_symbol
        , t.cusip)                   as symbol
  , coalesce(t.ticker_symbol
        , t.industry_ticker_symbol)  as ticker
  , t.cusip                          as cusip
    --------------------------------------------------------------------------------------------
    -- We'll normalize the transaction type later.
  , t.transaction_source_code::text(200)              as transaction_type_1_source_code
  , t.transaction_type_code::text(200)                as transaction_type_2_source_code
  , t.transaction_sub_type_code::text(200)            as transaction_type_3_source_code
  , t.transaction_source_code_description::text(200)  as transaction_type_4_source_code
  , null::text(200)                                   as transaction_type_5_source_code
    --------------------------------------------------------------------------------------------
  , t.transaction_date               as transaction_date
  , t.settlement_date                as settlement_date
  , t.trade_date                     as entry_date
  , case
        when lower(t.action_code) in ('scc', 'spc', 'sco', 'spo', 'sell')
            then t.quantity * -1
        else t.quantity
    end::decimal(22, 5)              as units_shares
  , t.price                          as price
  , t.gross_amount                   as gross_amount

  , t.net_amount                     as net_amount
  , t.commission                     as commission
  , t.closing_price                  as closing_price
  , t.closing_price_unfactored       as closing_price_unfactored
  , t.factor                         as factor
  , t.factor_date                    as factor_date
  , case
        when t.action_code is not null
            then 1
        else 0
        end::int                     as is_trade
  , case t.action_code
        when 'BCC' then 'BUY'
        when 'SCC' then 'SELL'
        when 'BPC' then 'BUY'
        when 'SPC' then 'SELL'
        when 'BCO' then 'BUY'
        when 'SCO' then 'SELL'
        when 'BPO' then 'BUY'
        when 'SPO' then 'SELL'
        else t.action_code end       as buy_sell
  , t.debit_credit_indicator         as debit_credit_indicator
  , to_timestamp_tz(
      convert_timezone(
            'America/New_York', 'UTC', t.trade_order_execution_time_stamp
            ) || '+00'
      )                              as trade_executed_at
  , t.ex_dividend_date               as ex_dividend_date
  , case
        when t.transaction_cancel_code = 'Y' then 1
        when t.transaction_cancel_code = 'N' then 0
        end::int                     as is_canceled
  , t.isin                           as isin
  , t.sedol                          as sedol
  , null::text(200)                  as transaction_id_source
  , null::text(200)                  as transaction_id
  , t.is_head                        as is_head
  , t.is_current                     as is_current
  , t._source_loaded_at              as _source_loaded_at
  , t._source_file                   as _source_file
from {{ ref('schwab__base_transactions') }}                      t
left join
          {{ ref('bld_custodian_accounts') }}                    a
          on
                      t.account_number = a.account_number
                  and t.effective_date = a.effective_date
                  and t.custodian = a.custodian
-- Security type
left join {{ ref('custodian_mappings') }}                        cmpt
          on
                      t.custodian = cmpt.custodian
                  and cmpt.field = 'product_type'
                  and t.product_code = cmpt.source
---- Transaction type
--left join {{ ref('custodian_mappings') }}                        cmtt
--          on
--                      t.custodian = cmtt.custodian
--                  and cmtt.field = 'transaction_type'
--                  and t.transaction_type_mnemonic = cmtt.source
---- Transaction subtype
--left join {{ ref('custodian_mappings') }}                        cmtst
--          on
--                      t.custodi--an = cmtst.custodian
--                  and cmtst.field = 'transaction_subtype'
--                  and t.key_code = cmtst.source
where 1 = 1
      and t.rn_firm_source = 1
