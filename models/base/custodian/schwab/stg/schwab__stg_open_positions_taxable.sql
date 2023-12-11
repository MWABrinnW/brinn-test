select
    'schwab'                                                                    as custodian
  , cl.firm_source                                                              as firm_source
  , cf.firm                                                                     as firm
  , nullif(trim(substring(content, 1, 2)), '')::text(200)                       as record_type
  , nullif(trim(substring(content, 4, 8)), '')::text(200)                       as custodian_id
  , right(nullif(trim(substring(content, 13, 10)), '')::text(200), 8)           as master_account_number
  , nullif(trim(substring(content, 24, 30)), '')::text(200)                     as master_account_name
  , to_date(nullif(trim(substring(content, 55, 8)), '')::text(200), 'YYYYMMDD') as business_date
  , right(nullif(trim(substring(content, 64, 10)), '')::text(200), 8)           as account_number
  , nullif(trim(substring(content, 75, 8)), '')::text(200)                      as security_type
  , nullif(trim(substring(content, 84, 4)), '')::text(200)                      as product_code
  , nullif(trim(substring(content, 89, 8)), '')::text(200)                      as product_category_code
  , nullif(trim(substring(content, 98, 8)), '')::text(200)                      as tax_code
  , nullif(trim(substring(content, 107, 30)), '')::text(200)                    as symbol_ticker
  , nullif(trim(substring(content, 138, 9)), '')::text(200)                     as cusip
  , nullif(trim(substring(content, 148, 7)), '')::text(200)                     as schwab_internal_id
  , nullif(trim(substring(content, 156, 10)), '')::text(200)                    as item_issue_id
  , nullif(trim(substring(content, 167, 12)), '')::text(200)                    as isin
  , nullif(trim(substring(content, 180, 7)), '')::text(200)                     as sedol
  , nullif(trim(substring(content, 188, 30)), '')::text(200)                    as options_display_symbol
  , nullif(trim(substring(content, 219, 30)), '')::text(200)                    as underlying_ticker_symbol
  , nullif(trim(substring(content, 250, 9)), '')::text(200)                     as underlying_cusip
  , nullif(trim(substring(content, 260, 7)), '')::text(200)                     as underlying_schwab_internal_id
  , nullif(trim(substring(content, 268, 10)), '')::text(200)                    as underlying_item_issue_id
  , nullif(trim(substring(content, 279, 12)), '')::text(200)                    as underlying_isin
  , nullif(trim(substring(content, 292, 7)), '')::text(200)                     as underlying_sedol
  , nullif(trim(substring(content, 300, 18)), '')::decimal(20, 5)               as current_quantity
  , nullif(trim(substring(content, 319, 1)), '')::text(200)                     as long_short_indicator
  , nullif(trim(substring(content, 321, 19)), '')::decimal(20, 5)               as current_market_value
  , nullif(trim(substring(content, 341, 17)), '')::decimal(20, 5)               as accrued_interest_fixed_income
  , nullif(trim(substring(content, 359, 17)), '')::decimal(20, 5)               as cost_basis_unamortized_cost_basis_amount
  , nullif(trim(substring(content, 377, 21)), '')::decimal(20, 5)               as cost_per_share_share_cost_amount
  , nullif(trim(substring(content, 399, 17)), '')::decimal(20, 5)               as adjusted_cost_basis_amortized_cost_basis_amount
  , nullif(trim(substring(content, 417, 25)), '')::decimal(20, 5)               as adjusted_cost_per_share
  , nullif(trim(substring(content, 443, 19)), '')::decimal(20, 5)               as unrealized_gain_loss_ugl
  , nullif(trim(substring(content, 463, 1)), '')::text(200)                     as cost_basis_fully_known
  , nullif(trim(substring(content, 465, 1)), '')::text(200)                     as cost_basis_type
  , nullif(trim(substring(content, 467, 1)), '')::text(200)                     as account_taxable_indicator
  , nullif(trim(substring(content, 469, 1)), '')::text(200)                     as certified_indicator
  , nullif(trim(substring(content, 471, 17)), '')::decimal(20, 5)               as original_face
  , nullif(trim(substring(content, 489, 5)), '')::text(200)                     as account_lot_selection_method_default
  , nullif(trim(substring(content, 495, 1)), '')::text(200)                     as cost_method
  , nullif(trim(substring(content, 497, 17)), '')::decimal(20, 5)               as principal_paydown_factor
  , master_number                                                               as master_number
  , cl.is_deceased                                                              as is_deceased
  , cl.is_from_tda_migration                                                    as is_from_tda_migration
  , effective_date                                                              as effective_date
  , dense_rank() over(partition by a.effective_date, account_number, cl.firm_source
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
                        end asc, a.master_number
                    )                                                           as rn
  , {{ col_is_head(reference=source('schwab', 'upt')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                 as _source_loaded_at
  , _source_file                                                                as _source_file
from {{ source('schwab', 'upt') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'DP'
