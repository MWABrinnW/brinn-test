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
  , nullif(trim(substring(content, 75, 45)), '')::text(200)                     as account_title_line_1
  , nullif(trim(substring(content, 121, 45)), '')::text(200)                    as account_title_line_2
  , nullif(trim(substring(content, 167, 45)), '')::text(200)                    as account_title_line_3
  , nullif(trim(substring(content, 213, 5)), '')::text(200)                     as account_registration
  , nullif(trim(substring(content, 219, 5)), '')::text(200)                     as account_type
  , nullif(trim(substring(content, 225, 17)), '')::decimal(20, 5)               as net_credit_or_debit_settled_unsettled
  , nullif(trim(substring(content, 243, 17)), '')::decimal(20, 5)               as margin_balance_settled_unsettled
  , nullif(trim(substring(content, 261, 17)), '')::decimal(20, 5)               as total_available_to_pay
  , nullif(trim(substring(content, 279, 17)), '')::decimal(20, 5)               as margin_buying_power
  , nullif(trim(substring(content, 297, 17)), '')::decimal(20, 5)               as money_market_funds_settled_unsettled
  , nullif(trim(substring(content, 315, 17)), '')::decimal(20, 5)               as mtd_margin_interest
  , nullif(trim(substring(content, 333, 17)), '')::decimal(20, 5)               as daily_margin_interest
  , nullif(trim(substring(content, 351, 17)), '')::decimal(20, 5)               as equity_excluding_options
  , nullif(trim(substring(content, 369, 17)), '')::decimal(20, 5)               as equity_percentage
  , nullif(trim(substring(content, 387, 17)), '')::decimal(20, 5)               as market_value_long
  , nullif(trim(substring(content, 405, 17)), '')::decimal(20, 5)               as market_value_short
  , nullif(trim(substring(content, 423, 17)), '')::decimal(20, 5)               as equity_including_options
  , nullif(trim(substring(content, 441, 17)), '')::decimal(20, 5)               as option_requirements
  , nullif(trim(substring(content, 459, 17)), '')::decimal(20, 5)               as month_end_dividend_payout
  , nullif(trim(substring(content, 477, 17)), '')::decimal(20, 5)               as maintenance_call
  , nullif(trim(substring(content, 495, 17)), '')::decimal(20, 5)               as mvl_cash_account_excluding_options
  , nullif(trim(substring(content, 513, 17)), '')::decimal(20, 5)               as net_market_value_positions_only
  , nullif(trim(substring(content, 531, 17)), '')::decimal(20, 5)               as net_market_value_positions_plus_cash_and_money_market
  , nullif(trim(substring(content, 549, 17)), '')::decimal(20, 5)               as cash_balance_settled_only
  , nullif(trim(substring(content, 567, 17)), '')::decimal(20, 5)               as cash_margin_balance_settled_only
  , nullif(trim(substring(content, 585, 8)), '')::text(200)                     as version_marker_3
  , nullif(trim(substring(content, 594, 17)), '')::decimal(20, 5)               as bank_sweep_interest_bearing_feature
  , master_number                                                               as master_number
  , cl.is_deceased                                                              as is_deceased
  , cl.is_from_tda_migration                                                    as is_from_tda_migration
  , effective_date                                                              as effective_date
  , row_number() over(partition by a.effective_date, account_number
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
                        end asc
                    )                                                           as rn
  , {{ col_is_head(reference=source('schwab', 'rps')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                 as _source_loaded_at
  , _source_file                                                                as _source_file
from {{ source('schwab', 'rps') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'D2'
