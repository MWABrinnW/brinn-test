select *
from {{ ref('schwab__base_fa_master_relationships') }}
where 1=1
  and firm = 'mps'
