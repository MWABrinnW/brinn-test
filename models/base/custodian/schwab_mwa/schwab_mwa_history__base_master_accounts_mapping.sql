select
    right(master_account_id, 8) as master_account_id
    ,account_id
    ,effective_date
    ,{{ col_is_head(reference=source('schwab_mwa', 'master_accounts_mapping')) }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,record_datetime::timestamp                 as record_datetime
    ,record_datetime::timestamp                 as _source_loaded_at
from {{ source('schwab_mwa', 'master_accounts_mapping') }}