-- depends_on: {{ ref('schwab__stg_tda_account_mappings') }}

select
    a.custodian
    , cl.firm_source
    , cf.firm
    , a.record_type
    , a.master_account_number
    , a.tda_rep_code
    , a.account_number
    , a.tda_account_number
    , a.master_number
    , a.is_deceased
    , a.is_from_tda_migration
    , a.effective_date
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_firm_source
    , row_number() over (
        partition by a.effective_date , a.account_number
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )   as rn_global
    , {{ col_is_head(reference=source('schwab', 'mxr_tda_account_mappings')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._source_loaded_at
    , a._source_file
from {{ source('schwab', 'mxr_tda_account_mappings') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
