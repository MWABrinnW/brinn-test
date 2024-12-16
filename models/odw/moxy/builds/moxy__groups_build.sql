with cte_moxy_accounts as (
    select
        portfolio_id
        , groups
        , is_intraday_import
    from {{ ref('moxy__int_accounts_build') }}
)

-- Each group assignment is on the account record in an array.
-- We only assign the "ACTIVE" group nowadays but this flatten would
-- apply if any other groups are included upstream. IT-15159
select
    g.value::text(200)     as group_name
    , a.portfolio_id       as portfolio_id
    , a.is_intraday_import as is_intraday_import
from cte_moxy_accounts as a
, lateral flatten(input => a.groups) as g
