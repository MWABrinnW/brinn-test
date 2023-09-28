-- depends_on: {{ ref('schwab__stg_trades') }}

select
    a.custodian
  , cl.firm_source
  , cf.firm
  , a.record_type
  , a.business_date
  , a.master_account_number
  , a.account_number
  , a.trade_date
  , a.settlement_date
  , a.action
  , a.cancel
  , a.symbol
  , a.cusip
  , a.schwab_internal_security_number
  , a.trace_symbol
  , a.security_description
  , a.account_type
  , a.quantity
  , a.price
  , a.principal
  , a.total_amount
  , a.step_in_fee
  , a.schwab_commission
  , a.executing_broker_commission
  , a.prime_broker_fee
  , a.transaction_fee
  , a.broker_service_fee
  , a.exchange_processing_fee
  , a.order_handling_fee
  , a.other_fees
  , a.other_fees_description
  , a.accrued_interest
  , a.state_tax
  , a.tax_description
  , a.executing_broker_markup_or_markdown
  , a.research_fee
  , a.account_name_address_1
  , a.account_name_address_2
  , a.account_name_address_3
  , a.account_name_address_4
  , a.account_name_address_5
  , a.account_name_address_6
  , a.account_title_1
  , a.account_title_2
  , a.account_title_3
  , a.unused_field_4
  , a.unused_field_5
  , a.messages_break_indicator
  , a.message_1
  , a.message_2
  , a.message_3
  , a.message_4
  , a.message_5
  , a.message_6
  , a.message_7
  , a.master_number
  , a.is_deceased
  , a.is_from_tda_migration
  , a.effective_date
  , a.rn
  , {{ col_is_head(reference=source('schwab', 'tcf_trades')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at
  , a._source_file
from {{ source('schwab', 'tcf_trades') }}       a
left join {{ ref('aux__stg_custodian_links') }} cl
          on a.master_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}          cf
          on cl.firm_source = cf.firm_source
