select *
from {{ ref('fixflyer_options__int_trades_fidelity') }}

union all

select *
from {{ ref('fixflyer_options__int_trades_schwab') }}
