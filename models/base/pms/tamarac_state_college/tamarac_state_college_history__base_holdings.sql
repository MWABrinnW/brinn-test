select
    'tamarac'                                                                      as system_name
    , 'state_college'                                                              as system_instance
    , system_name || '__' || system_instance                                       as system_key
    , 'mwa'                                                                        as firm_source
    , content:ACCOUNT_NUMBER::varchar(1000)                                        as account_number
    , content:ACCRUAL_METHOD::varchar(1000)                                        as accrual_method
    , content:ACCRUED_INCOME::double                                               as accrued_income
    , content:ALLOW_UPDATES::boolean                                               as allow_updates
    , content:ALWAYS_REPORT_AS_IRR::boolean                                        as always_report_as_irr
    , content:AMORTIZE_ACCRETE_TO::varchar(1000)                                   as amortize_accrete_to
    , content:ANNUAL_DIVIDEND::double                                              as annual_dividend
    , content:ANNUAL_INCOME::double                                                as annual_income
    , content:AS_OF_DATE::date                                                     as as_of_date
    , content:ASSET_CLASS::varchar(1000)                                           as asset_class
    , content:CALL_DATE::date                                                      as call_date
    , content:CALL_PRICE::double                                                   as call_price
    , content:CALL_PUT::varchar(1000)                                              as call_put
    , content:CASH_INVESTED::double                                                as cash_invested
    , content:COMPOUNDING_FREQUENCY::varchar(1000)                                 as compounding_frequency
    , content:COST_BASIS::double                                                   as cost_basis
    , content:CUMULATIVE_INCOME::double                                            as cumulative_income
    , content:CURRENT_PRICE::double                                                as current_price
    , content:CURRENT_YIELD::double                                                as current_yield
    , content:CURRENT_YIELD_TO_WORST_MARKET::double                                as current_yield_to_worst_market
    , content:CUSIP::varchar(1000)                                                 as cusip
    , content:DAYS_TO_LONG_TERM::number(20)                                        as days_to_long_term
    , content:DISPLAY_ACCRUED_INTEREST_SECURITY::boolean                           as display_accrued_interest_security
    , content:DIVIDEND_INCOME_RATE_PER::double                                     as dividend_income_rate_per
    , content:DOLLAR_GAIN_LOSS::double                                             as dollar_gain_loss
    , content:EFFECTIVE_DURATION::double                                           as effective_duration
    , content:EXCLUDE_FROM_BILLING::boolean                                        as exclude_from_billing
    , content:EXCLUDE_FROM_PERFORMANCE::boolean                                    as exclude_from_performance
    , content:EXPIRATION_DATE::date                                                as expiration_date
    , content:EXTENDED_DESCRIPTION1::varchar(1000)                                 as extended_description1
    , content:EXTENDED_DESCRIPTION2::varchar(1000)                                 as extended_description2
    , content:FEDERAL_TAXABLE::boolean                                             as federal_taxable
    , content:FINAL_COUPON_DATE::date                                              as final_coupon_date
    , content:FIRST_COUPON_DATE::date                                              as first_coupon_date
    , content:FIRST_PAYMENT_DATE::date                                             as first_payment_date
    , content:FITCH_BOND_RATING::varchar(1000)                                     as fitch_bond_rating
    , content:FITCH_BOND_RATING_EFFECTIVE_DATE::date                               as fitch_bond_rating_effective_date
    , content:FITCH_BOND_RATING_PREVIOUS_VALUE::varchar(1000)                      as fitch_bond_rating_previous_value
    , content:FITCH_BOND_RATING_PREVIOUS_VALUE_EFFECTIVE_DATE::date
        as fitch_bond_rating_previous_value_effective_date
    , content:FUND_INCEPTION_DATE::date                                            as fund_inception_date
    , content:GLOBALLY_EXCLUDE_FROM_BILLING::boolean                               as globally_exclude_from_billing
    , content:GLOBALLY_EXCLUDE_FROM_PERFORMANCE::boolean                           as globally_exclude_from_performance
    , content:HOLDINGS_CURRENT_VALUE::double                                       as holdings_current_value
    , content:INCOME_FREQUENCY::varchar(1000)                                      as income_frequency
    , content:INTEREST_RATE::double                                                as interest_rate
    , content:ISSUE_DATE::date                                                     as issue_date
    , content:ISSUE_STATE::varchar(1000)                                           as issue_state
    , content:LONG_TERM_UNREALIZED_GAIN_LOSS::double                               as long_term_unrealized_gain_loss
    , content:MARKET_CAP::double                                                   as market_cap
    , content:MATURITY_DATE::date                                                  as maturity_date
    , content:MOODYS_BOND_RATING::varchar(1000)                                    as moodys_bond_rating
    , content:MOODYS_BOND_RATING_EFFECTIVE_DATE::date                              as moodys_bond_rating_effective_date
    , content:MOODYS_BOND_RATING_PREVIOUS_VALUE::varchar(1000)                     as moodys_bond_rating_previous_value
    , content:MOODYS_BOND_RATING_PREVIOUS_VALUE_EFFECTIVE_DATE::date
        as moodys_bond_rating_previous_value_effective_date
    , content:NEXT_CAPITAL_CALL_DATE::date                                         as next_capital_call_date
    , content:NEXT_DIVIDEND_AMOUNT::double                                         as next_dividend_amount
    , content:NEXT_DIVIDEND_DATE::date                                             as next_dividend_date
    , content:NEXT_EXDIVIDEND_DATE::date                                           as next_exdividend_date
    , content:NEXT_EXINCOME_DATE::date                                             as next_exincome_date
    , content:NEXT_INCOME_AMOUNT::double                                           as next_income_amount
    , content:NEXT_INCOME_DATE::date                                               as next_income_date
    , content:OPEN_DATE::date                                                      as open_date
    , content:PERCENT_DOLLAR_GAIN_LOSS::double                                     as percent_dollar_gain_loss
    , content:PERCENT_GAIN_LOSS::double                                            as percent_gain_loss
    , content:PREREFUND_DATE::date                                                 as prerefund_date
    , content:PREREFUND_PRICE::double                                              as prerefund_price
    , content:PRICE::double                                                        as price
    , content:QUALIFIED_STATUS::text(100)                                          as qualified_status
    , content:QUANTITY::double                                                     as quantity
    , content:REPORT_GAINS_AND_LOSSES_ON_THE_REALIZED_GAINS_LOSSES_REPORT::boolean
        as report_gains_and_losses_on_the_realized_gains_losses_report
    , content:SECTOR::varchar(1000)                                                as sector
    , content:SECURITY_ANNUAL_INCOME::double                                       as security_annual_income
    , content:SECURITY_DESCRIPTION::varchar(1000)                                  as security_description
    , content:SECURITY_TYPE::varchar(1000)                                         as security_type
    , content:SHARES_PER_CONTRACT::number(20)                                      as shares_per_contract
    , content:SHORT_TERM_UNREALIZED_GAIN_LOSS::double                              as short_term_unrealized_gain_loss
    , content:SP_BOND_RATING::varchar(1000)                                        as sp_bond_rating
    , content:SP_BOND_RATING_EFFECTIVE_DATE::date                                  as sp_bond_rating_effective_date
    , content:SP_BOND_RATING_PREVIOUS_VALUE::varchar(1000)                         as sp_bond_rating_previous_value
    , content:SP_BOND_RATING_PREVIOUS_VALUE_EFFECTIVE_DATE::date                   as sp_bond_rating_previous_value_effective_date
    , content:STATE_TAXABLE::boolean                                               as state_taxable
    , content:STRIKE_PRICE::double                                                 as strike_price
    , content:SUBSECTOR::varchar(1000)                                             as subsector
    , content:SYMBOL::varchar(1000)                                                as symbol
    , content:TAS_SECURITY::text(200)                                              as tas_security
    , content:TOTAL_UNREALIZED_GAIN_LOSS::double                                   as total_unrealized_gain_loss
    , content:TREAT_AS_COMMITTED_CAPITAL_SECURITY::boolean                         as treat_as_committed_capital_security
    , content:TREAT_SECURITY_AS_CASH::boolean                                      as treat_security_as_cash
    , content:TREAT_TRANSACTIONS_AS_END_OF_DAY::boolean                            as treat_transactions_as_end_of_day
    , content:UNDERLYING_SECURITY::varchar(1000)                                   as underlying_security
    , content:UNIT_COST::double                                                    as unit_cost
    , content:UPLOAD_ACCOUNT_ID::number(20)                                        as upload_account_id
    , content:UPLOAD_SECURITY_ID::number(20)                                       as upload_security_id
    , content:WEIGHT::double                                                       as weight
    , content:YIELD_AT_COST::double                                                as yield_at_cost
    , content:RECORD_DATETIME::timestampntz                                        as record_datetime
    , content:RECORD_DATE::date                                                    as record_date
    , content:SECURITY_BENCHMARK::varchar(1000)                                    as security_benchmark
    , effective_date                                                               as effective_date
    , dense_rank() over (partition by effective_date order by _created_at desc)    as rn
    , {{ col_is_head(
        reference=source('tamarac_state_college', 'assets')
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                                  as _created_at
    , _source_file                                                                 as _source_file
from {{ source('tamarac_state_college', 'assets') }}
