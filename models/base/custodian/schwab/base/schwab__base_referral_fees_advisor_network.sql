{{ config(tags=["referral_fees"]) }}

select
    'schwab'                                     as custodian
    , cl.firm_source                             as firm_source
    , cf.firm                                    as firm
    , trim(substring(a.content , 1 , 7))         as network_master
    , trim(substring(a.content , 10 , 8))        as trader_fee_account
    , trim(substring(a.content , 19 , 10))::date as transaction_date
    , substring(a.content , 30 , 8)              as fa_master
    , ltrim(substring(a.content , 39 , 8) , '0') as account_number
    , trim(substring(a.content , 48 , 30))       as client_name
    , trim(substring(a.content , 79 , 15))       as transaction_type
    , case
        when trim(substring(a.content , 112 , 15)) = '' then null
        else trim(substring(a.content , 112 , 15))
    end::decimal(16 , 2)                         as management_fee_amount
    , case
        when trim(substring(a.content , 112 , 15)) = '' then null
        else trim(substring(a.content , 112 , 15))
    end::decimal(5 , 2)                          as fee_percent
    , case
        when trim(substring(a.content , 128 , 16)) = '' then null
        else trim(substring(a.content , 128 , 16))
    end::decimal(16 , 2)                         as advisor_network_participation_fee
    , case
        when trim(substring(a.content , 145 , 16)) = '' then null
        else trim(substring(a.content , 145 , 16))
    end::decimal(16 , 2)                         as fee_paid_to_advisor
    , left(a._source_file , 8)                   as master_number
    , a.effective_date::date                     as effective_date
    , {{ col_is_head(reference=source('schwab', 'referral_fees_advisor_network')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at::timestamp                   as _source_loaded_at
    , a._source_file::varchar(100)               as _source_file
from {{ source('schwab', 'referral_fees_advisor_network') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on left(a._source_file , 8) = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    and a.effective_date <= '8/6/2025'

union all

select
    'schwab'                                     as custodian
    , cl.firm_source                             as firm_source
    , cf.firm                                    as firm
    , trim(substring(a.content , 1 , 7))         as network_master
    , trim(substring(a.content , 10 , 9))        as trader_fee_account
    , trim(substring(a.content , 20 , 10))::date as transaction_date
    , substring(a.content , 31 , 8)              as fa_master
    , ltrim(substring(a.content , 40 , 9) , '0') as account_number
    , trim(substring(a.content , 50 , 30))       as client_name
    , trim(substring(a.content , 81 , 15))       as transaction_type
    , case
        when trim(substring(a.content , 114 , 15)) = '' then null
        else trim(substring(a.content , 114 , 15))
    end::decimal(16 , 2)                         as management_fee_amount
    , case
        when trim(substring(a.content , 114 , 15)) = '' then null
        else trim(substring(a.content , 114 , 15))
    end::decimal(5 , 2)                          as fee_percent
    , case
        when trim(substring(a.content , 130 , 16)) = '' then null
        else trim(substring(a.content , 130 , 16))
    end::decimal(16 , 2)                         as advisor_network_participation_fee
    , case
        when trim(substring(a.content , 147 , 16)) = '' then null
        else trim(substring(a.content , 147 , 16))
    end::decimal(16 , 2)                         as fee_paid_to_advisor
    , left(a._source_file , 8)                   as master_number
    , a.effective_date::date                     as effective_date
    , {{ col_is_head(reference=source('schwab', 'referral_fees_advisor_network')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at::timestamp                   as _source_loaded_at
    , a._source_file::varchar(100)               as _source_file
from {{ source('schwab', 'referral_fees_advisor_network') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on left(a._source_file , 8) = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    -- Schwab increased from 8 digit to 10 (9 in this file) digit account numbers.
    -- We load from single column content instead of from a pre-parsed csv because
    -- this file type doesn't quote values with commas in them!
    and a.effective_date >= '8/7/2025'
