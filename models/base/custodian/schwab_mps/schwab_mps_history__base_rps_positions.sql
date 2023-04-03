select r.json:"H2 H3"::varchar(100)                                  as h2_h3
     , r.json:"Custdian ID"::varchar(100)                            as custdian_id
     , right(r.json:"MstrAcct Number", 8)::varchar(100)              as mstracct_number
     , r.json:"Master Account Name"::varchar(100)                    as master_account_name
     , try_to_date(r.json:"Business Date"::varchar(100), 'YYYYMMDD') as business_date
     , right(r.json:"Account ID", 8)::varchar(100)                   as account_id
     , r.json:"Prod Code"::varchar(100)                              as prod_code
     , r.json:"ProdCatg Code"::varchar(100)                          as prodcatg_code
     , r.json:"Tax Code"::varchar(100)                               as tax_code
     , r.json:"Ly St"::varchar(100)                                  as ly_st
     , r.json:"Ticker Symbol"::varchar(100)                          as ticker_symbol
     , r.json:"Industry Ticker Symbol"::varchar(100)                 as industry_ticker_symbol
     , r.json:"CUSIP"::varchar(100)                                  as cusip
     , r.json:"Schwab Sec Nbr"::varchar(100)                         as schwab_sec_nbr
     , r.json:"Item Issue ID"::varchar(100)                          as item_issue_id
     , r.json:"RulSt SufID"::varchar(100)                            as rulst_sufid
     , r.json:"ISIN"::varchar(100)                                   as isin
     , r.json:"SEDOL"::varchar(100)                                  as sedol
     , r.json:"Options Display Symbol"::varchar(100)                 as options_display_symbol
     , r.json:"Security Description Line 1"::varchar(100)            as security_description_line_1
     , r.json:"Security Description Line 2"::varchar(100)            as security_description_line_2
     , r.json:"Security Description Line 3"::varchar(100)            as security_description_line_3
     , r.json:"ScrtyDes Line 4"::varchar(100)                        as scrtydes_line_4
     , r.json:"Underlying Ticker Symbol"::varchar(100)               as underlying_ticker_symbol
     , r.json:"Underlying Industry Ticker Symbol"::varchar(100)      as underlying_industry_ticker_symbol
     , r.json:"Underlyng CUSIP"::varchar(100)                        as underlyng_cusip
     , r.json:"Underly Schwab#"::varchar(100)                        as underly_schwab
     , r.json:"Underlying Itm Iss ID"::varchar(100)                  as underlying_itm_iss_id
     , r.json:"UnRul SufID"::varchar(100)                            as unrul_sufid
     , r.json:"Underlying ISIN"::varchar(100)                        as underlying_isin
     , r.json:"Underly SEDOL"::varchar(100)                          as underly_sedol
     , r.json:"MnyMk Code"::varchar(100)                             as mnymk_code
     , r.json:"D R"::varchar(100)                                    as d_r
     , r.json:"C G"::varchar(100)                                    as c_g
     , r.json:"Closing Price"::decimal(17, 5)                        as closing_price
     , try_to_date(to_char(r.json:"SecPrice LstUpDte"), 'YYYYMMDD')  as secprice_lstupdte
     , r.json:"Quantity Settled/Unsettled"::float                    as quantity_settled_unsettled
     , r.json:"L S"::varchar(100)                                    as l_s
     , r.json:"Market Value Settled/Unsettled"::decimal(17, 4)       as market_value_settled_unsettled
     , r.json:"Accounting Rule Code"::varchar(100)                   as accounting_rule_code
     , r.json:"Quantity Settled"::decimal(15, 5)                     as quantity_settled
     , r.json:"Quantity Unsettled/Long"::decimal(15, 5)              as quantity_unsettled_long
     , r.json:"Quantity Unsettled/Short"::decimal(15, 5)             as quantity_unsettled_short
     , r.json:"VersMrkr #1"::varchar(100)                            as versmrkr_1
     , r.json:"TIPS Factor"::decimal(18, 9)                          as tips_factor
     , r.json:"Asset Backed Factor"::decimal(15, 12)                 as asset_backed_factor
     , r.json:"VersMrkr #2"::varchar(100)                            as versmrkr_2
     , r.json:"Closing Price Unfactored"::decimal(16, 5)             as closing_price_unfactored
     , r.json:"Factor"::decimal(15, 12)                              as factor
     , try_to_date(r.json:"Factor Date"::varchar(100), 'YYYYMMDD')   as factor_date
     , {{ col_is_head(reference=source('schwab_mps', 'accounts')) }}
     , {{ col_is_current(date_col='effective_date') }}
     , 'mps'                                                         as firm_source
     , effective_date::date                                          as effective_date
     , _created_at::timestamp                                        as _source_loaded_at
from {{ source('schwab_mps', 'rps_d1') }} r
