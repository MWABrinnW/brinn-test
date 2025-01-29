select
    'tamarac'                                      as system_name
    , 'savant'                                     as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , account__net_worth_category
    , account__ownership_type
    , account__primary_owner_email
    , account_current_value
    , account_long_term_realized_gain_loss
    , account_name
    , account_number                               as account_number_formatted
    , regexp_replace(replace(
        ltrim(upper(account_number) , '0')
        , '-' , ''
    ) , '\\s{2,}'
    , ' ')                                         as account_number
    , account_short_term_realized_gain_loss
    , account_total_realized_gain_loss
    , account_type
    , address1
    , address2
    , address3
    , address4
    , address5
    , address6
    , advisor
    , amortization_calculation_enabled
    , annual_turnover
    , annualized_gross_irr
    , annualized_gross_twr
    , annualized_net_irr
    , annualized_net_twr
    , average_daily_balance
    , benchmark
    , benchmark_start_date
    , beneficial_billing_rate_tier_treatment
    , billing_closed_date
    , billing_definitions
    , billing_groups
    , billing_inception_date
    , calculate_performance
    , city
    , closed_date
    , closing_value
    , commissions
    , compute_billing_closed_date
    , compute_billing_inception_date
    , compute_performance_inception_date
    , country
    , cumulative_turnover
    , current_cash
    , custodian
    , default_template
    , description
    , discretionary
    , display_accrued_interest
    , display_preference
    , dollar_variance
    , entity_type
    , exclude_all_securities_from_billing
    , exclude_all_securities_from_performance
    , expenses_excluding_revenue
    , expenses_percent_of_account
    , first_name
    , fiscal_year_end
    , fiscal_year_end_date_use_for_reporting
    , gross_irr
    , gross_twr
    , household_assignments
    , include_accrued_dividends
    , include_accrued_gains
    , inflows
    , initial_value
    , "INTEREST_&_DIVIDENDS"                       as interest_and_dividends
    , internal_commissions
    , last_name
    , last_reconciliation_date
    , last_sync_start_date
    , last_sync_time
    , managed_account_value_preveod
    , management_fees
    , management_fees_and_commissions
    , manual_performance_history_end_date
    , manual_performance_return_behavior
    , manual_performance_value_behavior
    , margin_expense
    , master_account
    , net_flows
    , net_investment_gain
    , net_irr
    , net_twr
    , next_sync_start_date
    , number_of_trades
    , objective
    , objective_start_date
    , out_of_tolerance
    , outflows
    , ownership_account_type
    , ownership_parent_account
    , percent_variance
    , performance_date
    , performance_inception_date
    , portfolio_yield
    , prev_eod_date
    , previous_12_months_turnover
    , primary_advisor
    , primary_household_id
    , primary_household_primary_advisor
    , primary_household_primary_advisor_id
    , purchases
    , reconciliation_status
    , sales
    , service_team_compliance
    , service_team_name
    , service_team_operations
    , service_team_primary_advisor
    , service_team_secondary_advisor
    , short_name
    , sma
    , sma_description1
    , sma_description2
    , sma_description3
    , sma_sector
    , sma_subsector
    , source_of_record_for_realized_gain_loss_is_custodian
    , state
    , state_of_primary_residence
    , target_allocation
    , taxable
    , total_account_value_preveod
    , traded_away_commissions
    , unmanaged_account_value_preveod
    , upload_account_id
    , use_primary_household_address
    , year_to_date_net_return
    , zip
    , client_number
    , erisa
    , {{ col_is_head(reference=source('tamarac_savant', 'financial_accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('tamarac_savant', 'financial_accounts') }}
where entity_type = 'Single Account'
