select
    'envestnet'                                    as system_name
    , 'manasquan'                                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , json:ACCOUNT_NUMBER::varchar(200)            as account_number
    , json:ADVISOR_FEE::decimal(20 , 2)            as advisor_fee
    , json:BATCH_NAME::varchar(200)                as batch_name
    , json:BILLABLE_VALUE::decimal(20 , 2)         as billable_value
    , json:BILLING_CYCLE::varchar(200)             as billing_cycle
    , json:BILL_TYPE::varchar(200)                 as bill_type
    , json:CLIENT_FEE::decimal(20 , 2)             as client_fee
    , json:CUSTODIAN_ID::varchar(200)              as custodian_id
    , json:DEBITED_ACCOUNT::varchar(200)           as debited_account
    , json:DEBIT_CUSTODIAN::varchar(200)           as debit_custodian
    , json:DEBIT_TYPE::varchar(200)                as debit_type
    , json:FIRM_FEE::decimal(20 , 2)               as firm_fee
    , json:INVOICE_DATE::date                      as invoice_date
    , json:PERIOD_END::date                        as period_end_date
    , json:TOT_FEE_AMT::decimal(20 , 2)            as total_fee_amount
    , _id                                          as _id
    , _created_at                                  as _created_at
    , _box_file_id::varchar(200)                   as _box_file_id
    , _box_file_name::varchar(200)                 as _box_file_name
    , _box_meta                                    as _box_meta
from {{ source('envestnet_mwa_raw','bills') }}
where true
