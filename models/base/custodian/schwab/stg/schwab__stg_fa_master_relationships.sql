select
    'schwab'                                            as custodian
    , cl.firm_source                                    as firm_source
    , cf.firm                                           as firm
    , '0' || a.fa_master_account_number                 as fa_master_account_number
    , trim(trim(a.fa_master_account_description , '"')) as fa_master_account_description
    , trim(trim(a.fa_rep_name , '"'))                   as fa_rep_name
    , a.sub_account_number                              as account_number
    , trim(trim(a.sub_account_name , '"'))              as account_name
    , a.sub_account_tax_id_number                       as account_tax_id_number
    , row_number() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by
            case
                when left(a._source_file , 8) = '08438162'-- orion
                    then 1
                when left(a._source_file , 8) = '08109543'-- fixed income
                    then 2
                when left(a._source_file , 8) = '08315101'-- non-orion
                    then 3
                when left(a._source_file , 8) = '08355335'-- mps
                    then 4
                when left(a._source_file , 8) = '08051423'-- swag
                    then 5
                else 6
            end asc
    )                                                   as rn
    , a.effective_date                                  as effective_date
    --, left(a._source_file,8)                          as master_number
    , {{ col_is_head(reference=source('schwab', 'fam')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at                                     as _source_loaded_at
    , a._source_file                                    as _source_file
    , null::text(200)                                   as _md5
from {{ source('schwab', 'fam') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on '0' || fa_master_account_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
