{% set src = source('emoney_mwa', 'nexus_bank_transactions') %}
select
    _data:"description"::text(200)                                               as description
    , _data:"checknumber"::text(200)                                             as check_number
    , _data:"connectedaccountid"::text(200)                                      as connected_account_id
    , _data:"connectionownerid"::text(200)                                       as connection_owner_id
    , try_to_number(_data:"transactionid"::text , 28 , 10)::int                  as transaction_id
    , _data:"connectedclientid"::text(200)                                       as connected_client_id
    , try_to_timestamp(_data:"postdate"::text , 'MM/DD/YYYY HH:MI:SS AM')        as post_date
    , try_to_timestamp(_data:"transactiondate"::text , 'MM/DD/YYYY HH:MI:SS AM') as transaction_date
    , _data:"userdescription"::text(200)                                         as user_description
    , _data:"categoryid"::text(200)                                              as category_id
    , try_to_number(_data:"accountid"::text , 28 , 10)::int                      as account_id
    , try_to_number(_data:"type"::text , 28 , 10)::int                           as type
    , _data:"memo"::text(200)                                                    as memo
    , try_to_number(_data:"amount"::text , 28 , 10)::int                         as amount

    , effective_date::date                                                       as effective_date
    , _created_at::timestamp                                                     as _created_at
    , _source_file::text(200)                                                    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
