with cte_moxy_accounts as (
    select
        portfolio_id
        , trading_id
        , groups
        , is_intraday_import
    from {{ ref('moxy__int_accounts_build') }}
    group by all
)

-- Each group assignment is on the account record in an array.
-- We only assign the "ACTIVE" group nowadays but this flatten would
-- apply if any other groups are included upstream. IT-15159
select
    g.value::text(200)     as "GrpName"
    , a.portfolio_id       as "PortID"
    , 0::int               as "IsGroup"
    , null::text           as "Description"
    , 0::int               as "GrpTypeID"
    , null::text           as "IsSettleAcct"
    , null::text           as "TradingTypeID"
    , null::text           as "ManagerID"
    , null::text           as "IsConsolidated"
    , null::text           as "UserDef1"
    , null::text           as "UserDef2"
    , null::text           as "UserDef3"
    , null::text           as "Closing Method"--noqa: RF05
    , null::text           as "Settle Currency"--noqa: RF05
    , null::text           as "Account Status"--noqa: RF05
    , null::text           as "Account Type"--noqa: RF05
    , null::text           as "Is Taxable"--noqa: RF05
    , null::text           as "Investment Goal"--noqa: RF05
    , null::text           as "Cash Buffer"--noqa: RF05
    , null::text           as "Cash Buffer Pct."--noqa: RF05
    , null::text           as "PrimaryOwner"
    , null::text           as "StartDate"
    , null::text           as "DomicileCountry"
    , null::text           as "CustID"
    , null::text           as "LongTaxRate"
    , null::text           as "ShortTaxRate"
    , null::text           as "LongLossCarryover"
    , null::text           as "ShortLossCarryover"
    , null::text           as "UserDef4"
    , null::text           as "UserDef5"
    , null::text           as "UserDef6"
    , null::text           as "UserDef7"
    , null::text           as "UserDef8"
    , null::text           as "UserDef9"
    , null::text           as "UserDef10"
    , null::text           as "UserDef11"
    , null::text           as "UserDef12"
    , null::text           as "UserDef13"
    , null::text           as "UserDef14"
    , null::text           as "UserDef15"
    , null::text           as "UserDef16"
    , null::text           as "UserDef17"
    , null::text           as "UserDef18"
    , null::text           as "UserDef19"
    , null::text           as "UserDef20"
    , null::text           as "UserDef21"
    , null::text           as "UserDef22"
    , null::text           as "UserDef23"
    , null::text           as "UserDef24"
    , null::text           as "UserDef25"
    , null::text           as "UserDef26"
    , null::text           as "UserDef27"
    , null::text           as "UserDef28"
    , null::text           as "UserDef29"
    , null::text           as "UserDef30"
    , null::text           as "UserDef31"
    , null::text           as "UserDef32"
    , null::text           as "UserDef33"
    , null::text           as "UserDef34"
    , 1::int               as "UserDef35"
    , a.is_intraday_import as is_intraday_import
    , a.trading_id         as trading_id
from cte_moxy_accounts as a
, lateral flatten(input => a.groups) as g
