select
    effective_date
    , account_custodial
    , cusip
    , sum(current_cost_unadjusted_wash) as cost_basis
from {{ ref('fidelity_swag_history__vw_tlaopen_tax_accounting') }}
where 1 = 1
group by effective_date , account_custodial , cusip
