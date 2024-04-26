{%- set src = source('sei', 'bills') -%}

select
    'sei'::text(200)                                          as system_name
    , 'manasquan'::text(200)                                  as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:"Account Display Name"::text(200)                  as account_display_name
    , json:"Account Number"::text(200)                        as account_number
    , json:"Fee Effective Date"::date                         as fee_effective_date
    , json:"Fee Type Description"::text(200)                  as fee_type_description
    -- fees are a negative values in the source table
    , (json:"Fees Collected (TC)" * -1)::number(20 , 2)       as fees_collected
    , json:"Firm Name"::text(200)                             as firm_name
    -- fees are a negative values in the source table
    , (json:"Net Collected (FBC)" * -1)::number(20 , 2)       as net_collected
    , json:"Primary Owner"::text(200)                         as primary_owner
    , json:"Settlement Date"::date                            as settlement_date
    , json:"Trade Date"::date                                 as trade_date
    , json:"Transaction Currency (TC)"::text(200)             as transaction_currency
    , json:"Transaction Date"::datetime                       as transaction_date
    , json:"Transaction Identifier"::text(200)                as transaction_identifier
    , json:"Transaction Type"::text(200)                      as transaction_type
    , _id::int                                                as _id
    , _created_at::datetime                                   as _created_at
    , _box_file_id::text(200)                                 as _box_file_id
    , _box_file_name::text(200)                               as _box_file_name
    , _box_meta::variant                                      as _box_meta
from {{ src }}-- resolves to raw.sei_manasquan.bills
