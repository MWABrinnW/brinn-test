{% set src = source('emoney_mwa', 'nexus_investment_transactions') %}
select
    try_to_number(_data:"amount"::text , 28 , 10)::int                           as amount
    , _data:"description"::text(200)                                             as description
    , try_to_number(_data:"type"::text , 28 , 10)::int                           as type
    , _data:"cusip"::text(200)                                                   as cusip
    , try_to_boolean(_data:"cleared"::text)::int                                 as cleared
    , _data:"ticker"::text(200)                                                  as ticker
    , _data:"connectedaccountid"::text(200)                                      as connected_account_id
    , _data:"connectionownerid"::text(200)                                       as connection_owner_id
    , try_to_number(_data:"transactionid"::text , 28 , 10)::int                  as transaction_id
    , _data:"connectedclientid"::text(200)                                       as connected_client_id
    , try_to_timestamp(_data:"settlementdate"::text , 'MM/DD/YYYY HH:MI:SS AM')  as settlement_date
    , try_to_number(_data:"accruedinterest"::text , 28 , 10)::int                as accrued_interest
    , try_to_timestamp(_data:"postdate"::text , 'MM/DD/YYYY HH:MI:SS AM')        as post_date
    , try_to_timestamp(_data:"transactiondate"::text , 'MM/DD/YYYY HH:MI:SS AM') as transaction_date
    , _data:"holdingtype"::text(200)                                             as holding_type
    , try_to_number(_data:"accountid"::text , 28 , 10)::int                      as account_id
    , try_to_number(_data:"unitprice"::text , 28 , 10)::int                      as unit_price
    , try_to_number(_data:"units"::text , 28 , 10)::int                          as units
    , try_to_number(_data:"commission"::text , 28 , 10)::int                     as commission

    , effective_date::date                                                       as effective_date
    , _created_at::timestamp                                                     as _created_at
    , _source_file::text(200)                                                    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
