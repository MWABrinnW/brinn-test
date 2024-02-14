select *
from {{ ref('flyer__int_trades_fidelity') }}

union all

select *
from {{ ref('flyer__int_trades_schwab') }}
