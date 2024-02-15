select
      dt.yyyymm                                                 as yearmo
    , dt.quarter_end_date                                       as quarter_end_date
    , dt.quarter_end_date                                       as effective_date
    , 'fidelity'                                                as custodian
    , 'mwa'                                                     as firm_source
    , 'WAS Program'                                             as referral_party_name
    , trim(replace(json:"Acct Num"::varchar(100),'-',''))       as account_number
    , trim(json:"Acct Name"::varchar(200))                      as account_name
    , try_to_date(json:"WAS Advisor First Funded Date"::text)   as advisor_first_funded_date
    , try_to_date(json:"Month End Date"::text)                  as month_end_date
    , json:"FI/Cash Assets"::decimal(15,2)                      as fixed_income_and_cash_assets
    , json:"FI/Cash BPS"::decimal(15,2)                         as fixed_income_and_cash_bps
    , json:"Non FI/Cash Assets"::decimal(15,2)                  as non_fixed_income_and_cash_assets
    , json:"Non FI/Cash BPS"::decimal(15,2)                     as non_fixed_income_and_cash_bps
    , json:"Total Assets"::decimal(15,2)                        as total_assets
    , json:"Days in Period"::int                                as days_in_period
    , json:"Acc Total Fee"::decimal(15,2)                       as account_total_fee
    , json:"Months Remaining in Billing Cycle"::text            as months_remaining_in_billing_cycle
    , max(dt.quarter_end_date) over(partition by dt.yyyymm)     as period_max_effective_date
    , case when dt.quarter_end_date = period_max_effective_date
        then 1
        else 0
        end                                                     as is_period_latest
    , _created_at                                               as _created_at
    , _source_file                                              as _source_file
from {{ source('fidelity_mwa', 'referral_fees_was') }} a
left join {{ ref('dates') }} dt
    on try_to_date(json:"Month End Date"::text) = dt.date_key