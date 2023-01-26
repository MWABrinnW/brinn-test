select
    trim(substring(content, 1, 7))                                 as quarter
  , trim(substring(content, 9, 10))::date                          as report_run_date
  , trim(substring(content, 20, 10))::date                         as account_balance_as_of_date
  , substring(content, 31, 8)                                      as network_master
  , substring(content, 40, 8)                                      as fa_master
  , substring(content, 49, 9)                                      as household_id
  , substring(content, 59, 10)::date                               as activation_date
  , case
        when trim(substring(content, 70, 10)) = '' then null
        else trim(substring(content, 70, 10)) end::date            as termination_date
  , substring(content, 81, 8)                                      as client_account
  , trim(substring(content, 90, 30))                               as client_name
  , trim(substring(content, 134, 10))                              as billed_not_billed
  , case
        when trim(substring(content, 121, 12)) = '' then null
        else trim(substring(content, 121, 12)) end::decimal(12, 2) as account_daily_balance
  , case
        when trim(substring(content, 145, 4)) = '' then null
        else trim(substring(content, 145, 4)) end::int             as count_of_accounts_within_household
  , case
        when trim(substring(content, 150, 12)) = '' then null
        else trim(substring(content, 150, 12)) end::decimal(10, 2) as household_ave_billable_assets
  , case
        when trim(substring(content, 163, 5)) = '' then null
        else trim(substring(content, 163, 5)) end::decimal(5, 4)   as blended_tiered_rate
  , case
        when trim(substring(content, 169, 12)) = '' then null
        else trim(substring(content, 169, 12)) end::decimal(12, 2) as fees_due_for_household
  , effective_date::date                                           as effective_date
  , _created_at::timestamp                                         as _created_at
  , _source_file::varchar(100)                                     as source_file
from {{ source('schwab_mwa', 'referral_fees_prior_quarter') }}