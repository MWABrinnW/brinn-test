select
    _data:portid::text            as portfolio_id
    , _data:portname::text        as portfolio_name
    , _data:custodianacctno::text as account_number_formatted
    , _data:portstatusid::int     as portfolio_status_id
    , to_timestamp_tz(
        _data:closedate::text , 'MM/DD/YYYY HH12:MI:SS AM'
    )::date                       as close_date
    , _data:userdef10::timestamp  as user_def_10

    , replace(
        upper(_data:custodianacctno::text) , '-' , ''
    )                             as account_number

    , _created_at                 as _created_at
    , _source_file                as _source_file
    , {{ col_is_head(
        reference=source('moxy', 'accounts'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz'
        ) }}
    , _id                         as _id
from {{ source('moxy', 'accounts') }}
where coalesce(portfolio_id , '') <> ''
