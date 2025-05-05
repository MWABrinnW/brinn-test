{{ config(
  grants = {'+select': ['db_pms_r', 'trading']}
) }}

select
    account_id::text                                              as account_id
    , 'mwa'::text                                                 as firm_source
    , to_boolean(included)::int                                   as is_included
    , registration_name::text                                     as registration_name
    , account_number::text                                        as account_number
    , net_fee_performance_percent::float                          as net_fee_performance_percent
    , gross_performance_percent::float                            as gross_performance_percent
    , after_tax_gross_performance_percent::float                  as after_tax_gross_performance_percent
    , after_tax_net_performance_percent::float                    as after_tax_net_performance_percent
    , fee_amount_percent::float                                   as fee_amount_percent
    , beginning_value::float                                      as beginning_value
    , ending_value::float                                         as ending_value
    , management_style::text                                      as management_style
    , model::text                                                 as model
    , custodian::text                                             as custodian
    , to_date(account_start_date , 'YYYY-MM-DD')::date            as account_start_date
    , registration_last_name::text                                as registration_last_name
    , client_last_name::text                                      as client_last_name
    , to_date(bill_start_date , 'YYYY-MM-DD')::date               as bill_start_date
    , outside_id::text                                            as outside_id
    , portfolio_group_id::text                                    as portfolio_group_id
    , to_boolean(discretionary)::int                              as is_discretionary
    , to_boolean(unfunded)::int                                   as is_unfunded
    , to_boolean(bundled)::int                                    as is_bundled
    , to_boolean(excluded_from_firm_assets)::int                  as is_excluded_from_firm_assets
    , bond_percent::float                                         as bond_percent
    , equity_percent::float                                       as equity_percent
    , money_market_percent::float                                 as money_market_percent
    , other_asset_percent::text                                   as other_asset_percent
    , client_full_name::text                                      as client_full_name
    , business_line::text                                         as business_line
    , net_accrual::float                                          as net_accrual
    , advisor_notes::text                                         as advisor_notes
    , to_date(beginning_date , 'YYYY-MM-DD')::date                as beginning_date
    , bill_schedule::text                                         as bill_schedule
    , cash_balance::float                                         as cash_balance
    , created_by::text                                            as created_by
    , to_timestamp_ntz(created_date , 'MM/DD/YYYY HH12:MI:SS AM') as created_at
    , to_date(ending_date , 'YYYY-MM-DD')::date                   as ending_date
    , fund_family::text                                           as fund_family
    , id::text                                                    as id
    , import_source::text                                         as import_source
    , income::float                                               as income
    , to_boolean(locked)::int                                     as is_locked
    , pay_method::text                                            as pay_method
    , plan::text                                                  as plan
    , preliminary::text                                           as preliminary
    , rep::text                                                   as rep
    , risk_budget::int                                            as risk_budget
    , risk_tolerance::int                                         as risk_tolerance
    , stock_ratio::float                                          as stock_ratio
    , system_notes::text                                          as system_notes
    , to_boolean(trading_blocked)::int                            as is_trading_blocked
    , trading_instructions::text                                  as trading_instructions
    , weighted_return::float                                      as weighted_return
    , wrap_fee_percent::float                                     as wrap_fee_percent
    , _created_at::timestamp_ntz                                  as _created_at
    , _source_file::text                                          as _source_file
from {{ source('orion', 'composite_historical') }}
