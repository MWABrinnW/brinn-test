select
     'schwab'                                   as custodian
    ,'mwa'                                      as firm_source
    ,right(master_account_id, 8)                as master_account_number
    ,account_id                                 as account_number
    ,effective_date                             as effective_date
    ,{{ col_is_head(reference=source('schwab_mwa', 'master_accounts_mapping')) }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,record_datetime::timestamp                 as record_datetime
    ,record_datetime::timestamp                 as _source_loaded_at
from {{ source('schwab_mwa', 'master_accounts_mapping') }}