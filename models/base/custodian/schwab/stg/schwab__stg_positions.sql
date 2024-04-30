select
    'schwab'                                                                               as custodian
    , cl.firm_source                                                                       as firm_source
    , cf.firm                                                                              as firm
    , nullif(trim(split_part(a.content , '|' , 1)) , '')::text(200)                        as record_type
    , nullif(trim(split_part(a.content , '|' , 2)) , '')::text(200)                        as custodian_id
    , right(nullif(trim(split_part(a.content , '|' , 3)) , '')::text(200) , 8)             as master_account_number
    , nullif(trim(split_part(a.content , '|' , 4)) , '')::text(200)                        as master_account_name
    , to_date(nullif(trim(split_part(a.content , '|' , 5)) , '')::text(200) , 'YYYYMMDD')  as business_date
    , right(nullif(trim(split_part(a.content , '|' , 6)) , '')::text(200) , 8)             as account_number
    , trim(split_part(a.content , '|' , 7)::text(200))                                     as product_code
    , trim(split_part(a.content , '|' , 8)::text(200))                                     as product_category_code
    , trim(split_part(a.content , '|' , 9)::text(200))                                     as tax_code
    , trim(split_part(a.content , '|' , 10)::text(200))                                    as legacy_security_type
    , trim(split_part(a.content , '|' , 11)::text(200))                                    as ticker_symbol
    , trim(split_part(a.content , '|' , 12)::text(200))                                    as industry_ticker_symbol
    , trim(split_part(a.content , '|' , 13)::text(200))                                    as cusip
    , trim(split_part(a.content , '|' , 14)::text(200))                                    as schwab_security_number
    , trim(split_part(a.content , '|' , 15)::text(200))                                    as item_issue_id
    , trim(split_part(a.content , '|' , 16)::text(200))                                    as rule_set_suffix_id
    , trim(split_part(a.content , '|' , 17)::text(200))                                    as isin
    , trim(split_part(a.content , '|' , 18)::text(200))                                    as sedol
    , trim(split_part(a.content , '|' , 19)::text(200))                                    as options_display_symbol
    , trim(split_part(a.content , '|' , 20)::text(200))                                    as security_description_line_1
    , trim(split_part(a.content , '|' , 21)::text(200))                                    as security_description_line_2
    , trim(split_part(a.content , '|' , 22)::text(200))                                    as security_description_line_3
    , trim(split_part(a.content , '|' , 23)::text(200))                                    as security_description_line_4
    , trim(split_part(a.content , '|' , 24)::text(200))                                    as underlying_ticker_symbol
    , trim(split_part(a.content , '|' , 25)::text(200))                                    as underlying_industry_ticker_symbol
    , trim(split_part(a.content , '|' , 26)::text(200))                                    as underlying_cusip
    , trim(split_part(a.content , '|' , 27)::text(200))                                    as underlying_schwab_security_number
    , trim(split_part(a.content , '|' , 28)::text(200))                                    as underlying_item_issue_id
    , trim(split_part(a.content , '|' , 29)::text(200))                                    as underlying_rule_set_suffix_id
    , trim(split_part(a.content , '|' , 30)::text(200))                                    as underlying_isin
    , trim(split_part(a.content , '|' , 31)::text(200))                                    as underlying_sedol
    , trim(split_part(a.content , '|' , 32)::text(200))                                    as money_market_code
    , trim(split_part(a.content , '|' , 33)::text(200))                                    as dividend_reinvest
    , trim(split_part(a.content , '|' , 34)::text(200))                                    as capital_gains_reinvest
    , trim(split_part(a.content , '|' , 35))::decimal(20 , 5)                              as closing_price
    , to_date(nullif(trim(split_part(a.content , '|' , 36)) , '')::text(200) , 'YYYYMMDD') as security_price_update_date
    , nullif(trim(split_part(a.content , '|' , 37)) , '')::decimal(20 , 5)                 as quantity_settled_and_unsettled
    , nullif(trim(split_part(a.content , '|' , 38)) , '')::text(200)                       as long_short_indicator
    , nullif(trim(split_part(a.content , '|' , 39)) , '')::decimal(20 , 5)                 as market_value_settled_and_unsettled
    , nullif(trim(split_part(a.content , '|' , 40)) , '')::text(200)                       as accounting_rule_code
    , nullif(trim(split_part(a.content , '|' , 41)) , '')::decimal(20 , 5)                 as quantity_settled
    , nullif(trim(split_part(a.content , '|' , 42)) , '')::decimal(20 , 5)                 as quantity_unsettled_long
    , nullif(trim(split_part(a.content , '|' , 43)) , '')::decimal(20 , 5)                 as quantity_unsettled_short
    , nullif(trim(split_part(a.content , '|' , 44)) , '')::text(200)                       as version_marker_1
    , nullif(trim(split_part(a.content , '|' , 45)) , '')::decimal(20 , 5)                 as tips_factor
    , nullif(trim(split_part(a.content , '|' , 46)) , '')::decimal(20 , 5)                 as asset_backed_factor
    , nullif(trim(split_part(a.content , '|' , 47)) , '')::text(200)                       as version_marker_2
    , nullif(trim(split_part(a.content , '|' , 48)) , '')::decimal(20 , 5)                 as closing_price_unfactored
    , nullif(trim(split_part(a.content , '|' , 49)) , '')::decimal(20 , 5)                 as factor
    , to_date(nullif(trim(split_part(a.content , '|' , 50)) , '')::text(200) , 'YYYYMMDD') as factor_date
    , a.master_number                                                                      as master_number
    , cl.is_deceased                                                                       as is_deceased
    , cl.is_from_tda_migration                                                             as is_from_tda_migration
    , a.effective_date                                                                     as effective_date
    , dense_rank() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by
            case
                when master_number = '08438162'-- orion
                    then 1
                when master_number = '08109543'-- fixed income
                    then 2
                when master_number = '08315101'-- non-orion
                    then 3
                when master_number = '08355335'-- mps
                    then 4
                when master_number = '08051423'-- swag
                    then 5
                else 6
            end asc , master_number asc
    )                                                                                      as rn
    , {{ col_is_head(reference=source('schwab', 'rps')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at                                                                        as _source_loaded_at
    , a._source_file                                                                       as _source_file
from {{ source('schwab', 'rps') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where left(a.content , 2) = 'D1'
