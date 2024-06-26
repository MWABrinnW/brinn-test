{{ config(enabled=false) }}

{#
This is disabled for now becuase there is a scenario where
the clientid for an account changes.

```
select to_char(effective_date, 'YYYYMM') as month, client_id, client_name, count(*) as cnt
from bld_referral_fees
where custodian = 'schwab'
    and account_number in ('38123733', '67733232')
group by all
order by 1,2
```
#}

with cte_san as (
    select
        quarter_end_date
        , yearmo
        , effective_date
        , sum(adjustments) as adjustments
        , count(*)         as cnt
    from {{ ref('int_schwab_san_referral_fees') }}
    group by all
    order by 1 , 2
)

, cte_adj as (
    select
        period_datenum
        , sum(amount) as amount
    from {{ ref('aux__stg_referral_fees_san_adjustments') }}
    where household_id is not null
    group by 1
    order by 1
)

select
    a.yearmo
    , a.effective_date
    , a.cnt
    , a.adjustments                            as adjustments_applied
    , b.amount                                 as adjustments_source
    , adjustments_applied - adjustments_source as adjustments_difference
from cte_san as a
left join cte_adj as b
    on a.yearmo::int = b.period_datenum::int
where a.effective_date >= current_date() - 30
order by 1 , 2
