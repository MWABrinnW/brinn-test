select
   'schwab'                                         as custodian
  , cl.firm_source                                  as firm_source
  , cf.firm                                         as firm
  , '0' || fa_master_account_number                 as fa_master_account_number
  , trim(trim(fa_master_account_description, '"'))  as fa_master_account_description
  , trim(trim(fa_rep_name, '"'))                    as fa_rep_name
  , sub_account_number                              as account_number
  , trim(trim(sub_account_name, '"'))               as account_name
  , sub_account_tax_id_number                       as account_tax_id_number
  , row_number() over(partition by a.effective_date, account_number
                    order by case
                        when fa_master_account_number = '08438162' -- orion
                            then 1
                        when fa_master_account_number = '08109543' -- fixed income
                            then 2
                        when fa_master_account_number = '08315101' -- non-orion
                            then 3
                        when fa_master_account_number = '08355335' -- mps
                            then 4
                        when fa_master_account_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc, fa_master_account_number asc
                    )                               as rn
  , effective_date                                  as effective_date
  , {{ col_is_head(reference=source('schwab', 'fam')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , a._created_at                                   as _source_loaded_at
  , a._source_file                                  as _source_file
  , null::text(200)                                 as _md5
from {{ source('schwab', 'fam') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on '0' || fa_master_account_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where 1=1
