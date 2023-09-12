select *
from {{ ref('schwab__base_open_lots_taxable') }}

union all

select *
from {{ ref('schwab__base_open_lots_nontaxable') }}
