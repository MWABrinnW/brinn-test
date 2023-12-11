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
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_firm_source
  , row_number() over(partition by a.effective_date, account_number
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_global
  , {{ col_is_head(reference=source('schwab', 'mxr_tda_account_mappings')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at
  , a._source_file
from {{ source('schwab', 'mxr_tda_account_mappings') }} a
left join {{ ref('aux__stg_custodian_links') }}         cl
          on a.master_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}                  cf
          on cl.firm_source = cf.firm_source
