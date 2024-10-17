select
    'tamarac'                                                                   as system_name
    , 'state_college'                                                           as system_instance
    , system_name || '__' || system_instance                                    as system_key
    , 'mwa'                                                                     as firm_source
    , content:ACCOUNT__NET_WORTH_CATEGORY::varchar(1000)                        as account__net_worth_category
    , content:ACCOUNT__OWNERSHIP_TYPE::varchar(1000)                            as account__ownership_type
    , content:ACCOUNT__PRIMARY_OWNER_EMAIL::varchar(1000)                       as account__primary_owner_email
    , content:ACCOUNT_CURRENT_VALUE::double                                     as account_current_value
    , content:ACCOUNT_LONG_TERM_REALIZED_GAIN_LOSS::double                      as account_long_term_realized_gain_loss
    , content:ACCOUNT_NAME::varchar(1000)                                       as account_name
    , content:ACCOUNT_NUMBER::varchar(1000)                                     as account_number
    , content:ACCOUNT_SHORT_TERM_REALIZED_GAIN_LOSS::double                     as account_short_term_realized_gain_loss
    , content:ACCOUNT_TOTAL_REALIZED_GAIN_LOSS::double                          as account_total_realized_gain_loss
    , content:ACCOUNT_TYPE::varchar(1000)                                       as account_type
    , content:ACCOUNTS_NOT_TO_BE_BILLED::boolean                                as accounts_not_to_be_billed
    , content:ADDRESS1::varchar(1000)                                           as address1
    , content:ADDRESS2::varchar(1000)                                           as address2
    , content:ADDRESS3::varchar(1000)                                           as address3
    , content:ADDRESS4::varchar(1000)                                           as address4
    , content:ADDRESS5::varchar(1000)                                           as address5
    , content:ADDRESS6::varchar(1000)                                           as address6
    , content:ADVISOR::varchar(1000)                                            as advisor
    , content:ADVISOR_1::varchar(1000)                                          as advisor_1
    , content:ADVISOR_2::varchar(1000)                                          as advisor_2
    , content:ADVISOR_3::varchar(1000)                                          as advisor_3
    , content:ADVISOR_4::varchar(1000)                                          as advisor_4
    , content:ADVISOR_5::varchar(1000)                                          as advisor_5
    , content:ADVISOR_VIEW::varchar(1000)                                       as advisor_view
    , content:AMORTIZATION_CALCULATION_ENABLED::boolean                         as amortization_calculation_enabled
    , content:ANNUAL_TURNOVER::double                                           as annual_turnover
    , content:ANNUALIZED_GROSS_IRR::double                                      as annualized_gross_irr
    , content:ANNUALIZED_GROSS_TWR::double                                      as annualized_gross_twr
    , content:ANNUALIZED_NET_IRR::double                                        as annualized_net_irr
    , content:ANNUALIZED_NET_TWR::double                                        as annualized_net_twr
    , content:AUM_INDICATOR::boolean                                            as aum_indicator
    , content:AVERAGE_DAILY_BALANCE::double                                     as average_daily_balance
    , content:BENCHMARK::varchar(1000)                                          as benchmark
    , content:BENCHMARK_START_DATE::date                                        as benchmark_start_date
    , content:BENEFICIAL_BILLING_RATE_TIER_TREATMENT::varchar(1000)             as beneficial_billing_rate_tier_treatment
    , content:BILLING_CLOSED_DATE::date                                         as billing_closed_date
    , content:BILLING_DEFINITIONS::varchar(1000)                                as billing_definitions
    , content:BILLING_GROUPS::varchar(1000)                                     as billing_groups
    , content:BILLING_INCEPTION_DATE::date                                      as billing_inception_date
    , content:BIRTHDAY::varchar(1000)                                           as birthday
    , content:BROKER_DEALER::varchar(1000)                                      as broker_dealer
    , content:CALCULATE_PERFORMANCE::boolean                                    as calculate_performance
    , content:CITY::varchar(1000)                                               as city
    , content:CLOSED_DATE::date                                                 as closed_date
    , content:CLOSING_VALUE::double                                             as closing_value
    , content:COMMISSIONS::double                                               as commissions
    , content:COMPUTE_BILLING_CLOSED_DATE::boolean                              as compute_billing_closed_date
    , content:COMPUTE_BILLING_INCEPTION_DATE::boolean                           as compute_billing_inception_date
    , content:COMPUTE_PERFORMANCE_INCEPTION_DATE::boolean                       as compute_performance_inception_date
    , content:CONS_ASSETS_PC_ASSIGNMENT::varchar(1000)                          as cons_assets_pc_assignment
    , content:CONS_ASSETS_PC_ASSIGNMENT_3::varchar(1000)                        as cons_assets_pc_assignment_3
    , content:CONS_ASSETS_PC_ASSIGNMENT2::varchar(1000)                         as cons_assets_pc_assignment2
    , content:COUNTRY::varchar(1000)                                            as country
    , content:CUMULATIVE_TURNOVER::double                                       as cumulative_turnover
    , content:CURRENT_CASH::double                                              as current_cash
    , content:CUSTODIAN::varchar(1000)                                          as custodian
    , content:DEFAULT__BILLED_ACCOUNT::varchar(1000)                            as default__billed_account
    , content:DEFAULT_TEMPLATE::varchar(1000)                                   as default_template
    , content:DESCRIPTION::varchar(1000)                                        as description
    , content:DIRECT_BILL::varchar(1000)                                        as direct_bill
    , content:DISCRETIONARY::boolean                                            as discretionary
    , content:DISPLAY_ACCRUED_INTEREST::boolean                                 as display_accrued_interest
    , content:DISPLAY_PREFERENCE::varchar(1000)                                 as display_preference
    , content:DISTRIBUTION::varchar(1000)                                       as distribution
    , content:DOLLAR_VARIANCE::double                                           as dollar_variance
    , content:ENTITY_TYPE::varchar(1000)                                        as entity_type
    , content:EXCEPTIONS::varchar(1000)                                         as exceptions
    , content:EXCLUDE_ALL_SECURITIES_FROM_BILLING::varchar(1000)                as exclude_all_securities_from_billing
    , content:EXCLUDE_ALL_SECURITIES_FROM_PERFORMANCE::varchar(1000)            as exclude_all_securities_from_performance
    , content:EXCLUDE_FROM_PORTAL_UPLOAD::boolean                               as exclude_from_portal_upload
    , content:EXPENSES_EXCLUDING_REVENUE::double                                as expenses_excluding_revenue
    , content:EXPENSES_PERCENT_OF_ACCOUNT::double                               as expenses_percent_of_account
    , content:FIRST_NAME::varchar(1000)                                         as first_name
    , content:FISCAL_YEAR_END::varchar(1000)                                    as fiscal_year_end
    , content:FISCAL_YEAR_END_DATE_USE_FOR_REPORTING::boolean                   as fiscal_year_end_date_use_for_reporting
    , content:GROSS_IRR::double                                                 as gross_irr
    , content:GROSS_TWR::double                                                 as gross_twr
    , content:HOUSEHOLD::varchar(1000)                                          as household
    , content:HOUSEHOLD_ADVISOR::varchar(1000)                                  as household_advisor
    , content:HOUSEHOLD_ASSIGNMENTS::varchar(1000)                              as household_assignments
    , content:INCLUDE_ACCRUED_DIVIDENDS::boolean                                as include_accrued_dividends
    , content:INCLUDE_ACCRUED_GAINS::boolean                                    as include_accrued_gains
    , content:INCLUDE_FOR_13F_REPORTING::boolean                                as include_for_13f_reporting
    , content:INCLUDE_IN_ADVISOR_REBALANCING::boolean                           as include_in_advisor_rebalancing
    , content:INFLOWS::double                                                   as inflows
    , content:INITIAL_VALUE::double                                             as initial_value
    , content:INTEREST__DIVIDENDS::double                                       as interest__dividends
    , content:INTERNAL_COMMISSIONS::number(20)                                  as internal_commissions
    , content:LAST_NAME::varchar(1000)                                          as last_name
    , content:LAST_REBAL_DATE::date                                             as last_rebal_date
    , content:LAST_RECONCILIATION_DATE::date                                    as last_reconciliation_date
    , content:LAST_SYNC_START_DATE::date                                        as last_sync_start_date
    , iff(
        content:LAST_SYNC_TIME like '% PT'
        , dateadd(
            hour
            , 2
            , to_timestamp_tz(
                replace(content:LAST_SYNC_TIME::text , ' PT' , '') , 'MM/DD/YYYY HH:MI AM'
            )
        )
        , to_timestamp_tz(content:LAST_SYNC_TIME::text , 'YYYY-MM-DD HH24:MI:SS.FF3')
    )::timestamp_tz                                                             as last_sync_time
    , content:MANAGED_ACCOUNT_VALUE_PREVEOD::double                             as managed_account_value_preveod
    , content:MANAGEMENT_FEES::double                                           as management_fees
    , content:MANAGEMENT_FEES_AND_COMMISSIONS::double                           as management_fees_and_commissions
    , content:MANUAL_PERFORMANCE_HISTORY_END_DATE::date                         as manual_performance_history_end_date
    , content:MANUAL_PERFORMANCE_RETURN_BEHAVIOR::varchar(1000)                 as manual_performance_return_behavior
    , content:MANUAL_PERFORMANCE_VALUE_BEHAVIOR::varchar(1000)                  as manual_performance_value_behavior
    , content:MARGIN::text                                                      as margin
    , content:MARGIN_EXPENSE::double                                            as margin_expense
    , content:MASTER_ACCOUNT::varchar(1000)                                     as master_account
    , content:NET_FLOWS::double                                                 as net_flows
    , content:NET_INVESTMENT_GAIN::double                                       as net_investment_gain
    , content:NET_IRR::double                                                   as net_irr
    , content:NET_TWR::double                                                   as net_twr
    , content:NEW_ACCOUNTS::boolean                                             as new_accounts
    , content:NEW_ACCOUNTS__TRADING::boolean                                    as new_accounts__trading
    , content:NEXT_SYNC_START_DATE::date                                        as next_sync_start_date
    , content:NUMBER_OF_TRADES::number(20)                                      as number_of_trades
    , content:OBJECTIVE::varchar(1000)                                          as objective
    , content:OBJECTIVE_START_DATE::date                                        as objective_start_date
    , content:ORION_TRANSFERS::boolean                                          as orion_transfers
    , content:OUT_OF_TOLERANCE::boolean                                         as out_of_tolerance
    , content:OUTFLOWS::double                                                  as outflows
    , content:OWNERSHIP_ACCOUNT_TYPE::varchar(1000)                             as ownership_account_type
    , content:OWNERSHIP_PARENT_ACCOUNT::varchar(1000)                           as ownership_parent_account
    , content:PAPER::boolean                                                    as paper
    , content:PAPER_APPRAISALS::boolean                                         as paper_appraisals
    , content:PAPER_REPORTS_EXCEPTIONS::varchar(1000)                           as paper_reports_exceptions
    , content:PAPER_REPORTS_JMLV::varchar(1000)                                 as paper_reports_jmlv
    , content:PC_MODELSET::varchar(1000)                                        as pc_modelset
    , content:PC_PERFORMANCE_SET2::varchar(1000)                                as pc_performance_set2
    , content:PC_PERFORMANCE_SET3::varchar(1000)                                as pc_performance_set3
    , content:PC_PERFORMANCE_SET4::varchar(1000)                                as pc_performance_set4
    , content:PC_PERFORMANCE_SET5::varchar(1000)                                as pc_performance_set5
    , content:PC_PERFORMANCE_SET6::varchar(1000)                                as pc_performance_set6
    , content:PC_STATIC_SET::varchar(1000)                                      as pc_static_set
    , content:PCADVISOR_NAME::varchar(1000)                                     as pcadvisor_name
    , content:PCSETID::varchar(1000)                                            as pcsetid
    , content:PERCENT_VARIANCE::double                                          as percent_variance
    , content:PERFORMANCE::varchar(1000)                                        as performance
    , content:PERFORMANCE_DATE::date                                            as performance_date
    , content:PERFORMANCE_INCEPTION_DATE::date                                  as performance_inception_date
    , content:PORTFOLIO_YIELD::double                                           as portfolio_yield
    , content:PREV_EOD_DATE::date                                               as prev_eod_date
    , content:PREVIOUS_12_MONTHS_TURNOVER::double                               as previous_12_months_turnover
    , content:PRIMARY_ADVISOR::varchar(1000)                                    as primary_advisor
    , content:PRIMARY_HOUSEHOLD_ID::number(20)                                  as primary_household_id
    , content:PRIMARY_HOUSEHOLD_PRIMARY_ADVISOR::boolean                        as primary_household_primary_advisor
    , content:PRIMARY_HOUSEHOLD_PRIMARY_ADVISOR_ID::number(20)                  as primary_household_primary_advisor_id
    , content:PURCHASES::double                                                 as purchases
    , content:REBALANCING_MODEL_NAME::varchar(1000)                             as rebalancing_model_name
    , content:RECONCILIATION_STATUS::varchar(1000)                              as reconciliation_status
    , content:SALES::double                                                     as sales
    , content:SERVICE_TEAM_COMPLIANCE::varchar(2000)                            as service_team_compliance
    , content:SERVICE_TEAM_CSA::varchar(1000)                                   as service_team_csa
    , content:SERVICE_TEAM_NAME::varchar(1000)                                  as service_team_name
    , content:SERVICE_TEAM_OPERATIONS::varchar(1000)                            as service_team_operations
    , content:SERVICE_TEAM_PRIMARY_ADVISOR::varchar(1000)                       as service_team_primary_advisor
    , content:SERVICE_TEAM_SECONDARY_ADVISOR::varchar(1000)                     as service_team_secondary_advisor
    , content:SERVICE_TEAM_SOLICITER::varchar(1000)                             as service_team_soliciter
    , content:SERVICE_TEAM_TRADE_APPROVER::varchar(20)                          as service_team_trade_approver
    , content:SERVICE_TEAM_TRADER::varchar(1000)                                as service_team_trader
    , content:SHORT_NAME::varchar(1000)                                         as short_name
    , content:SMA::boolean                                                      as sma
    , content:SMA_ASSET_CLASS::varchar(1000)                                    as sma_asset_class
    , content:SMA_DESCRIPTION1::varchar(1000)                                   as sma_description1
    , content:SMA_DESCRIPTION2::varchar(1000)                                   as sma_description2
    , content:SMA_DESCRIPTION3::varchar(1000)                                   as sma_description3
    , content:SMA_SECTOR::varchar(1000)                                         as sma_sector
    , content:SMA_SUBSECTOR::varchar(1000)                                      as sma_subsector
    , content:SMA_TAS_SECURITY::varchar(1000)                                   as sma_tas_security
    , content:SOURCE_OF_RECORD_FOR_REALIZED_GAIN_LOSS_IS_CUSTODIAN::boolean
        as source_of_record_for_realized_gain_loss_is_custodian
    , content:SPECIFIC_TRADING_INSTRUCTIONS::varchar(1000)                      as specific_trading_instructions
    , content:STATE::varchar(1000)                                              as state
    , content:STATE_OF_PRIMARY_RESIDENCE::varchar(1000)                         as state_of_primary_residence
    , content:TAMARAC_UPLOAD::boolean                                           as tamarac_upload
    , content:TARGET_ALLOCATION::varchar(1000)                                  as target_allocation
    , content:TAXABLE::boolean                                                  as taxable
    , content:TOTAL_ACCOUNT_VALUE_PREVEOD::double                               as total_account_value_preveod
    , content:TOTAL_CASH_RESERVES::double                                       as total_cash_reserves
    , content:TRADED_AWAY_COMMISSIONS::double                                   as traded_away_commissions
    , content:TRAILING_3_YEARS_NET_RETURN_ANNUALIZED::double                    as trailing_3_years_net_return_annualized
    , content:TRAILING_5_YEARS_NET_RETURN_ANNUALIZED::double                    as trailing_5_years_net_return_annualized
    , content:UNMANAGED_ACCOUNT_VALUE_PREVEOD::double                           as unmanaged_account_value_preveod
    , content:UPLOAD_ACCOUNT_ID::number(20)                                     as upload_account_id
    , content:USE_PRIMARY_HOUSEHOLD_ADDRESS::boolean                            as use_primary_household_address
    , content:ZIP::varchar(20)                                                  as zip
    , effective_date                                                            as effective_date
    , dense_rank() over (partition by effective_date order by _created_at desc) as rn
    , {{ col_is_head(
        reference=source('tamarac_state_college', 'accounts')
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                               as _created_at
    , _id                                                                       as _id
from {{ source('tamarac_state_college', 'accounts') }}
