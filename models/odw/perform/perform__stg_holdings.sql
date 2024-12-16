select
    account_key::text                                              as portfolio_id
    , replace(replace(trim(account_number) , '-' , '') , ' ' , '') as account_number
    , cusip::text                                                  as cusip
    , price::decimal(20 , 5)                                       as price
    , acquired_date::date                                          as acquired_date
    , size::decimal(20 , 5)                                        as size
    , cost::decimal(20 , 5)                                        as cost
    , _created_at::timestamp_ntz                                   as _created_at
    , {{ col_is_head(reference=source('perform', 'holdings'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz') }}
from {{ source('perform', 'holdings') }}
