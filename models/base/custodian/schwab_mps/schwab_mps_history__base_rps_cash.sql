select
       'schwab'                                                 as custodian
     , 'mps'                                                    as firm_source
     , null::text(200)                                          as firm
     , null::text(200)                                          as record_type
     , r.json:"Custdian ID"::varchar(100)                       as custodian_id
     , right(r.json:"MstrAcct Number"::varchar(100), 8)         as master_account_number
     , right(r.json:"Master Account Name", 8)::varchar(100)     as master_account_name
     , try_to_date(as_char(r.json:"Business Date"), 'YYYYMMDD') as business_date
     , right(r.json:"Account ID", 8)::varchar(100)              as account_number
     , r.json:"Account Title Line 1"::varchar(100)              as account_title_line_1
     , r.json:"Account Title Line 2"::varchar(100)              as account_title_line_2
     , r.json:"Account Title Line 3"::varchar(100)              as account_title_line_3
     , r.json:"Acct Regis"::varchar(100)                        as account_registration
     , r.json:"Acct Type"::varchar(100)                         as account_type
     , r.json:"Net Credit Debit"::decimal(15, 2)                as net_credit_debit
     , r.json:"Margin Balance"::decimal(15, 2)                  as margin_balance
     , r.json:"Available to Pay"::decimal(15, 2)                as available_to_pay
     , r.json:"Mrgn Buying Pwr"::decimal(15, 2)                 as margin_buying_power
     , r.json:"Money Mkt Funds"::decimal(15, 2)                 as money_market_funds
     , r.json:"MTD Margin Int"::decimal(15, 2)                  as mtd_margin_interest
     , r.json:"Daily Margin Int"::decimal(15, 2)                as daily_margin_interest
     , r.json:"Eqty Excl Option"::decimal(15, 2)                as equity_excluding_options
     , r.json:"Eqty Percentage"::decimal(15, 2)                 as equity_percentage
     , r.json:"Mkt Value Long"::decimal(15, 2)                  as market_value_long
     , r.json:"Mkt Value Short"::decimal(15, 2)                 as market_value_short
     , r.json:"Eqty Incl Option"::decimal(15, 2)                as equity_including_options
     , r.json:"Option Rqrmnts"::decimal(15, 2)                  as option_requirements
     , r.json:"Mnth End Div Pay"::decimal(15, 2)                as month_end_dividend_payout
     , r.json:"Maintenance Call"::decimal(15, 2)                as maintenance_call
     , r.json:"MVL Cash Ex Optn"::decimal(15, 2)                as market_value_cash_account_excluding_options
     , r.json:"Net MV Positions"::decimal(15, 2)                as net_market_value_positions_only
     , r.json:"Net MV Plus Cash"::decimal(15, 2)                as net_market_value_positions_plus_cash_and_money_market
     , r.json:"Cash Balance Settled Only"::decimal(15, 2)       as cash_balance_settled_only
     , r.json:"Cash Margin Bal Settled"::decimal(15, 2)         as cash_margin_balance_settled
     --, r.json:"VersMrkr #3"::varchar(100)                       as versmrkr_3
     , r.json:"Bank Sweep IBF"::decimal(15, 2)                  as bank_sweep_interest_bearing_feature
     , right(r.json:"MstrAcct Number"::varchar(100), 8)         as master_number
     , effective_date::date                                     as effective_date
     , {{ col_is_head(reference=source('schwab_mps', 'rps_d2')) }}
     , _created_at::timestamp                                   as _source_loaded_at
     , null::text(200)                                          as _source_file
from {{ source('schwab_mps', 'rps_d2') }} r
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_cash') }})

union all

select
    custodian
  , firm_source
  , firm
  , record_type
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
  , net_credit_or_debit_settled_unsettled
  , margin_balance_settled_unsettled
  , total_available_to_pay
  , margin_buying_power
  , money_market_funds_settled_unsettled
  , mtd_margin_interest
  , daily_margin_interest
  , equity_excluding_options
  , equity_percentage
  , market_value_long
  , market_value_short
  , equity_including_options
  , option_requirements
  , month_end_dividend_payout
  , maintenance_call
  , mvl_cash_account_excluding_options
  , net_market_value_positions_only
  , net_market_value_positions_plus_cash_and_money_market
  , cash_balance_settled_only
  , cash_margin_balance_settled_only
  --, version_marker_3
  , bank_sweep_interest_bearing_feature
  , master_number
  , effective_date
  , is_head
  , _source_loaded_at
  , _source_file
from {{ ref('schwab__base_cash') }}
where 1=1
    and firm_source = 'mps'
    and rn = 1
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
