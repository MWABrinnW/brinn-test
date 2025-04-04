select
    lower(portfolio_id)        as "PortID"
    , name                     as "PortName"
    , account_number           as "AcctID"
    , 'None - Intraday Import' as "Error Type"--noqa:RF05
from {{ ref('moxy__accounts_build_flat') }}
where is_intraday_import = 1
