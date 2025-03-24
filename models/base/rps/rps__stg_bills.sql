select
    'salesforce'                                                                              as system_name
    , 'compass_rps'                                                                           as system_instance
    , concat(system_name , '__' , system_instance)                                            as system_key
    , upper(json:ACCOUNT_NUMBER::text)                                                        as account_number_formatted
    , regexp_replace(replace(
        ltrim(upper(json:ACCOUNT_NUMBER::text) , '0')
        , '-' , ''
    ) , '\s{2,}' , ' ')::text(200)                                                            as account_number
    , json:CLIENT_NAME::text                                                                  as client_name
    , iff(json:CLIENT_MANAGER::text = '0' , null , json:CLIENT_MANAGER)::text                 as client_manager
    , lower(json:LOCATION::text)                                                              as location
    , json:START_DATE::date                                                                   as start_date
    , json:RECORD_KEEPER::text                                                                as record_keeper
    , lower(json:BILLING_FREQUENCY)::text                                                     as billing_frequency
    , lower(json:BILLING_STYLE)::text                                                         as billing_style
    , lower(json:BILLING_SOURCE::text)                                                        as billing_source
    , json:REVENUE_QUARTER::text                                                              as revenue_quarter
    , last_day(to_date(
        split_part(json:REVENUE_QUARTER , ' ' , 2) || '-'
        || case split_part(json:REVENUE_QUARTER , ' ' , 1)
            when 'Q1' then '03-31'
            when 'Q2' then '06-30'
            when 'Q3' then '09-30'
            when 'Q4' then '12-31'
        end , 'YYYY-MM-DD'
    ))                                                                                        as revenue_quarter_end_date
    , json:INVOICE_DATE::text                                                                 as invoice_date
    , json:AMOUNT::number(18 , 2)                                                             as amount
    , json:CLIENT_PAYMENT::date                                                               as client_payment
    , quarter(json:CLIENT_PAYMENT::date)::int                                                 as pmt_quarter
    , json:COMMENT::text                                                                      as comment
    , json:NOTES::text                                                                        as notes
    , lower(json:MANGEMENT_SOURCE)::text                                                      as management_source
    , iff(json:THIRD_PARTY_INTRODUCER::text = '0' , null , json:THIRD_PARTY_INTRODUCER::text) as third_party_introducer
    , json:CLIENT_SALESFORCE_ID::text                                                         as client_salesforce_id
    , iff(json:CLIENT_MANAGER_NEW::text = '0' , null , json:CLIENT_MANAGER_NEW)::text         as client_manager_new
    , (json:CLIENT_MANAGER_SPLIT_1::int / 100)::number(18 , 2)                                as client_manager_split_1
    , json:CLIENT_MANAGER_OVERRIDE_RATE::number(18 , 5)                                       as client_manager_override_rate
    , iff(json:CLIENT_MANAGER_2::text = '0' , null , json:CLIENT_MANAGER_2)::text             as client_manager_2
    , iff(json:CLIENT_MANAGER_NEW_2::text = '0' , null , json:CLIENT_MANAGER_NEW_2)::text     as client_manager_new_2
    , (json:CLIENT_MANAGER_SPLIT_2::int / 100)::number(18 , 2)                                as client_manager_split_2
    , iff(json:INTRODUCER_1::text = '0' , null , json:INTRODUCER_1)::text                     as introducer_1
    , iff(json:INTRODUCER_1_NEW::text = '0' , null , json:INTRODUCER_1_NEW)::text             as introducer_1_new
    , (json:INTRODUCER_1_SPLIT::int / 100)::number(18 , 2)                                    as introducer_1_split
    , iff(json:INTRODUCER_2::text = '0' , null , json:INTRODUCER_2)::text                     as introducer_2
    , iff(json:INTRODUCER_2_NEW::text = '0' , null , json:INTRODUCER_2_NEW)::text             as introducer_2_new
    , (json:INTRODUCER_2_SPLIT::int / 100)::number(18 , 2)                                    as introducer_2_split
    , json:FEE_REFERRAL::text                                                                 as fee_referral
    , json:THIRD_PARTY_RATE::number(18 , 5)                                                   as third_party_rate
    , json:STATE::text                                                                        as state
    , lower(json:CLIENT_STATUS)::text                                                         as client_status
    , json:TERM_DATE::text                                                                    as term_date
    , iff(json:BK_ACCOUNT_NUMBER::text = '0' , null , json:BK_ACCOUNT_NUMBER)::text           as bk_account_number
    , json:_box_file_id::text                                                                 as _box_file_id
    , lower(json:_box_file_name)::text                                                        as _box_file_name
    , json:_box_meta::text                                                                    as _box_meta
    , json:_created_at::datetime                                                              as _created_at
    , {{ col_is_head_with_partition(partition_col='lower(_box_file_name)'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('rps', 'bills') }}
