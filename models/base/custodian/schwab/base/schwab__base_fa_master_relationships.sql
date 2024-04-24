-- depends_on: {{ ref('schwab__stg_fa_master_relationships') }}

select
    a.custodian
    , cl.firm_source
    , cf.firm
    , a.fa_master_account_number
    , a.fa_master_account_description
    , a.fa_rep_name
    , a.account_number
    , a.account_name
    , a.account_tax_id_number
    , left(a._source_file , 8) as master_number
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='left(a._source_file, 8)') }} asc
    )                          as rn
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='left(a._source_file, 8)') }} asc
    )                          as rn_firm_source
    , row_number() over (
        partition by a.effective_date , a.account_number
        order by {{ schwab_master_rank(col='left(a._source_file, 8)') }} asc
    )                          as rn_global
    , {{ col_is_head(reference=source('schwab', 'fam_fa_master_relationships')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.effective_date
    , a._source_loaded_at
    , a._source_file
    , a._md5
from {{ source('schwab', 'fam_fa_master_relationships') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.fa_master_account_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
