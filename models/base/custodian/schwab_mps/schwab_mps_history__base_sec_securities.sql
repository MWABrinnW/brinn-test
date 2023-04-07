select r.json:"H2 H3"::varchar(100)                                       as h2_h3
     , r.json:"Custdian ID"::varchar(100)                                 as custodian_id
     , right(r.json:"MstrAcct Number", 8)::varchar(100)                   as master_account_number
     , r.json:"Master Account Name"::varchar(100)                         as master_account_name
     , try_to_date(to_char(r.json:"Business Date"), 'YYYYMMDD')::date     as business_date
     , r.json:"Prod Code"::varchar(100)                                   as product_code
     , r.json:"ProdCatg Code"::varchar(100)                               as product_category_code
     , r.json:"Tax Code"::varchar(100)                                    as tax_code
     , r.json:"Ly St"::varchar(100)                                       as legacy_security_type
     , r.json:"Ticker Symbol"::varchar(100)                               as ticker_symbol
     , r.json:"Industry Ticker Symbol"::varchar(100)                      as industry_ticker_symbol
     , r.json:"CUSIP"::varchar(100)                                       as cusip
     , r.json:"Schwab Sec Nbr"::varchar(100)                              as schwab_sec_nbr
     , r.json:"ReOrg Sec Nbr"::varchar(100)                               as reorg_sec_nbr
     , r.json:"Item Issue ID"::varchar(100)                               as item_issue_id
     , r.json:"RulSt SufID"::varchar(100)                                 as rule_set_suffix
     , r.json:"ISIN"::varchar(100)                                        as isin
     , r.json:"SEDOL"::varchar(100)                                       as sedol
     , r.json:"Options Display Symbol"::varchar(100)                      as options_display_symbol
     , r.json:"Security Description Line 1"::varchar(100)                 as security_description_line_1
     , r.json:"Security Description Line 2"::varchar(100)                 as security_description_line_2
     , r.json:"Security Description Line 3"::varchar(100)                 as security_description_line_3
     , r.json:"ScrtyDes Line 4"::varchar(100)                             as security_description_line_4
     , r.json:"Underlying Ticker Symbol"::varchar(100)                    as underlying_ticker_symbol
     , r.json:"Underlying Industry Ticker Symbol"::varchar(100)           as underlying_industry_ticker_symbol
     , r.json:"Underlyng CUSIP"::varchar(100)                             as underlying_cusip
     , r.json:"Underly Schwab#"::varchar(100)                             as underlying_schwab_security_number
     , r.json:"Underlying Itm Iss ID"::varchar(100)                       as underlying_item_issue_id
     , r.json:"UnRul SufID"::varchar(100)                                 as underlying_rule_set_suffix_id
     , r.json:"Underlying ISIN"::varchar(100)                             as underlying_isin
     , r.json:"Underly SEDOL"::varchar(100)                               as underlying_sedol
     , r.json:"MnyMk Code"::varchar(100)                                  as money_market_code
     , try_to_date(to_char(r.json:"Last Update"), 'YYYYMMDD')::date       as last_update_date
     , r.json:"S F"::varchar(100)                                         as sweep_fund_indicator
     , r.json:"Closing Price"::decimal(16, 5)                             as closing_price
     , try_to_date(to_char(r.json:"SecPrice LstUpDte"), 'YYYYMMDD')::date as security_price_update_date
     , r.json:"Security Valuation Unit"::decimal(15, 5)                   as security_valuation_unit
     , r.json:"OptnRt Symbol"::varchar(100)                               as option_root_symbol
     , try_to_date(to_char(r.json:"Opt Expr Date"), 'YYYYMMDD')::date     as option_expiration_date
     , r.json:"C P"::varchar(100)                                         as option_call_or_put_code
     , r.json:"Strike Price"::decimal(16, 5)                              as strike_price
     , r.json:"Interest Rate"::decimal(7, 5)                              as interest_rate
     , try_to_date(to_char(r.json:"Maturity Date"), 'YYYYMMDD')::date     as maturity_date
     , r.json:"TIPS Factor"::decimal(18, 9)                               as tips_factor
     , r.json:"Asset Backed Factor"::decimal(15, 12)                      as asset_backed_factor
     , r.json:"Face Value Amt"::decimal(13, 4)                            as face_value_amount
     , r.json:"St Cd"::varchar(100)                                       as issuer_state
     , r.json:"VersMrkr #1"::varchar(100)                                 as versmrkr_1
     , r.json:"P I"::varchar(100)                                         as schwab_propietary_indicator
     , r.json:"O I"::varchar(100)                                         as schwab_one_source_indicator
     , r.json:"VersMrkr #2"::varchar(100)                                 as versmrkr_2
     , r.json:"Closing Price Unfactored"::decimal(16, 5)                  as closing_price_unfactored
     , r.json:"Factor"::decimal(15, 12)                                   as factor
     , try_to_date(to_char(r.json:"Factor Date"), 'YYYYMMDD')::date       as factor_date
     ,case
          when master_account_number = '08051423'
               then 'swag'
          when master_account_number = '08355335'
               then 'mps'
          else 'mps'
          end                                                             as firm_source
     , effective_date::date                                               as effective_date
     , {{ col_is_head(reference=source('schwab_mps', 'sec')) }}
     , {{ col_is_current(date_col='effective_date') }}
     , _created_at::timestamp                                             as _source_loaded_at
from {{ source('schwab_mps', 'sec') }} r
