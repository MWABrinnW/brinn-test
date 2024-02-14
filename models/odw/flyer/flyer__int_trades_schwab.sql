with cte_flyer as (
    select
        effective_date
        , account_no as account_number
    from {{ ref('flyer__stg_sod_accounts_history') }}
    where is_head_for_day = 1 and custodian ilike 'schwab'
    group by 1 , 2
)
, cte_allocations as (
    select account_number, execution_date as trade_date
    from {{ ref('fourforty__int_orders_allocations') }}
    group by 1,2

    union

    select member_account as account_number, trading_session_date as trade_date
    from {{ ref('flyer__stg_orders_allocations') }}
    group by 1,2
)

select a.*
    , case when b.account_number is not null then 1 else 0 end as is_in_sod
    , case when c.account_number is not null then 1 else 0 end as is_in_allocations
from {{ ref('nml_schwab_trades') }} as a
left join cte_flyer as b
    on a.effective_date = b.effective_date
    and a.account_number = b.account_number
left join cte_allocations as c
    on a.effective_date = c.trade_date
    and a.account_number = c.account_number
where 1 = 1
qualify dense_rank() over(partition by a.effective_date, a.account_number order by a._source_file) = 1
