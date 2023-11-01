select
    a.*
from {{ ref('nml_schwab_trades') }} a
join {{ ref('fixflyer_options__stg_accounts') }} b
    on a.effective_date = b.effective_date
    and a.account_number = b.account_number
    and b.is_latest = 1
where 1=1
