select
    'schwab'                                                       as custodian
  , cl.firm_source                                                 as firm_source
  , cf.firm                                                        as firm
  , trim(substring(content, 1, 7))                                 as quarter
  , trim(substring(content, 9, 10))::date                          as report_run_date
  , trim(substring(content, 20, 10))::date                         as account_balance_as_of_date
  , substring(content, 31, 8)                                      as network_master
  , substring(content, 40, 8)                                      as fa_master
  , substring(content, 49, 9)                                      as household_id
  , substring(content, 59, 10)::date                               as activation_date
  , case
        when trim(substring(content, 70, 10)) = '' then null
        else trim(substring(content, 70, 10)) end::date            as termination_date
  , substring(content, 81, 8)                                      as account_number
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
  , left(a._source_file, 8)                                        as master_number
  , a.effective_date::date                                         as effective_date
  , {{ col_is_head(reference=source('schwab', 'referral_fees_prior_quarter')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , a._created_at::timestamp                                       as _source_loaded_at
  , a._source_file::varchar(100)                                   as _source_file
from {{ source('schwab', 'referral_fees_prior_quarter') }} a
left join {{ ref('aux__stg_custodian_links') }}            cl
          on left(a._source_file, 8) = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}                     cf
          on cl.firm_source = cf.firm_source
