with cte_flyer as (
    select
        effective_date
        , account_number
    from {{ ref('fixflyer_options__stg_accounts') }}
    where is_head_for_day = 1
    group by 1 , 2
)

select a.*
from {{ ref('nml_fidelity_mwa_trades') }} as a
inner join cte_flyer as b
    on a.effective_date = b.effective_date
    and a.account_number = b.account_number
where 1 = 1
