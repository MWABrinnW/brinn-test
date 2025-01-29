select
    json:system_key::text(200)  as _system_key
    , json:effective_date::date as effective_date
    , json:value_date::date     as value_date
    , json:notes::text(1000)    as notes
    , {{ col_is_head(
        reference=source('aux', 'rules_account_value_dates'),
        source_date_col='_created_at::timestamp',
        reference_date_col='_created_at::timestamp') }}
    , _created_at::timestamp    as _created_at
    , _box_file_id::text(200)   as _box_file_id
from {{ source('aux', 'rules_account_value_dates') }}
