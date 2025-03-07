select
    a.*
    , null::text(200) as aum_classification--sourced from crm
    , null::int       as is_erisa--sourced from custodian
    , null::int       as is_discretionary--sourced from custodian
    , null::int       as is_voting_proxied--sourced from custodian
    , null::int       as is_prime_broker
    , null::int       as is_broker_dealer_account
    , null::text(200) as cost_basis_method
    , {{ col_is_head(
        reference=ref('orion__accounts'),
        source_date_col='a.effective_date'
        ) }}
    , {{ col_is_current(date_col='a.effective_date') }}
from {{ ref('orion__accounts') }} as a
