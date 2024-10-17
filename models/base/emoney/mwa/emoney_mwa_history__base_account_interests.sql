{% set src = source('emoney_mwa', 'account_interests') %}
select
    _data:"clientid"::text(200)                                   as client_id
    , _data:"interestid"::text(200)                               as interest_id
    , _data:"interestownertype"::text(200)                        as interest_owner_type
    , _data:"accountid"::text(200)                                as account_id
    , try_to_number(_data:"interestpercent"::text , 28 , 10)::int as interest_percent
    , _data:"interesttype"::text(200)                             as interest_type

    , effective_date::date                                        as effective_date
    , _created_at::timestamp                                      as _created_at
    , _source_file::text(200)                                     as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
