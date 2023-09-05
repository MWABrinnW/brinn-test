select
    'schwab'                                                                     as custodian
  , cl.firm_source                                                               as firm_source
  , cf.firm                                                                      as firm
  , nullif(trim(substring(content, 1, 2)), '')::text(200)                        as record_type
  , nullif(trim(substring(content, 4, 8)), '')::text(200)                        as custodian_id
  , right(nullif(trim(substring(content, 13, 10)), '')::text(200), 8)            as master_account_number
  , nullif(trim(substring(content, 24, 30)), '')::text(200)                      as master_account_name
  , to_date(nullif(trim(substring(content, 55, 8)), '')::text(200), 'YYYYMMDD')  as business_date
  , right(nullif(trim(substring(content, 64, 10)), '')::text(200), 8)            as account_number
  , nullif(trim(substring(content, 75, 4)), '')::text(200)                       as product_code
  , nullif(trim(substring(content, 80, 8)), '')::text(200)                       as product_category_code
  , nullif(trim(substring(content, 89, 8)), '')::text(200)                       as tax_code
  , nullif(trim(substring(content, 98, 2)), '')::text(200)                       as legacy_security_type
  , nullif(trim(substring(content, 101, 30)), '')::text(200)                     as ticker_symbol
  , nullif(trim(substring(content, 132, 30)), '')::text(200)                     as industry_ticker_symbol
  , nullif(trim(substring(content, 163, 9)), '')::text(200)                      as cusip
  , nullif(trim(substring(content, 173, 7)), '')::text(200)                      as schwab_security_number
  , nullif(trim(substring(content, 181, 10)), '')::text(200)                     as item_issue_id
  , nullif(trim(substring(content, 192, 5)), '')::text(200)                      as rule_set_suffix_id
  , nullif(trim(substring(content, 198, 12)), '')::text(200)                     as isin
  , nullif(trim(substring(content, 211, 7)), '')::text(200)                      as sedol
  , nullif(trim(substring(content, 219, 30)), '')::text(200)                     as options_display_symbol
  , nullif(trim(substring(content, 250, 24)), '')::text(200)                     as security_description_line_1
  , nullif(trim(substring(content, 275, 24)), '')::text(200)                     as security_description_line_2
  , nullif(trim(substring(content, 300, 24)), '')::text(200)                     as security_description_line_3
  , nullif(trim(substring(content, 325, 8)), '')::text(200)                      as security_description_line_4
  , nullif(trim(substring(content, 334, 30)), '')::text(200)                     as underlying_ticker_symbol
  , nullif(trim(substring(content, 365, 30)), '')::text(200)                     as underlying_industry_ticker_symbol
  , nullif(trim(substring(content, 396, 9)), '')::text(200)                      as underlying_cusip
  , nullif(trim(substring(content, 406, 7)), '')::text(200)                      as underlying_schwab_security_number
  , nullif(trim(substring(content, 414, 10)), '')::text(200)                     as underlying_item_issue_id
  , nullif(trim(substring(content, 425, 5)), '')::text(200)                      as underlying_rule_set_suffix_id
  , nullif(trim(substring(content, 431, 12)), '')::text(200)                     as underlying_isin
  , nullif(trim(substring(content, 444, 7)), '')::text(200)                      as underlying_sedol
  , nullif(trim(substring(content, 452, 5)), '')::text(200)                      as money_market_code
  , nullif(trim(substring(content, 458, 1)), '')::text(200)                      as dividend_reinvest
  , nullif(trim(substring(content, 460, 1)), '')::text(200)                      as capital_gains_reinvest
  , nullif(trim(substring(content, 462, 18)), '')::decimal(20, 5)                as closing_price
  , to_date(nullif(trim(substring(content, 481, 8)), '')::text(200), 'YYYYMMDD') as security_price_update_date
  , nullif(trim(substring(content, 490, 17)), '')::decimal(20, 5)                as quantity_settled_and_unsettled
  , nullif(trim(substring(content, 508, 1)), '')::text(200)                      as long_short_indicator
  , nullif(trim(substring(content, 510, 19)), '')::decimal(20, 5)                as market_value_settled_and_unsettled
  , nullif(trim(substring(content, 530, 11)), '')::text(200)                     as accounting_rule_code
  , nullif(trim(substring(content, 542, 17)), '')::decimal(20, 5)                as quantity_settled
  , nullif(trim(substring(content, 560, 17)), '')::decimal(20, 5)                as quantity_unsettled_long
  , nullif(trim(substring(content, 578, 17)), '')::decimal(20, 5)                as quantity_unsettled_short
  , nullif(trim(substring(content, 596, 8)), '')::text(200)                      as version_marker_1
  , nullif(trim(substring(content, 605, 20)), '')::decimal(20, 5)                as tips_factor
  , nullif(trim(substring(content, 626, 17)), '')::decimal(20, 5)                as asset_backed_factor
  , nullif(trim(substring(content, 644, 8)), '')::text(200)                      as version_marker_2
  , nullif(trim(substring(content, 653, 18)), '')::decimal(20, 5)                as closing_price_unfactored
  , nullif(trim(substring(content, 672, 17)), '')::decimal(20, 5)                as factor
  , to_date(nullif(trim(substring(content, 690, 8)), '')::text(200), 'YYYYMMDD') as factor_date
  , master_number                                                                as master_number
  , cl.is_deceased                                                               as is_deceased
  , cl.is_from_tda_migration                                                     as is_from_tda_migration
  , effective_date                                                               as effective_date
  , dense_rank() over(partition by a.effective_date, account_number
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc, master_number asc
                    )                                                            as rn
  , {{ col_is_head(reference=source('schwab', 'rps')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                  as _source_loaded_at
  , _source_file                                                                 as _source_file
from {{ source('schwab', 'rps') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'D1'
