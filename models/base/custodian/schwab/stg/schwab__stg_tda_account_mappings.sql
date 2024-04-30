select
    'schwab'                                                       as custodian
    , cl.firm_source                                               as firm_source
    , cf.firm                                                      as firm
    , nullif(trim(substring(a.content , 1 , 2)) , '')::text(200)   as record_type
    , right(nullif(trim(substring(a.content , 4 , 10)) , '') , 8)  as master_account_number
    , nullif(trim(substring(a.content , 15 , 5)) , '')             as tda_rep_code
    , right(nullif(trim(substring(a.content , 21 , 10)) , '') , 8) as account_number
    , nullif(trim(substring(a.content , 32 , 9)) , '')             as tda_account_number
    , a.master_number                                              as master_number
    , cl.is_deceased                                               as is_deceased
    , cl.is_from_tda_migration                                     as is_from_tda_migration
    , a.effective_date                                             as effective_date
    , row_number() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by
            case
                when master_number = '08438162'-- orion
                    then 1
                when master_number = '08109543'-- fixed income
                    then 2
                when master_number = '08315101'-- non-orion
                    then 3
                when master_number = '08355335'-- mps
                    then 4
                when master_number = '08051423'-- swag
                    then 5
                else 6
            end asc
    )                                                              as rn
    , {{ col_is_head(reference=source('schwab', 'mxr')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._created_at                                                as _source_loaded_at
    , a._source_file                                               as _source_file
from {{ source('schwab', 'mxr') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where left(a.content , 2) = 'D1'
