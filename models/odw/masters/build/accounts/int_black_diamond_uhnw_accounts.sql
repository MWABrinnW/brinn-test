-- dedupe accounts that overlap with mps, only selecting accounts that exist in mwa
with cte_dedupe_mps as (
    select
        mwa.*
        , case
            when mps.account_number = mwa.account_number then 1
            else 0
        end::int          as is_duplicate
        , case
            when mps.account_number = mwa.account_number then 'mps account'
        end::varchar(200) as duplicate_reason
    from {{ ref('black_diamond_uhnw__base_accounts') }} as mwa
    left join {{ ref('black_diamond_mps__base_accounts') }} as mps
        on mwa.account_number = mps.account_number
        and mwa.effective_date = mps.effective_date
)


-- dedupe accounts that have an identical account number and account value (totalemw) per effective date.
, cte_dedupe_accounts as (
    select
        a.*
        , row_number()
            over (
                partition by a.account_number , a.effective_date , a.total_emv
                order by a.account_number asc , a.effective_date asc , a.total_emv desc
            )
            as rn
    from cte_dedupe_mps as a
    where true
        and a.is_duplicate = 0
    qualify rn = 1
)

-- identify accounts that have a shared data provider (array has one value), 
-- make distinct by appending internal acount id to account number (normalized model); otherwise, source account number
, cte_identify_distincts as (
    select
        da.*
        , count(*) over (partition by da.account_number , da.effective_date)                             as acct_cnt
        , array_agg(distinct da.data_provider) over (partition by da.account_number , da.effective_date) as distinct_data_provider
        , case
            when array_size(distinct_data_provider) = 1 and acct_cnt > 1
                then 1
            else 0
        end::int                                                                                         as make_distinct
    from cte_dedupe_accounts as da
)


select * exclude (is_duplicate , duplicate_reason)
from cte_identify_distincts
