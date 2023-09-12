select *
from {{ ref('schwab__base_open_positions_taxable') }}

union all

select *
from {{ ref('schwab__base_open_positions_nontaxable') }}
