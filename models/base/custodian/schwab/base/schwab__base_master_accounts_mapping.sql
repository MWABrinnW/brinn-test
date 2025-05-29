-- depends_on: {{ ref('schwab__stg_accounts') }}

select
    a.effective_date                 as effective_date
    , 'schwab'                       as custodian
    , cl.firm_source                 as firm_source
    , right(a.master_account_id , 8) as master_account_number
    , right(a.account_id , 8)        as account_number
    , {{ col_is_head(reference=source('schwab_mwa', 'master_accounts_mapping')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a.record_datetime::timestamp   as _created_at
    , a.record_datetime::timestamp   as _source_loaded_at
    , null::text(200)                as _source_file
from {{ source('schwab_mwa', 'master_accounts_mapping') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on right(a.master_account_id , 8) = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    and a.effective_date < (
        select min(effective_date)
        from {{ ref('schwab__base_accounts') }}
    )

union all

select
    effective_date      as effective_date
    , custodian         as custodian
    , firm_source       as firm_source
    , master_number     as master_account_number
    , account_number    as account_number
    , is_head           as is_head
    , is_current        as is_current
    , _source_loaded_at as _created_at
    , _source_loaded_at as _source_loaded_at
    , _source_file      as _source_file
from {{ ref('schwab__base_accounts') }}
where 1 = 1
    and (
        (coalesce(is_from_tda_migration , 0) in (0 , 1) and effective_date >= '9/1/2023')
        or
        (coalesce(is_from_tda_migration , 0) = 0 and effective_date < '9/1/2023')
    )
