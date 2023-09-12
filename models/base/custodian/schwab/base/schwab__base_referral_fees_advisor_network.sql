select
    'schwab'                                                       as custodian
  , cl.firm_source                                                 as firm_source
  , cf.firm                                                        as firm
  , trim(substring(content, 1, 7))                                 as network_master
  , trim(substring(content, 10, 8))                                as trader_fee_account
  , trim(substring(content, 19, 10))::date                         as transaction_date
  , substring(content, 30, 8)                                      as fa_master
  , substring(content, 39, 8)                                      as account_number
  , trim(substring(content, 48, 30))                               as client_name
  , trim(substring(content, 79, 15))                               as transaction_type
  , case
        when trim(substring(content, 112, 15)) = '' then null
        else trim(substring(content, 112, 15)) end::decimal(15, 2) as management_fee_amount
  , case
        when trim(substring(content, 112, 15)) = '' then null
        else trim(substring(content, 112, 15)) end::decimal(5, 2)  as fee_percent
  , case
        when trim(substring(content, 128, 16)) = '' then null
        else trim(substring(content, 128, 16)) end::decimal(16, 2) as advisor_network_participation_fee
  , case
        when trim(substring(content, 145, 16)) = '' then null
        else trim(substring(content, 145, 16)) end::decimal(16, 2) as fee_paid_to_advisor
  , left(a._source_file, 8)                                        as master_number
  , a.effective_date::date                                         as effective_date
  , {{ col_is_head(reference=source('schwab', 'referral_fees_advisor_network')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , a._created_at::timestamp                                       as _source_loaded_at
  , a._source_file::varchar(100)                                   as _source_file
from {{ source('schwab', 'referral_fees_advisor_network') }} a
left join {{ ref('aux__stg_custodian_links') }}              cl
          on left(a._source_file, 8) = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}                       cf
          on cl.firm_source = cf.firm_source
