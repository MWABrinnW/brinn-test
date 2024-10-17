{% set src = source('emoney_mwa', 'stock_option_accounts') %}
select
    try_to_number(_data:"price"::text , 28 , 10)::int                       as price
    , _data:"type"::text(200)                                               as type
    , try_to_number(_data:"connected"::text , 28 , 10)::int                 as connected
    , _data:"description"::text(200)                                        as description
    , _data:"clientid"::text(200)                                           as client_id
    , _data:"accountname"::text(200)                                        as account_name
    , try_to_boolean(_data:"underourmanagement"::text)::int                 as under_our_management
    , _data:"accountid"::text(200)                                          as account_id
    , _data:"institutionname"::text(200)                                    as institution_name
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of
    , _data:"ticker"::text(200)                                             as ticker
    , try_to_number(_data:"included"::text , 28 , 10)::int                  as included

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
