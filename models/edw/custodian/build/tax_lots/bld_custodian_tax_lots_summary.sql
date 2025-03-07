select
    effective_date
    , custodian
    , firm_source
    , count(*)                       as cnt
    , count(distinct account_number) as accounts
from {{ ref('bld_custodian_tax_lots') }}
where effective_date >= current_date - 30
group by all
