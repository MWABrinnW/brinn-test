{% set src = source('emoney_mwa', 'personal_property_accounts') %}
select
    try_to_number(_data:"connected"::text , 28 , 10)::int                   as connected
    , try_to_number(_data:"included"::text , 28 , 10)::int                  as included
    , _data:"type"::text(200)                                               as type
    , try_to_number(_data:"cashbalance"::text , 28 , 10)::int               as cash_balance
    , _data:"clientid"::text(200)                                           as client_id
    , try_to_number(_data:"marginbalance"::text , 28 , 10)::int             as margin_balance
    , try_to_number(_data:"totalvalue"::text , 28 , 10)::int                as total_value
    , try_to_number(_data:"costbasis"::text , 28 , 10)::int                 as cost_basis
    , _data:"accountname"::text(200)                                        as account_name
    , _data:"accountid"::text(200)                                          as account_id
    , _data:"institutionname"::text(200)                                    as institution_name
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_number(_data:"holdingsvalue"::text , 28 , 10)::int             as holdings_value
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
