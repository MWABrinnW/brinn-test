select
     effective_date                              as effective_date
    , 'schwab'                                   as custodian
    , 'mwa'                                      as firm_source
    , right(master_account_id, 8)                as master_account_number
    , right(account_id, 8)                       as account_number
    , {{ col_is_head(reference=source('schwab_mwa', 'master_accounts_mapping')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime::timestamp                 as record_datetime
    , record_datetime::timestamp                 as _source_loaded_at
    , null::text(200)                            as _source_file
    , null::text(200)                            as _checksum
from {{ source('schwab_mwa', 'master_accounts_mapping') }}