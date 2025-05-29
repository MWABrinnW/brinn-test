select
     effective_date                              as effective_date
    , 'schwab'                                   as custodian
    , 'mwa'                                      as firm_source
    , right(master_account_id, 8)                as master_account_number
    , right(account_id, 8)                       as account_number
    , {{ col_is_head(reference=source('schwab_mwa', 'master_accounts_mapping')) }}
    , record_datetime::timestamp                 as _source_loaded_at
    , null::text(200)                            as _source_file
from {{ source('schwab_mwa', 'master_accounts_mapping') }}
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_accounts') }})

union all

select
    effective_date          as effective_date
    ,'schwab'               as custodian
    , firm_source           as firm_source
    , master_number         as master_account_number
    , account_number        as account_number
    , is_head               as is_head
    , _source_loaded_at     as _source_loaded_at
    , _source_file          as _source_file
from {{ ref('schwab__base_accounts') }}
where 1=1
    and firm_source = 'mwa'
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
