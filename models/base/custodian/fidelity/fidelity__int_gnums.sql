with max_effective_dates as (
    select max(effective_date) as effective_date
    from {{ ref('fidelity__int_gnums_fresh') }}
    group by all

    union distinct

    select max(effective_date) as effective_date
    from {{ ref('fidelity__int_gnums_history') }}
    group by all
)

, head_date as (
    select max(effective_date) as effective_date from max_effective_dates
)

select
    a.effective_date             as effective_date
    , a.custodian                as custodian
    , a.firm_source              as firm_source
    , a.account_number_formatted as account_number_formatted
    , a.account_number           as account_number
    , a.primary_account_holder   as primary_account_holder
    , a.gnum                     as gnum
    , a.gnum_source              as gnum_source
    , a.is_primary               as is_primary
    , a.gnum_name                as gnum_name
    , a.gnum_source_desc         as gnum_source_desc
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int                     as is_head
    , a._created_at              as _created_at
    , a._source_loaded_at        as _source_loaded_at
    , a._source_file             as _source_file
    , a._row_number              as _row_number
    , a._checksum                as _checksum
from {{ ref('fidelity__int_gnums_fresh') }} as a
left join head_date as b
    on a.effective_date = b.effective_date

union all

select
    a.effective_date             as effective_date
    , a.custodian                as custodian
    , a.firm_source              as firm_source
    , a.account_number_formatted as account_number_formatted
    , a.account_number           as account_number
    , a.primary_account_holder   as primary_account_holder
    , a.gnum                     as gnum
    , a.gnum_source              as gnum_source
    , a.is_primary               as is_primary
    , a.gnum_name                as gnum_name
    , a.gnum_source_desc         as gnum_source_desc
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int                     as is_head
    , a._created_at              as _created_at
    , a._source_loaded_at        as _source_loaded_at
    , a._source_file             as _source_file
    , a._row_number              as _row_number
    , a._checksum                as _checksum
from {{ ref('fidelity__int_gnums_history') }} as a
left join head_date as b
    on a.effective_date = b.effective_date
