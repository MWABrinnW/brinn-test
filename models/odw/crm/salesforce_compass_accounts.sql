{{ config(
    tags=["financials"]
) }}

-- get max effective date from bld table
with max_effective_date as (
    select max(effective_date) as max_date
    from {{ ref('bld_salesforce_compass_accounts') }}
)

-- set "is_head" for records with MAX effective date
, cte_head_accts as (
    select
        *
        , {{ col_is_head(
            reference=ref('bld_salesforce_compass_accounts'), 
            source_date_col='effective_date', 
            reference_date_col='effective_date'
        ) }}
    from {{ ref('bld_salesforce_compass_accounts') }}
    where true
        and rn_acct_num = 1
        and effective_date = (select sub_max.max_date from max_effective_date as sub_max)
)

-- set "is_head" for records with NON MAX effective dates
, cte_non_head_accts as (
    select
        *
        , 0::int as is_head
    from {{ ref('bld_salesforce_compass_accounts') }}
    where true
        and rn_acct_num = 1
        and effective_date != (select sub_max.max_date from max_effective_date as sub_max)
)

select *
from cte_head_accts
union all
select *
from cte_non_head_accts
order by
    effective_date::date , account_number , id
