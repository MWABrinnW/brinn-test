select r.json:"H4 H5"::varchar(100)                             as h4_h5
     , r.json:"Custdian ID"::varchar(100)                       as custodian_id
     , r.json:"MstrAcct Number"::varchar(100)                   as master_account_number
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
     , r.json:"VersMrkr #3"::varchar(100)                       as versmrkr_3
     , r.json:"Bank Sweep IBF"::decimal(15, 2)                  as bank_sweep_interest_bearing_feature
     , 'mps'                                                    as firm_source
     , effective_date::date                                     as effective_date
     , {{ col_is_head(reference=source('schwab_mps', 'rps_d2')) }}
     , {{ col_is_current(date_col='effective_date') }}
     , _created_at::timestamp                                 as _source_loaded_at
from {{ source('schwab_mps', 'rps_d2') }} r
