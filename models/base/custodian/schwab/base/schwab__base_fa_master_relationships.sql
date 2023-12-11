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
  , left(a._source_file,8) as master_number
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when left(a._source_file,8) = '08438162' -- orion
                            then 1
                        when left(a._source_file,8) = '08109543' -- fixed income
                            then 2
                        when left(a._source_file,8) = '08315101' -- non-orion
                            then 3
                        when left(a._source_file,8) = '08355335' -- mps
                            then 4
                        when left(a._source_file,8) = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when left(a._source_file,8) = '08438162' -- orion
                            then 1
                        when left(a._source_file,8) = '08109543' -- fixed income
                            then 2
                        when left(a._source_file,8) = '08315101' -- non-orion
                            then 3
                        when left(a._source_file,8) = '08355335' -- mps
                            then 4
                        when left(a._source_file,8) = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_firm_source
  , row_number() over(partition by a.effective_date, account_number
                    order by case
                        when left(a._source_file,8) = '08438162' -- orion
                            then 1
                        when left(a._source_file,8) = '08109543' -- fixed income
                            then 2
                        when left(a._source_file,8) = '08315101' -- non-orion
                            then 3
                        when left(a._source_file,8) = '08355335' -- mps
                            then 4
                        when left(a._source_file,8) = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_global
  , {{ col_is_head(reference=source('schwab', 'fam_fa_master_relationships')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a.effective_date
  , a._source_loaded_at
  , a._source_file
  , a._md5
from {{ source('schwab', 'fam_fa_master_relationships') }} a
left join {{ ref('aux__stg_custodian_links') }}            cl
          on a.fa_master_account_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}                     cf
          on cl.firm_source = cf.firm_source
