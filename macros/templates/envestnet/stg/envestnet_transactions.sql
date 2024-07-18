{%- macro envestnet_transactions(src) -%}
select
    'envestnet'                                       as system_name
    , {{ "'" ~ src ~ "'" }}                                              as system_instance
    , concat(system_name , '__' , system_instance)    as system_key
    , {{ envestnet_instance_map(src) }}                                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::int              as transaction_id
    , nullif(split_part(content , '|' , 2), '')::int              as account_id
    , nullif(split_part(content , '|' , 3), '')::varchar(32)      as account_number
    , nullif(split_part(content , '|' , 4), '')::int              as transaction_type
    , nullif(split_part(content , '|' , 5), '')::int              as security_id
    , nullif(split_part(content , '|' , 6), '')::varchar(22)      as cusip
    , nullif(split_part(content , '|' , 7), '')::varchar(22)      as ticker
    , nullif(split_part(content , '|' , 8), '')::varchar(8000)    as transaction_description
    , nullif(split_part(content , '|' , 9), '')::date             as transaction_date
    , nullif(split_part(content , '|' , 10), '')::decimal(18 , 2) as transaction_amount
    , nullif(split_part(content , '|' , 11), '')::decimal(19 , 8) as transaction_units
    , nullif(split_part(content , '|' , 12), '')::decimal(18 , 2) as commission
    , nullif(split_part(content , '|' , 13), '')::int         as deleted_flag
    , nullif(split_part(content , '|' , 14), '')::date            as settlement_date
    , nullif(split_part(content , '|' , 15), '')::decimal(18 , 2) as sec_fee
    , nullif(split_part(content , '|' , 16), '')::decimal(18 , 2) as postage_fee
    , nullif(split_part(content , '|' , 17), '')::decimal(18 , 2) as clearing_fee
    , nullif(split_part(content , '|' , 18), '')::decimal(18 , 2) as exchange_fee
    , nullif(split_part(content , '|' , 19), '')::decimal(18 , 2) as ticket_charge
    , nullif(split_part(content , '|' , 20), '')::decimal(18 , 2) as handling_fee
    , nullif(split_part(content , '|' , 21), '')::decimal(18 , 2) as redemption_fee
    , nullif(split_part(content , '|' , 22), '')::decimal(18 , 2) as deferred_sales_load_fee
    , nullif(split_part(content , '|' , 23), '')::decimal(18 , 2) as concession
    , nullif(split_part(content , '|' , 24), '')::decimal(18 , 2) as accrued_interest
    , nullif(split_part(content , '|' , 25), '')::varchar(20)     as owning_rep_id
    , nullif(split_part(content , '|' , 26), '')::varchar(20)     as executing_rep_id
    , nullif(split_part(content , '|' , 27), '')::date            as posted_date
    , nullif(split_part(content , '|' , 28), '')::int             as transaction_mapping_id
    , nullif(split_part(content , '|' , 29), '')::int             as exchange_id
    , nullif(split_part(content , '|' , 30), '')::decimal(18 , 2) as revenue_concession
    , nullif(split_part(content , '|' , 31), '')::decimal(18 , 6) as execution_price
    , nullif(split_part(content , '|' , 32), '')::varchar(4)      as security_type
    , nullif(split_part(content , '|' , 33), '')::int             as security_style
    , nullif(split_part(content , '|' , 34), '')::varchar(3)      as trade_currency
    , nullif(split_part(content , '|' , 35), '')::varchar(3)      as settlement_currency
    , nullif(split_part(content , '|' , 36), '')::decimal(18 , 6) as sales_charge_percentage
    , nullif(split_part(content , '|' , 37), '')::varchar(38)     as external_transaction_id
    , nullif(split_part(content , '|' , 38), '')::char(1)         as re_org_flag
    , nullif(split_part(content , '|' , 39), '')::int        as source
    , nullif(split_part(content , '|' , 40), '')::char(1)         as custodian_transaction
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'transactions')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                     as _created_at
    , _source_file                                    as _source_file
from {{ source('envestnet_' + src, 'transactions') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records
{%- endmacro -%}
