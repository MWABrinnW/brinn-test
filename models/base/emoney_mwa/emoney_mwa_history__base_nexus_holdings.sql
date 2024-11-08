{% set src = source('emoney_mwa', 'nexus_holdings') %}
select
    try_to_number(_data:"value"::text , 28 , 10)::int         as value
    , _data:"connectedaccountid"::text(200)                   as connected_account_id
    , _data:"connectionownerid"::text(200)                    as connection_owner_id
    , _data:"currencycode"::text(200)                         as currency_code
    , _data:"connectedclientid"::text(200)                    as connected_client_id
    , try_to_number(_data:"costbasis"::text , 28 , 10)::int   as cost_basis
    , _data:"asof"::text(200)                                 as as_of
    , try_to_number(_data:"accountid"::text , 28 , 10)::int   as account_id
    , try_to_number(_data:"acquiredate"::text , 28 , 10)::int as acquire_date
    , _data:"cusip"::text(200)                                as cusip
    , _data:"ticker"::text(200)                               as ticker
    , _data:"description"::text(200)                          as description
    , try_to_number(_data:"units"::text , 28 , 10)::int       as units
    , try_to_number(_data:"price"::text , 28 , 10)::int       as price

    , effective_date::date                                    as effective_date
    , _created_at::timestamp                                  as _created_at
    , _source_file::text(200)                                 as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
