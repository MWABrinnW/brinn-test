select
    'schwab'                                                                     as custodian
  , cl.firm_source                                                               as firm_source
  , cf.firm                                                                      as firm
  , nullif(trim(substring(content, 1, 2)), '')::text(200)                        as record_type
  , nullif(trim(substring(content, 4, 8)), '')::text(200)                        as custodian_id
  , right(nullif(trim(substring(content, 13, 10)), '')::text(200), 8)            as master_account_number
  , nullif(trim(substring(content, 24, 30)), '')::text(200)                      as master_account_name
  , to_date(nullif(trim(substring(content, 55, 8)), '')::text(200), 'YYYYMMDD')  as business_date
  , nullif(trim(substring(content, 64, 4)), '')::text(200)                       as product_code
  , nullif(trim(substring(content, 69, 8)), '')::text(200)                       as product_category_code
  , nullif(trim(substring(content, 78, 8)), '')::text(200)                       as tax_code
  , nullif(trim(substring(content, 87, 2)), '')::text(200)                       as legacy_security_type
  , nullif(trim(substring(content, 90, 30)), '')::text(200)                      as ticker_symbol
  , nullif(trim(substring(content, 121, 30)), '')::text(200)                     as industry_ticker_symbol
  , nullif(trim(substring(content, 152, 9)), '')::text(200)                      as cusip
  , nullif(trim(substring(content, 162, 7)), '')::text(200)                      as schwab_security_number
  , nullif(trim(substring(content, 170, 7)), '')::text(200)                      as re_org_schwab_internal_security_number
  , nullif(trim(substring(content, 178, 10)), '')::text(200)                     as item_issue_id
  , nullif(trim(substring(content, 189, 5)), '')::text(200)                      as rule_set_suffix
  , nullif(trim(substring(content, 195, 12)), '')::text(200)                     as isin
  , nullif(trim(substring(content, 208, 7)), '')::text(200)                      as sedol
  , nullif(trim(substring(content, 216, 30)), '')::text(200)                     as options_display_symbol
  , nullif(trim(substring(content, 247, 24)), '')::text(200)                     as security_description_line_1
  , nullif(trim(substring(content, 272, 24)), '')::text(200)                     as security_description_line_2
  , nullif(trim(substring(content, 297, 24)), '')::text(200)                     as security_description_line_3
  , nullif(trim(substring(content, 322, 8)), '')::text(200)                      as security_description_line_4
  , nullif(trim(substring(content, 331, 30)), '')::text(200)                     as underlying_ticker_symbol
  , nullif(trim(substring(content, 362, 30)), '')::text(200)                     as underlying_industry_ticker_symbol
  , nullif(trim(substring(content, 393, 9)), '')::text(200)                      as underlying_cusip
  , nullif(trim(substring(content, 403, 7)), '')::text(200)                      as underlying_schwab_security_number
  , nullif(trim(substring(content, 411, 10)), '')::text(200)                     as underlying_item_issue_id
  , nullif(trim(substring(content, 422, 5)), '')::text(200)                      as underlying_rule_set_suffix_id
  , nullif(trim(substring(content, 428, 12)), '')::text(200)                     as underlying_isin
  , nullif(trim(substring(content, 441, 7)), '')::text(200)                      as underlying_sedol
  , nullif(trim(substring(content, 449, 5)), '')::text(200)                      as money_market_code
  , to_date(nullif(trim(substring(content, 455, 8)), '')::text(200), 'YYYYMMDD') as last_update_date
  , nullif(trim(substring(content, 464, 1)), '')::text(200)                      as sweep_fund_indicator
  , nullif(trim(substring(content, 466, 18)), '')::decimal(20, 5)                as closing_price
  , to_date(nullif(trim(substring(content, 485, 8)), '')::text(200), 'YYYYMMDD') as security_price_update_date
  , nullif(trim(substring(content, 494, 17)), '')::decimal(20, 5)                as security_valuation_unit
  , nullif(trim(substring(content, 512, 15)), '')::text(200)                     as option_root_symbol
  , to_date(nullif(trim(substring(content, 528, 8)), '')::text(200), 'YYYYMMDD') as option_expiration_date
  , nullif(trim(substring(content, 537, 1)), '')::text(200)                      as option_call_or_put_code
  , nullif(trim(substring(content, 539, 18)), '')::decimal(20, 5)                as strike_price_amount
  , nullif(trim(substring(content, 558, 9)), '')::decimal(20, 5)                 as interest_rate
  , to_date(nullif(trim(substring(content, 568, 8)), '')::text(200), 'YYYYMMDD') as maturity_date
  , nullif(trim(substring(content, 577, 20)), '')::decimal(20, 5)                as tips_factor
  , nullif(trim(substring(content, 598, 17)), '')::decimal(20, 5)                as asset_backed_factor
  , nullif(trim(substring(content, 616, 15)), '')::decimal(20, 5)                as face_value_amount
  , nullif(trim(substring(content, 632, 2)), '')::text(200)                      as issuer_state
  , nullif(trim(substring(content, 635, 8)), '')::text(200)                      as version_marker_number
  , nullif(trim(substring(content, 644, 1)), '')::text(200)                      as schwab_proprietary_indicator
  , nullif(trim(substring(content, 646, 1)), '')::text(200)                      as schwab_one_source_indicator
  , nullif(trim(substring(content, 648, 8)), '')::text(200)                      as version_marker_2
  , nullif(trim(substring(content, 657, 18)), '')::decimal(20, 5)                as closing_price_unfactored
  , nullif(trim(substring(content, 676, 17)), '')::decimal(20, 5)                as factor
  , to_date(nullif(trim(substring(content, 694, 8)), '')::text(200), 'YYYYMMDD') as factor_date
  , master_number                                                                as master_number
  , cl.is_deceased                                                               as is_deceased
  , cl.is_from_tda_migration                                                     as is_from_tda_migration
  , effective_date                                                               as effective_date
  , row_number() over(partition by a.effective_date, nullif(trim(substring(content, 178, 10)), '')::text(200), cl.firm_source
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
  , {{ col_is_head(reference=source('schwab', 'sec')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                  as _source_loaded_at
  , _source_file                                                                 as _source_file
from {{ source('schwab', 'sec') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'D1'
