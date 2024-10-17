{% set src = source('emoney_mwa', 'nexus_accounts') %}
select
    _data:"description"::text(200)                                as description
    , try_to_boolean(_data:"liability"::text)::int                as liability
    , _data:"accountnumber"::text(200)                            as account_number
    , try_to_number(_data:"cashbalance"::text , 28 , 10)::int     as cash_balance
    , try_to_number(_data:"isadvisorsource"::text , 28 , 10)::int as is_advisor_source
    , try_to_number(_data:"marginbalance"::text , 28 , 10)::int   as margin_balance
    , try_to_number(_data:"totalvalue"::text , 28 , 10)::int      as total_value
    , _data:"connectedaccountid"::text(200)                       as connected_account_id
    , _data:"connectionownerid"::text(200)                        as connection_owner_id
    , _data:"currencycode"::text(200)                             as currency_code
    , _data:"sourceaccountid"::text(200)                          as source_account_id
    , _data:"connectedclientid"::text(200)                        as connected_client_id
    , try_to_number(_data:"costbasis"::text , 28 , 10)::int       as cost_basis
    , try_to_number(_data:"deathbenefit"::text , 28 , 10)::int    as death_benefit
    , _data:"accountname"::text(200)                              as account_name
    , _data:"asof"::text(200)                                     as as_of
    , try_to_number(_data:"surrendervalue"::text , 28 , 10)::int  as surrender_value
    , _data:"accountid"::text(200)                                as account_id
    , try_to_number(_data:"holdingsvalue"::text , 28 , 10)::int   as holdings_value
    , try_to_number(_data:"sourceid"::text , 28 , 10)::int        as source_id

    , effective_date::date                                        as effective_date
    , _created_at::timestamp                                      as _created_at
    , _source_file::text(200)                                     as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
