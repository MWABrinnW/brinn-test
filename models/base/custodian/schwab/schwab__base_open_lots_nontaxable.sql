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
  , nullif(trim(substring(content, 98, 30)), '')::text(200)                      as symbol_ticker
  , nullif(trim(substring(content, 129, 9)), '')::text(200)                      as cusip
  , nullif(trim(substring(content, 139, 7)), '')::text(200)                      as schwab_internal_id
  , nullif(trim(substring(content, 147, 10)), '')::text(200)                     as item_issue_id
  , nullif(trim(substring(content, 158, 12)), '')::text(200)                     as isin
  , nullif(trim(substring(content, 171, 7)), '')::text(200)                      as sedol
  , nullif(trim(substring(content, 179, 30)), '')::text(200)                     as options_display_symbol
  , nullif(trim(substring(content, 210, 30)), '')::text(200)                     as underlying_ticker_symbol
  , nullif(trim(substring(content, 241, 9)), '')::text(200)                      as underlying_cusip
  , nullif(trim(substring(content, 251, 7)), '')::text(200)                      as underlying_schwab_internal_id
  , nullif(trim(substring(content, 259, 10)), '')::text(200)                     as underlying_item_issue_id
  , nullif(trim(substring(content, 270, 12)), '')::text(200)                     as underlying_isin
  , nullif(trim(substring(content, 283, 7)), '')::text(200)                      as underlying_sedol
  , nullif(trim(substring(content, 291, 18)), '')::decimal(20, 5)                as current_quantity
  , nullif(trim(substring(content, 310, 1)), '')::text(200)                      as long_short_indicator
  , nullif(trim(substring(content, 312, 5)), '')::text(200)                      as transaction_code
  , nullif(trim(substring(content, 318, 19)), '')::decimal(20, 5)                as current_market_value
  , nullif(trim(substring(content, 338, 17)), '')::decimal(20, 5)                as accrued_interest_fixed_income
  , to_date(nullif(trim(substring(content, 356, 8)), '')::text(200), 'YYYYMMDD') as acquired_date
  , to_date(nullif(trim(substring(content, 365, 8)), '')::text(200), 'YYYYMMDD') as original_purchase_date
  , nullif(trim(substring(content, 374, 21)), '')::decimal(20, 5)                as original_purchase_price
  , nullif(trim(substring(content, 396, 13)), '')::decimal(20, 5)                as yield_to_maturity_fixed_income
  , nullif(trim(substring(content, 410, 17)), '')::decimal(20, 5)                as cost_basis_unamortized_cost_basis_amount
  , nullif(trim(substring(content, 428, 21)), '')::decimal(20, 5)                as cost_per_share_share_cost_amount
  , nullif(trim(substring(content, 450, 17)), '')::decimal(20, 5)                as adjusted_cost_basis_amortized_cost_basis_amount
  , nullif(trim(substring(content, 468, 25)), '')::decimal(20, 5)                as adjusted_cost_per_share
  , nullif(trim(substring(content, 494, 19)), '')::decimal(20, 5)                as unrealized_gain_loss_ugl
  , nullif(trim(substring(content, 514, 5)), '')::int                            as number_of_days_held
  , nullif(trim(substring(content, 520, 1)), '')::text(200)                      as holding_period_term
  , nullif(trim(substring(content, 522, 1)), '')::text(200)                      as cost_basis_fully_known
  , nullif(trim(substring(content, 524, 1)), '')::text(200)                      as cost_basis_type
  , nullif(trim(substring(content, 526, 1)), '')::text(200)                      as account_taxable_indicator
  , nullif(trim(substring(content, 528, 1)), '')::text(200)                      as certified_indicator
  , nullif(trim(substring(content, 530, 17)), '')::decimal(20, 5)                as original_face
  , nullif(trim(substring(content, 548, 5)), '')::text(200)                      as account_lot_selection_method_default
  , nullif(trim(substring(content, 554, 1)), '')::text(200)                      as wash_sale_impacted
  , nullif(trim(substring(content, 556, 8)), '')::text(200)                      as version_marker_1
  , nullif(trim(substring(content, 565, 19)), '')::decimal(20, 5)                as disallowed_loss
  , nullif(trim(substring(content, 585, 17)), '')::decimal(20, 5)                as transaction_cost
  , nullif(trim(substring(content, 603, 25)), '')::decimal(20, 5)                as transaction_cost_per_share
  , nullif(trim(substring(content, 629, 8)), '')::text(200)                      as version_marker_2
  , nullif(trim(substring(content, 638, 1)), '')::text(200)                      as acquisition_type_gift_or_inherited
  , nullif(trim(substring(content, 640, 17)), '')::decimal(20, 5)                as original_cost_basis
  , nullif(trim(substring(content, 658, 8)), '')::text(200)                      as version_marker_3
  , nullif(trim(substring(content, 667, 17)), '')::decimal(20, 5)                as adjusted_cost_including_unpaid_amortization
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
                        end asc, a.master_number
                    )                                                            as rn
  , {{ col_is_head(reference=source('schwab', 'uln')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                  as _source_loaded_at
  , _source_file                                                                 as _source_file
from {{ source('schwab', 'uln') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'DL'
