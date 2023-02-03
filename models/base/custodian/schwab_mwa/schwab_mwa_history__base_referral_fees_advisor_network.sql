select
    trim(substring(content, 1, 7))         as network_master
  , trim(substring(content, 10, 8))        as trader_fee_account
  , trim(substring(content, 19, 10))::date as transaction_date
  , substring(content, 30, 8)              as fa_master
  , substring(content, 39, 8)              as client_acount
  , trim(substring(content, 48, 30))       as client_name
  , trim(substring(content, 79, 15))       as transaction_type
  , case when trim(substring(content, 112, 15)) = '' then null else trim(substring(content, 112, 15)) end::decimal(15,2)      as management_fee_amount
  , case when trim(substring(content, 112, 15)) = '' then null else trim(substring(content, 112, 15)) end::decimal(5,2)      as fee_percent
  , case when trim(substring(content, 128, 16)) = '' then null else trim(substring(content, 128, 16)) end::decimal(16,2)      as advisor_network_participation_fee
  , case when trim(substring(content, 145, 16)) = '' then null else trim(substring(content, 145, 16)) end::decimal(16,2)      as fee_paid_to_advisor
  , effective_date::date                   as effective_date
  , _created_at::timestamp                 as _created_at
  , _source_file::varchar(100)             as source_file
from {{ source('schwab_mwa', 'referral_fees_advisor_network') }}